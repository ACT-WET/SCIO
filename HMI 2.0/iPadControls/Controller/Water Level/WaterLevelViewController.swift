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
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var handModeView: UIView!
    //MARK: - Water Level Sensors Faults
    @IBOutlet weak var lt1001View: UIView!
    @IBOutlet weak var fillTimeout:                         UIImageView!
    
    //MARK: - Class Reference Objects -- Dependencies
    
    private let logger          =          Logger()
    private let helper          =          Helper()
    private let utility         =         Utilits()
    private let operationManual = OperationManual()
    
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
        self.handModeView.isHidden = true
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
            
                
            //print(statusArrValues)
            self.parseLV1001Data()
        })
    }
    
    
    
    
    /***************************************************************************
     * Function :  parseWaterLevelFaults
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func parseLV1001Data(){
        
               let abvH = self.lt1001View.viewWithTag(2001) as? UIImageView
               let blwL = self.lt1001View.viewWithTag(2002) as? UIImageView
               let blwLL = self.lt1001View.viewWithTag(2003) as? UIImageView
               let blwLLL = self.lt1001View.viewWithTag(2004) as? UIImageView
               let valveStatus = self.lt1001View.viewWithTag(2005) as? UILabel
               let startCmdActive = self.lt1001View.viewWithTag(2006) as? UIImageView
               let stopCmdActive = self.lt1001View.viewWithTag(2007) as? UIImageView
               let faulted = self.lt1001View.viewWithTag(2008) as? UIImageView
               let timeOut = self.lt1001View.viewWithTag(2009) as? UIImageView
               let malfunction = self.lt1001View.viewWithTag(2010) as? UIImageView
               let eStop = self.lt1001View.viewWithTag(2011) as? UIImageView
        
            
               if self.ls1001liveSensorValues.above_High == 1
               {
                   abvH?.image = #imageLiteral(resourceName: "red")
               } else {
                   abvH?.image = #imageLiteral(resourceName: "green")
               }
               
               if self.ls1001liveSensorValues.below_l == 1
               {
                   blwL?.image = #imageLiteral(resourceName: "red")
               } else {
                   blwL?.image = #imageLiteral(resourceName: "green")
               }
               
               if self.ls1001liveSensorValues.below_ll == 1
               {
                   blwLL?.image = #imageLiteral(resourceName: "red")
               } else {
                   blwLL?.image = #imageLiteral(resourceName: "green")
               }
        
               if self.ls1001liveSensorValues.below_lll == 1
               {
                   blwLLL?.image = #imageLiteral(resourceName: "red")
               } else {
                   blwLLL?.image = #imageLiteral(resourceName: "green")
               }
        
               if self.ls1001liveSensorValues.faulted == 1
               {
                   faulted?.image = #imageLiteral(resourceName: "red")
                   waterLevelIcon.image = #imageLiteral(resourceName: "waterlevel_outline-red")
               } else {
                   faulted?.image = #imageLiteral(resourceName: "green")
                   waterLevelIcon.image = #imageLiteral(resourceName: "waterlevel_outline-gray")
               }
        
               if self.ls1001liveSensorValues.waterMakeupTimeout == 1 {
                   timeOut?.image = #imageLiteral(resourceName: "red")
                   fillTimeout.isHidden = false
               } else {
                   timeOut?.image = #imageLiteral(resourceName: "green")
                   fillTimeout.isHidden = true
               }
               
               if self.ls1001liveSensorValues.malfunction == 1 {
                   malfunction?.image = #imageLiteral(resourceName: "red")
               } else {
                   malfunction?.image = #imageLiteral(resourceName: "green")
               }
             
               if self.ls1001liveSensorValues.eStop == 1 {
                   eStop?.image = #imageLiteral(resourceName: "red")
               } else {
                   eStop?.image = #imageLiteral(resourceName: "green")
               }
               
               if self.ls1001liveSensorValues.startCmdActive == 1 {
                   startCmdActive?.image = #imageLiteral(resourceName: "green")
               } else {
                   startCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on")
               }
        
               if self.ls1001liveSensorValues.stopCmdActive == 1 {
                   stopCmdActive?.image = #imageLiteral(resourceName: "green")
               } else {
                   stopCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on")
               }
               
               if self.ls1001liveSensorValues.valveOpen == 1 {
                   valveStatus?.text = "OPEN"
               } else {
                   valveStatus?.text = "CLOSE"
               }
        
               if self.ls1001liveSensorValues.cmd_HandStart == 1 {
                  startBtn.isEnabled = false
               } else {
                  startBtn.isEnabled = true
               }
        
               if self.ls1001liveSensorValues.cmd_HandStop == 1 {
                  stopBtn.isEnabled = false
               } else {
                  stopBtn.isEnabled = true
               }
        
               if self.ls1001liveSensorValues.inAuto == 1 {
                  autoHandModeImgView.image = #imageLiteral(resourceName: "autoMode")
                  autoHandModeImgView.rotate360Degrees(animate: true)
                  self.handModeView.isHidden = true
               }
        
               if self.ls1001liveSensorValues.inHand == 1 {
                   autoHandModeImgView.rotate360Degrees(animate: false)
                   autoHandModeImgView.image = #imageLiteral(resourceName: "handMode")
                   self.handModeView.isHidden = false
               }
    }
    @IBAction func sendStartCmd(_ sender: UIButton) {
      CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDSTART, value: 1)
    }
    
    @IBAction func sendStopCmd(_ sender: UIButton) {
      CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDSTOP, value: 1)
    }
    @IBAction func sendAutoHandCmd(_ sender: UIButton) {
        if self.ls1001liveSensorValues.inAuto == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDMODE, value: 1)
        }
        if self.ls1001liveSensorValues.inHand == 1{
            CENTRAL_SYSTEM?.writeBit(bit: CMD_HANDMODE, value: 0)
        }
    }
    @IBAction func sendFaultResetCmd(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: CMD_FAULTRESET, value: 1)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
