//=================================== ABOUT ===================================

/*
 *  @FILE:          WaterQualityViewController.swift
 *  @AUTHOR:        Arpi Derm
 *  @RELEASE_DATE:  July 28, 2017, 4:13 PM
 *  @Description:   This Module reads all water quality data, parses them
 *                  and generates corresponding chart data
 *  @VERSION:       2.0.0
 */

 /***************************************************************************
 *
 * PROJECT SPECIFIC CONFIGURATION
 *
 * 1 : Water Quality screen configuration parameters located in specs.swift file
 *     should be modified
 ***************************************************************************/

import UIKit


//WQ Data Structures

class WaterQualityViewController: UIViewController{

    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var brautoHandImg: UIImageView!
    @IBOutlet weak var dumpautoHandImg: UIImageView!
    @IBOutlet weak var brValveBtn: UIButton!
    @IBOutlet weak var freezeValveBtn: UIButton!
    @IBOutlet weak var warningBtn: UIButton!
    
    @IBOutlet weak var faultBtn: UIButton!
    private var isLiveMode          = true
    private var showStoppers        =   ShowStoppers()
    private var langData            =   Dictionary<String, String>()
    private let logger   = Logger()
    private let httpComm = HTTPComm()
    private let helper   = Helper()
    var pHValues  = AI_VALUES()
    var orpValues  = AI_VALUES()
    var conductValues  = AI_VALUES()
    var broValues  = AI_VALUES()
    var at1001Values  = AI_VALUES()
    var tt1002Values  = AI_VALUES()
    var tt1003Values  = AI_VALUES()
    var brValues  = BR_VALUES()
    var dumpValValues  = FOG_MOTOR_SENSOR_VALUES()
    var readOnce = 0
    var readDOnce = 0
    override func viewDidLoad(){
        
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        setupUILabelData()
    }
    
    
    /***************************************************************************
     * Function :  viewWillDisappear
     * Input    :  none
     * Output   :  none
     * Comment  :
     *
     ***************************************************************************/
    
    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        NotificationCenter.default.removeObserver(self)
        
    }
    
    /***************************************************************************
     * Function :  setupUILabelData
     * Input    :  none
     * Output   :  none
     * Comment  :  Simply lays out the ui labels with corresponding translation
     ***************************************************************************/
    
    func setupUILabelData(){
        
        langData = helper.getLanguageSettigns(screenName: "waterQuality")
        self.navigationItem.title  = "WATER QUALITY"
    }
    
    func getWQDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(pH_SENSOR_DATAREGISTER.count), startingRegister: Int32(pH_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.pHValues.status_faulted = statusArrValues[5]
            self.pHValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.pHValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.pHValues.status_precision)
            let scaledValue = Float(self.pHValues.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2000) as? UILabel
            let faulted = self.view.viewWithTag(2003) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.pHValues.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
            
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(ORP_SENSOR_DATAREGISTER.count), startingRegister: Int32(ORP_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.orpValues.status_faulted = statusArrValues[5]
            self.orpValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.orpValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.orpValues.status_precision)
            let scaledValue = Float(self.orpValues.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2001) as? UILabel
            let faulted = self.view.viewWithTag(2004) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.orpValues.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
            
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(CONDUCTIVITY_SENSOR_DATAREGISTER.count), startingRegister: Int32(CONDUCTIVITY_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.conductValues.status_faulted = statusArrValues[5]
            self.conductValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.conductValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.conductValues.status_precision)
            let scaledValue = Float(self.conductValues.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2002) as? UILabel
            let faulted = self.view.viewWithTag(2005) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.conductValues.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(AT1001_TEMP_DATAREGISTER.count), startingRegister: Int32(AT1001_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.at1001Values.status_faulted = statusArrValues[5]
            self.at1001Values.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.at1001Values.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.at1001Values.status_precision)
            let scaledValue = Float(self.at1001Values.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2006) as? UILabel
            let faulted = self.view.viewWithTag(2009) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.at1001Values.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(TT1002_TEMP_DATAREGISTER.count), startingRegister: Int32(TT1002_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.tt1002Values.status_faulted = statusArrValues[5]
            self.tt1002Values.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.tt1002Values.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.tt1002Values.status_precision)
            let scaledValue = Float(self.tt1002Values.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2007) as? UILabel
            let faulted = self.view.viewWithTag(2010) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.tt1002Values.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(TT1003_TEMP_DATAREGISTER.count), startingRegister: Int32(TT1003_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.tt1003Values.status_faulted = statusArrValues[5]
            self.tt1003Values.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.tt1003Values.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.tt1003Values.status_precision)
            let scaledValue = Float(self.tt1003Values.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2008) as? UILabel
            let faulted = self.view.viewWithTag(2011) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.tt1003Values.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(BR_SENSOR_DATAREGISTER.count), startingRegister: Int32(BR_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.broValues.status_faulted = statusArrValues[5]
            self.broValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.broValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            let divisor = pow(10,self.broValues.status_precision)
            let scaledValue = Float(self.broValues.status_ScaledVal) / Float(truncating: divisor as NSNumber)
            
            let scaledVal = self.view.viewWithTag(2012) as? UILabel
            let faulted = self.view.viewWithTag(2013) as? UILabel
            scaledVal?.text = String(format: "%.1f", scaledValue)
            self.broValues.status_faulted == 1 ? ( faulted?.isHidden = false) : (faulted?.isHidden = true)
        })
    }
    
    func getBrValveDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(BR_VALVE_DATAREGISTER.count), startingRegister: Int32(BR_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.brValues.brEnabled = statusArrValues[0]
            self.brValues.brDosing = statusArrValues[1]
            self.brValues.valveStatus = statusArrValues[2]
            self.brValues.brTimeout = statusArrValues[3]
            self.brValues.inAuto = statusArrValues[4]
            self.brValues.inHand = statusArrValues[5]
            self.brValues.startCmdActive = statusArrValues[6]
            self.brValues.stopCmdActive = statusArrValues[7]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.brValues.cmd_HandStar = cmdArrValues[1]
            self.brValues.cmd_HandStop = cmdArrValues[2]
            
            self.brValues.status_orpScaledVal = Int(truncating: response![4] as! NSNumber)
            
            if self.readOnce == 0{
               self.readOnce = 1
               if self.brValues.valveStatus == 1{
                  self.brValveBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                  self.brValveBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
               }
               if self.brValues.valveStatus == 0{
                   self.brValveBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                   self.brValveBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
               }
                if self.brValues.inAuto == 1{
                   self.brautoHandImg.image = #imageLiteral(resourceName: "autoMode")
                   self.brautoHandImg.rotate360Degrees(animate: true)
                   self.brValveBtn.isUserInteractionEnabled = false
               }
                if self.brValues.inHand == 1{
                   self.brautoHandImg.image = #imageLiteral(resourceName: "handMode")
                   self.brautoHandImg.rotate360Degrees(animate: false)
                   self.brValveBtn.isUserInteractionEnabled = true
               }
            }
            
            if self.brValues.brTimeout == 1{
                self.warningBtn.isHidden = false
            } else {
                self.warningBtn.isHidden = true
            }
            
            let orpScaledVal = self.view.viewWithTag(32) as? UILabel
            let dosing = self.view.viewWithTag(33) as? UILabel
            let enabled = self.view.viewWithTag(34) as? UILabel
            let brTimeout = self.view.viewWithTag(35) as? UILabel
            
            self.brValues.brEnabled == 1 ? (enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.brValues.brDosing == 1 ? (dosing?.isHidden = false) : (dosing?.isHidden = true)
            self.brValues.brTimeout == 1 ? (brTimeout?.isHidden = false) : (brTimeout?.isHidden = true)
            orpScaledVal?.text = String(format: "%d", self.brValues.status_orpScaledVal)
        })
    }
    
    func getDumpValveDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(FREEZE_VALVE_DATAREGISTER.count), startingRegister: Int32(FREEZE_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dumpValValues.valveEnabled = statusArrValues[0]
            self.dumpValValues.valveOpen = statusArrValues[1]
            self.dumpValValues.valveClose = statusArrValues[2]
            self.dumpValValues.valveTransition = statusArrValues[3]
            self.dumpValValues.faulted = statusArrValues[4]
            self.dumpValValues.inAuto = statusArrValues[5]
            self.dumpValValues.inHand = statusArrValues[6]
            self.dumpValValues.autoCmdActive = statusArrValues[7]
            self.dumpValValues.handCmdActive = statusArrValues[8]
            self.dumpValValues.failToOpen = statusArrValues[9]
            self.dumpValValues.failToClose = statusArrValues[10]
            self.dumpValValues.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dumpValValues.cmd_HandStartStop = cmdArrValues[1]
            
            if self.readDOnce == 0{
               self.readDOnce = 1
               if self.dumpValValues.valveOpen == 1{
                  self.freezeValveBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                  self.freezeValveBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
               }
               if self.dumpValValues.valveClose == 1{
                   self.freezeValveBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                   self.freezeValveBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
               }
                if self.dumpValValues.inAuto == 1{
                   self.dumpautoHandImg.image = #imageLiteral(resourceName: "autoMode")
                   self.dumpautoHandImg.rotate360Degrees(animate: true)
                   self.freezeValveBtn.isUserInteractionEnabled = false
               }
                if self.dumpValValues.inHand == 1{
                   self.dumpautoHandImg.image = #imageLiteral(resourceName: "handMode")
                   self.dumpautoHandImg.rotate360Degrees(animate: false)
                   self.freezeValveBtn.isUserInteractionEnabled = true
               }
            }
            
            let faulted = self.view.viewWithTag(42) as? UILabel
            let fToOpen = self.view.viewWithTag(43) as? UIImageView
            let fToClose = self.view.viewWithTag(44) as? UILabel
            let eStop = self.view.viewWithTag(45) as? UIImageView
            
            if self.dumpValValues.faulted == 1{
                self.faultBtn.isHidden = false
            } else {
                self.faultBtn.isHidden = true
            }
            
            self.dumpValValues.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dumpValValues.failToOpen == 1 ? (fToOpen?.isHidden = false) : (fToOpen?.isHidden = true)
            self.dumpValValues.failToClose == 1 ? (fToClose?.isHidden = false) : (fToClose?.isHidden = true)
            self.dumpValValues.eStop == 1 ? (eStop?.isHidden = false) : (eStop?.isHidden = true)
            
        })
    }
    
    
    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :
     *
     ***************************************************************************/
    
    @objc func checkSystemStat(){
        let (plcConnection, serverConnection) = CENTRAL_SYSTEM!.getConnectivityStat()
        
        if plcConnection == CONNECTION_STATE_CONNECTED && serverConnection == CONNECTION_STATE_CONNECTED  {
            
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            getWQDataFromPLC()
            getBrValveDataFromPLC()
            getDumpValveDataFromPLC()
            
        } else {
            noConnectionView.alpha = 1
            
            if plcConnection == CONNECTION_STATE_FAILED || serverConnection == CONNECTION_STATE_FAILED {
                if serverConnection == CONNECTION_STATE_CONNECTED {
                    noConnectionErrorLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
                } else if plcConnection == CONNECTION_STATE_CONNECTED{
                    noConnectionErrorLbl.text = "SERVER CONNECTION FAILED, PLC GOOD"
                } else {
                    noConnectionErrorLbl.text = "SERVER AND PLC CONNECTION FAILED"
                }
            }
            
            if plcConnection == CONNECTION_STATE_CONNECTING || serverConnection == CONNECTION_STATE_CONNECTING {
                if serverConnection == CONNECTION_STATE_CONNECTED {
                    noConnectionErrorLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
                } else if plcConnection == CONNECTION_STATE_CONNECTED{
                    noConnectionErrorLbl.text = "CONNECTING TO SERVER, PLC CONNECTED"
                } else {
                    noConnectionErrorLbl.text = "CONNECTING TO SERVER AND PLC.."
                }
            }
            
            if plcConnection == CONNECTION_STATE_POOR_CONNECTION && serverConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "SERVER AND PLC POOR CONNECTION"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            } else if serverConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "SERVER POOR CONNECTION, PLC CONNECTED"
            }
        }
    }
    
    @IBAction func redirectToSensorScheduler(_ sender: UIButton) {
        let sensorDetVC = UIStoryboard.init(name: "WQMultiple", bundle: nil).instantiateViewController(withIdentifier: "WQDetail") as! WQDetailViewController
        sensorDetVC.sensorNumber = sender.tag
        navigationController?.pushViewController(sensorDetVC, animated: true)
    }
    
    @IBAction func sendAutoHandCmd(_ sender: UIButton) {
        if sender.tag == 30{
            if brValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandMode, value: 1)
            }
            if brValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandMode, value: 0)
            }
        }
        if sender.tag == 40{
            if dumpValValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandMode, value: 1)
            }
            if dumpValValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandMode, value: 0)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
            self.readDOnce = 0
        }
    }
    @IBAction func sendStartStopCmd(_ sender: UIButton) {
        if sender.tag == 31{
            if self.brValues.valveStatus == 1{
                CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandStopCmd, value: 1)
            }
            if self.brValues.valveStatus == 0{
                CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandStartCmd, value: 1)
            }
        }
        if sender.tag == 41{
            if self.dumpValValues.valveOpen == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandCmd, value: 0)
            }
            if self.dumpValValues.valveClose == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandCmd, value: 1)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
            self.readDOnce = 0
        }
    }
    @IBAction func sendCmdWarningReset(_ sender: UIButton) {
        if sender.tag == 36{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdWarningReset, value: 1)
        }
        if sender.tag == 46{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdFaultReset, value: 1)
        }
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
