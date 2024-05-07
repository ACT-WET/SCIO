//=================================== ABOUT ===================================

/*
 *  @FILE:          WaterLevelViewController.swift
 *  @AUTHOR:        Arpi Derm
 *  @RELEASE_DATE:  July 28, 2017, 4:13 PM
 *  @Description:   This Module reads all water level sensor values and
 *                  displays on the screen
 *  @VERSION:       2.0.0
 */

/***************************************************************************
 *
 * PROJECT SPECIFIC CONFIGURATION
 *
 * 1 : Water Level screen configuration parameters located in specs.swift file
 *     should be modified
 * 2 : readWaterLevelLiveValues function should be modified based on required
 *     value readings
 * 3 : Basin images should be replaced according to project drawings.
 *     Note: The image names should remain the same as what is provied in the
 *           project workspace image files
 * 4 : parseWaterLevelFaults() function should be modified based on required
 *     fault readings
 ***************************************************************************/


import UIKit


class WaterLevelViewController: UIViewController{
    
    //MARK: - UI View Outlets
    
    @IBOutlet weak var waterLevelIcon:                      UIImageView!
    @IBOutlet weak var noConnectionView:                    UIView!
    @IBOutlet weak var noConnectionErrorLbl:                UILabel!
    
    @IBOutlet weak var autoHandModeImgView: UIImageView!
    @IBOutlet weak var autoHandBtn: UIButton!
    //MARK: - Water Level Sensors Faults
    @IBOutlet weak var fillTimeout:                         UIImageView!
    
    //MARK: - Class Reference Objects -- Dependencies
    
    private let logger          =          Logger()
    private let helper          =          Helper()
    private let utility         =         Utilits()
    private let operationManual = OperationManual()
    var readOnce = 0
    
    //MARK: - Data Structures
    
    private var langData          = Dictionary<String, String>()
    private var ls1001liveSensorValues  = WATER_LEVEL_SENSOR_VALUES()
    private var centralSystem = CentralSystem()
    private var acquiredTimersFromPLC = 0
    
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
     * Function :  viewDidAppear
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewWillAppear(_ animated: Bool){
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
         //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(WaterLevelViewController.checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        //Configure Water Level Screen
        configureWaterLevel()
        //Configure WaterLeveScreen Text Content Based On Device Language
        configureScreenTextContent()

        
    }
    
