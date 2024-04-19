//=================================== ABOUT ===================================

/*
 *  @FILE:          WaterLevelSettingsViewController.swift
 *  @AUTHOR:        Arpi Derm
 *  @RELEASE_DATE:  July 28, 2017, 4:13 PM
 *  @Description:   This Module sets all timer and sensor presets for
 *                  water level screen
 *  @VERSION:       2.0.0
 */

 /***************************************************************************
 *
 * PROJECT SPECIFIC CONFIGURATION
 *
 * 1 : Water Level Settrings screen configuration parameters located 
 *     in specs.swift file should be modified to match the PLC registers
 *     provided by the controls engineer
 *
 ***************************************************************************/

import UIKit

class WaterLevelSettingsViewController: UIViewController{
    
    
    //Timer Delay SP
    @IBOutlet weak var abovHSPDelay:    UITextField!
    @IBOutlet weak var belowLSPDelay:   UITextField!
    @IBOutlet weak var belowLLSPDelay:  UITextField!
    @IBOutlet weak var belowLLLSPDelay:  UITextField!
    @IBOutlet weak var makeupTimeout:   UITextField!
    @IBOutlet weak var lsllDelayTimer:  UITextField!
    @IBOutlet weak var ls201llDelayTimer:  UITextField!
    @IBOutlet weak var ls301llDelayTimer:  UITextField!
    
    @IBOutlet weak var lt3001ScaledVal:   UILabel!
    @IBOutlet weak var lt3001ScaledMin:   UITextField!
    @IBOutlet weak var lt3001ScaledMax:   UITextField!
    @IBOutlet weak var lt3001abvHSP:   UITextField!
    @IBOutlet weak var lt3001blwLSP:   UITextField!
    @IBOutlet weak var lt3001blwLLSP:   UITextField!
    @IBOutlet weak var lt3001blwLLLSP:   UITextField!
    
    //No Connection View
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionLbl:  UILabel!
    
    //Object References
    let logger = Logger()
    
