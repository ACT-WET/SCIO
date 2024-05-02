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
    
    //No Connection View
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionLbl:  UILabel!
    
    @IBOutlet weak var frceDosingSwitch: UISwitch!
    @IBOutlet weak var makeupDisableSwitch: UISwitch!
    //Object References
    let logger = Logger()
    
    var currentSetpoints = WATER_LEVEL_SENSOR_VALUES()
    var ls1001liveSensorValues  = WATER_LEVEL_SENSOR_VALUES()
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
        readLVCmdRegistersFromPLC()
        
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
            if belowL >= 0 && belowL <= 60 {
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
            if makeup >= 0 && makeup <= 1440 {
                 CENTRAL_SYSTEM?.writeRegister(register: WATER_MAKEUP_TIMEROUT_TIMER, value: makeup)
            }
        }
        
        readTimersFromPLC()
    }
    
    func readLVCmdRegistersFromPLC(){
        CENTRAL_SYSTEM!.readRegister(length: 4, startingRegister: Int32(WATER_LEVEL_LV1001.startAddr),  completion: { (success, response) in
                 
                 guard success == true else { return }
                 let cmdArrays = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                 self.ls1001liveSensorValues.cmd_disableMkeup = cmdArrays[3]
                 self.ls1001liveSensorValues.cmd_overrideFrceDosing = cmdArrays[4]
            
                 if self.ls1001liveSensorValues.cmd_disableMkeup == 1{
                    self.makeupDisableSwitch.isOn = false
                 }
                 if self.ls1001liveSensorValues.cmd_disableMkeup == 0{
                    self.makeupDisableSwitch.isOn = true
                 }
                 if self.ls1001liveSensorValues.cmd_overrideFrceDosing == 1{
                    self.frceDosingSwitch.isOn = true
                 }
                 if self.ls1001liveSensorValues.cmd_overrideFrceDosing == 0{
                    self.frceDosingSwitch.isOn = false
                 }
                 
             })
    
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
            CENTRAL_SYSTEM!.readRegister(length: 1, startingRegister: Int32(WATER_MAKEUP_TIMEROUT_TIMER),  completion: { (success, response) in
                
                guard success == true else { return }
                
                self.currentSetpoints.makeup_timeout_timer =  Int(truncating: response![0] as! NSNumber)
                self.makeupTimeout.text       = "\(self.currentSetpoints.makeup_timeout_timer)"
            })
   
    }
    
    @IBAction func sendCmdMakeupSwitch(_ sender: UISwitch) {
        if self.ls1001liveSensorValues.cmd_disableMkeup == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_iPAD_DISABLE, value: 0)
            self.makeupDisableSwitch.isOn = true
        }
        if self.ls1001liveSensorValues.cmd_disableMkeup == 0{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_iPAD_DISABLE, value: 1)
            self.makeupDisableSwitch.isOn = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.readLVCmdRegistersFromPLC()
        }
        
        
    }
    
    @IBAction func sendCmdDosingSwitch(_ sender: UISwitch) {
        if self.ls1001liveSensorValues.cmd_overrideFrceDosing == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_iPAD_DOSING, value: 0)
            self.frceDosingSwitch.isOn = false
        }
        if self.ls1001liveSensorValues.cmd_overrideFrceDosing == 0{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_iPAD_DOSING, value: 1)
            self.frceDosingSwitch.isOn = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.readLVCmdRegistersFromPLC()
        }
    }
}