    /***************************************************************************
     * Function :  viewDidDisappear
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewWillDisappear(_ animated: Bool){
        
        NotificationCenter.default.removeObserver(self)
        
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
            readWaterLevelLiveValues()
            
        } else {
            noConnectionView.alpha = 1
            if plcConnection == CONNECTION_STATE_FAILED {
                noConnectionErrorLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                noConnectionErrorLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    
    

    /***************************************************************************
     * Function :  configureWaterLevel
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func configureWaterLevel(){
        
        acquiredTimersFromPLC = 0
        
    }
    
    /***************************************************************************
     * Function :  configureScreenTextContent
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func configureScreenTextContent(){
        
        langData = self.helper.getLanguageSettigns(screenName: WATER_LEVEL_LANGUAGE_DATA_PARAM)
        self.navigationItem.title = "WATER LEVEL"
               
    }
    
 
    
    /***************************************************************************
     * Function :  readWaterLevelLiveValues
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func readWaterLevelLiveValues(){
        
        CENTRAL_SYSTEM?.readRegister(length: Int32(WATER_LEVEL_LV1001.count) , startingRegister: Int32(WATER_LEVEL_LV1001.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            self.ls1001liveSensorValues.valveEnabled = statusArrValues[0]
            self.ls1001liveSensorValues.valveOpen = statusArrValues[1]
            self.ls1001liveSensorValues.faulted = statusArrValues[2]
            self.ls1001liveSensorValues.inAuto = statusArrValues[3]
            self.ls1001liveSensorValues.inHand = statusArrValues[4]
            self.ls1001liveSensorValues.startCmdActive = statusArrValues[5]
            self.ls1001liveSensorValues.stopCmdActive = statusArrValues[6]
            self.ls1001liveSensorValues.waterMakeupTimeout = statusArrValues[7]
            self.ls1001liveSensorValues.malfunction = statusArrValues[8]
            self.ls1001liveSensorValues.eStop = statusArrValues[9]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.ls1001liveSensorValues.cmd_HandMode = cmdArrValues[0]
            self.ls1001liveSensorValues.cmd_HandStart = cmdArrValues[1]
            self.ls1001liveSensorValues.cmd_HandStop = cmdArrValues[2]
            self.ls1001liveSensorValues.cmd_disableMkeup = cmdArrValues[3]
            self.ls1001liveSensorValues.cmd_overrideFrceDosing = cmdArrValues[4]
            self.ls1001liveSensorValues.cmd_deviceFaultReset = cmdArrValues[5]
            
            let faulted = self.view.viewWithTag(2005) as? UILabel
            let timeOut = self.view.viewWithTag(2006) as? UILabel
            let malfunction = self.view.viewWithTag(2007) as? UILabel
            let eStop = self.view.viewWithTag(2008) as? UILabel
            
           if self.ls1001liveSensorValues.faulted == 1
           {
               faulted?.isHidden = false
            self.waterLevelIcon.image = #imageLiteral(resourceName: "waterlevel_outline-red")
           } else {
               faulted?.isHidden = true
            self.waterLevelIcon.image = #imageLiteral(resourceName: "waterlevel_outline-gray")
           }
    
           if self.ls1001liveSensorValues.waterMakeupTimeout == 1 {
               timeOut?.isHidden = false
            self.fillTimeout.isHidden = false
           } else {
               timeOut?.isHidden = true
            self.fillTimeout.isHidden = true
           }
           
           if self.ls1001liveSensorValues.malfunction == 1 {
               malfunction?.isHidden = false
           } else {
               malfunction?.isHidden = true
           }
         
           if self.ls1001liveSensorValues.eStop == 1 {
               eStop?.isHidden = false
           } else {
               eStop?.isHidden = true
           }
        
           
    
           
            
            if self.readOnce == 0{
                self.parseLV1001Data()
                self.readOnce = 1
            }
                
            //print(statusArrValues)

        })
        
        CENTRAL_SYSTEM?.readBits(length: 4, startingRegister: 700, completion: { (success, response) in
            
            guard success == true else { return }
            
            let wabvH = Int(truncating: response![0] as! NSNumber)
            let wblwL = Int(truncating: response![1] as! NSNumber)
            let wblwLL = Int(truncating: response![2] as! NSNumber)
            let wblwLLL = Int(truncating: response![3] as! NSNumber)
            
            self.ls1001liveSensorValues.above_High = wabvH
            self.ls1001liveSensorValues.below_l = wblwL
            self.ls1001liveSensorValues.below_ll = wblwLL
            self.ls1001liveSensorValues.below_lll = wblwLLL
            
            let abvH = self.view.viewWithTag(2001) as? UIImageView
            let blwL = self.view.viewWithTag(2002) as? UIImageView
            let blwLL = self.view.viewWithTag(2003) as? UIImageView
            let blwLLL = self.view.viewWithTag(2004) as? UIImageView
            
                   if self.ls1001liveSensorValues.above_High == 1
                   {
                       abvH?.image = #imageLiteral(resourceName: "red")
                   } else {
                       abvH?.image = #imageLiteral(resourceName: "background")
                   }
                   
                   if self.ls1001liveSensorValues.below_l == 1
                   {
                       blwL?.image = #imageLiteral(resourceName: "red")
                   } else {
                       blwL?.image = #imageLiteral(resourceName: "background")
                   }
                   
                   if self.ls1001liveSensorValues.below_ll == 1
                   {
                       blwLL?.image = #imageLiteral(resourceName: "red")
                   } else {
                       blwLL?.image = #imageLiteral(resourceName: "background")
                   }
            
                   if self.ls1001liveSensorValues.below_lll == 1
                   {
                       blwLLL?.image = #imageLiteral(resourceName: "red")
                   } else {
                       blwLLL?.image = #imageLiteral(resourceName: "background")
                   }
        })
    }
    
    
    
    
    /***************************************************************************
     * Function :  parseWaterLevelFaults
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func parseLV1001Data(){
       if self.ls1001liveSensorValues.valveOpen == 1{
           autoHandBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
           autoHandBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
       }
       if self.ls1001liveSensorValues.valveOpen == 0{
           autoHandBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
           autoHandBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
       }

       if self.ls1001liveSensorValues.inAuto == 1 {
          autoHandModeImgView.image = #imageLiteral(resourceName: "autoMode")
          autoHandModeImgView.rotate360Degrees(animate: true)
          self.autoHandBtn.isUserInteractionEnabled = false
       }

       if self.ls1001liveSensorValues.inHand == 1 {
           autoHandModeImgView.rotate360Degrees(animate: false)
           autoHandModeImgView.image = #imageLiteral(resourceName: "handMode")
           self.autoHandBtn.isUserInteractionEnabled = true
       }
    }
    @IBAction func sendValveOpenCloseCmd(_ sender: UIButton) {
      if self.ls1001liveSensorValues.valveOpen == 1{
          CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDSTOP, value: 1)
      } else {
          CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDSTART, value: 1)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
          self.readOnce = 0
      }
    }
    
    @IBAction func sendAutoHandCmd(_ sender: UIButton) {
        if self.ls1001liveSensorValues.inAuto == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDMODE, value: 1)
        }
        if self.ls1001liveSensorValues.inHand == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDMODE, value: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
        }
    }
    @IBAction func sendFaultResetCmd(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: CMD_FAULTRESET, value: 1)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