    var currentSetpoints = WATER_LEVEL_SENSOR_VALUES()
    var lt3001liveSensorValues  = WATER_LEVEL_SENSOR_VALUES()
    var LT1001SetPoints = [Double]()
    var readLT1001once = false
    var readLT1002once = false
    var readLT1003once = false
    var readCurrentSPOnce = false
    private var centralSystem = CentralSystem()
    /***************************************************************************
     * Function :  viewDidLoad
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewDidLoad(){
        
        super.viewDidLoad()

    }
    
    /***************************************************************************
     * Function :  viewWillAppear
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewWillAppear(_ animated: Bool) {
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        constructSaveButton()
        readTimersFromPLC()
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    /***************************************************************************
     * Function :  constructSaveButton
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }


    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            noConnectionView.isUserInteractionEnabled = false
            
            //Now that the connection is established, run functions
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_SCALED_VALUE), length: 2, completion: { (success, response) in
               guard success == true else { return }
               let scaledVal = Float(response)
               self.lt3001ScaledVal.text =  String(format: "%.2f", scaledVal!)
            })
            
        } else {
            noConnectionView.alpha = 1
            if plcConnection == CONNECTION_STATE_FAILED {
                noConnectionLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                noConnectionLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    

    
    /***************************************************************************
     * Function :  saveSetpoints
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @objc private func saveSetpoints(){
       saveTimerSetpointDelaysToPLC()
    }
    
    /***************************************************************************
     * Function :  saveSetpointDelaysToPLC
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func saveTimerSetpointDelaysToPLC(){
        if let aboveHiSPDelay = abovHSPDelay.text, !aboveHiSPDelay.isEmpty,
           let aboveHI = Int(aboveHiSPDelay) {
            if aboveHI >= 0 && aboveHI <= 5 {
               CENTRAL_SYSTEM?.writeRegister(register: WATER_LEVEL_ABOVE_H_DELAY_TIMER, value: aboveHI)
            }
        }
        
        if let belowLSPDelay = belowLSPDelay.text, !belowLSPDelay.isEmpty,
           let belowL = Int(belowLSPDelay) {
            if belowL >= 0 && belowL <= 5 {
                CENTRAL_SYSTEM?.writeRegister(register: WATER_LEVEL_BELOW_L_TIMER, value: belowL)
            }
        }
        
        if let belowLLSPDelay  = belowLLSPDelay.text, !belowLLSPDelay.isEmpty,
           let belowLL = Int(belowLLSPDelay) {
            if belowLL >= 0 && belowLL <= 60 {
                CENTRAL_SYSTEM?.writeRegister(register: WATER_LEVEL_BELOW_LL_TIMER, value: belowLL)
            }
        }
        
        if let belowLLLSPDelay  = belowLLLSPDelay.text, !belowLLLSPDelay.isEmpty,
           let belowLLL = Int(belowLLLSPDelay) {
            if belowLLL >= 0 && belowLLL <= 60 {
                CENTRAL_SYSTEM?.writeRegister(register: WATER_LEVEL_BELOW_LLL_TIMER, value: belowLLL)
            }
        }

        if let makeupTimeout = makeupTimeout.text, !makeupTimeout.isEmpty,
           let makeup = Int(makeupTimeout) {
            if makeup >= 0 && makeup <= 24 {
                 CENTRAL_SYSTEM?.writeRegister(register: WATER_MAKEUP_TIMEROUT_TIMER, value: makeup)
            }
        }
        
        if let lsllDelay = lsllDelayTimer.text, !lsllDelay.isEmpty,
           let lsllD = Int(lsllDelay) {
            if lsllD >= 0 {
                 CENTRAL_SYSTEM?.writeRegister(register: LSLL1001_DELAYTIMER, value: lsllD)
            }
        }
        if let ls201llDelay = ls201llDelayTimer.text, !ls201llDelay.isEmpty,
           let lsllD = Int(ls201llDelay) {
            if lsllD >= 0 {
                 CENTRAL_SYSTEM?.writeRegister(register: LSLL2201_DELAYTIMER, value: lsllD)
            }
        }
        if let ls301llDelay = ls301llDelayTimer.text, !ls301llDelay.isEmpty,
           let lsllD = Int(ls301llDelay) {
            if lsllD >= 0 {
                 CENTRAL_SYSTEM?.writeRegister(register: LSLL2301_DELAYTIMER, value: lsllD)
            }
        }
        //LT2001
        
        if let scalMin = lt3001ScaledMin.text, !scalMin.isEmpty,
           let minValue = Float(scalMin) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_LEVEL_SCALED_MIN, value: minValue)
        }
        
        if let scalMax = lt3001ScaledMax.text, !scalMax.isEmpty,
           let maxValue = Float(scalMax) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_LEVEL_SCALED_MAX, value: maxValue)
        }
        
        if let aboveH = lt3001abvHSP.text, !aboveH.isEmpty,
           let aboveHSP = Float(aboveH) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_ABOVE_HI, value: aboveHSP)
        }

        if let belowL = lt3001blwLSP.text, !belowL.isEmpty,
           let belowLSP = Float(belowL) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_LEVEL_BELOW_L, value: belowLSP)
        }

        if let belowLL = lt3001blwLLSP.text, !belowLL.isEmpty,
           let belowLLSP = Float(belowLL) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_LEVEL_BELOW_LL, value: belowLLSP)
        }
        
        if let belowLLL = lt3001blwLLLSP.text, !belowLLL.isEmpty,
           let belowLLLSP = Float(belowLLL) {

           CENTRAL_SYSTEM?.writeRealValue(register: LT1001_WATER_LEVEL_BELOW_LLL, value: belowLLLSP)
        }
        readTimersFromPLC()
    }

    
    /***************************************************************************
     * Function :  readTimersFromPLC
     * Input    :  none
     * Output   :  none
     * Comment  :  Reads the timer values and passes to the settings page
     ***************************************************************************/
  
    
    private func readTimersFromPLC(){
        

            CENTRAL_SYSTEM!.readRegister(length: Int32(WATER_LEVEL_TIMER_BITS.count), startingRegister: Int32(WATER_LEVEL_TIMER_BITS.startBit),  completion: { (success, response) in
                
                guard success == true else { return }
                
                self.currentSetpoints.above_high_timer =  Int(truncating: response![0] as! NSNumber)
                self.currentSetpoints.below_l_timer   =  Int(truncating: response![1] as! NSNumber)
                self.currentSetpoints.below_ll_timer  =  Int(truncating: response![2] as! NSNumber)
                self.currentSetpoints.below_lll_timer  =  Int(truncating: response![3] as! NSNumber)
                

                self.abovHSPDelay.text       = "\(self.currentSetpoints.above_high_timer)"
                self.belowLSPDelay.text      = "\(self.currentSetpoints.below_l_timer)"
                self.belowLLSPDelay.text     = "\(self.currentSetpoints.below_ll_timer)"
                self.belowLLLSPDelay.text    = "\(self.currentSetpoints.below_lll_timer)"
            })
            CENTRAL_SYSTEM!.readRegister(length: Int32(WATER_LEVEL_LSLL_TIMER_BITS.count), startingRegister: Int32(WATER_LEVEL_LSLL_TIMER_BITS.startBit),  completion: { (success, response) in
                
                guard success == true else { return }
                
                self.currentSetpoints.makeup_timeout_timer = Int(truncating: response![0] as! NSNumber)
                self.currentSetpoints.lsll_delayTimer = Int(truncating: response![4] as! NSNumber)
                self.currentSetpoints.ls2201_delayTimer = Int(truncating: response![5] as! NSNumber)
                self.currentSetpoints.ls2301_delayTimer = Int(truncating: response![6] as! NSNumber)
                
                self.makeupTimeout.text          = "\(self.currentSetpoints.makeup_timeout_timer)"
                self.lsllDelayTimer.text         = "\(self.currentSetpoints.lsll_delayTimer)"
                self.ls201llDelayTimer.text      = "\(self.currentSetpoints.ls2201_delayTimer)"
                self.ls301llDelayTimer.text      = "\(self.currentSetpoints.ls2301_delayTimer)"
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_ABOVE_HI), length: 2, completion: { (success, response) in
               guard success == true else { return }
               let abvH = Float(response)
               self.lt3001abvHSP.text =  String(format: "%.2f", abvH!)
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_BELOW_L), length: 2, completion: { (success, response) in
               guard success == true else { return }
                let blwL = Float(response)
               self.lt3001blwLSP.text =  String(format: "%.2f", blwL!)
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_BELOW_LL), length: 2, completion: { (success, response) in
               guard success == true else { return }
                let blwLL = Float(response)
               self.lt3001blwLLSP.text =  String(format: "%.2f", blwLL!)
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_BELOW_LLL), length: 2, completion: { (success, response) in
               guard success == true else { return }
                let blwLLL = Float(response)
               self.lt3001blwLLLSP.text =  String(format: "%.2f", blwLLL!)
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_SCALED_MIN), length: 2, completion: { (success, response) in
               guard success == true else { return }
               let minVal = Float(response)
               self.lt3001ScaledMin.text =  String(format: "%.2f", minVal!)
            })
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1001_WATER_LEVEL_SCALED_MAX), length: 2, completion: { (success, response) in
               guard success == true else { return }
               let maxVal = Float(response)
               self.lt3001ScaledMax.text =  String(format: "%.2f", maxVal!)
            })
   
    }
}
