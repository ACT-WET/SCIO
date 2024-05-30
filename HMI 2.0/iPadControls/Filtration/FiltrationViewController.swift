//
//  FiltrationViewController.swift
//  iPadControls
//
//  Created by Jan Manalo 7/16/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit

class FiltrationViewController: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    //MARK: - Show Stoppers
    
    @IBOutlet weak var pumpButton: UIButton!
    
    @IBOutlet weak var filtrationRunningIndicator: UIImageView!
    @IBOutlet weak var cleanStrainerIndicator: UILabel!
    
    @IBOutlet weak var frequencyIndicator: UIView!
    @IBOutlet weak var frequencyIndicatorValue: UILabel!
    @IBOutlet weak var frequencySetpointBackground: UIView!
    @IBOutlet weak var pumpSchBtn: UIButton!
    
    var manulPumpGesture: UIPanGestureRecognizer!
    var backWashGesture: UIPanGestureRecognizer!
    
    //MARK: - Class Reference Objects -- Dependencies
    
    private let logger = Logger()
    private let helper = Helper()
    private let utilities = Utilits()
    private let httpComm = HTTPComm()
    
    //MARK: - Data Structures
    
    private var langData = [String : String]()
    private var iPadNumber = 0
    var pumpNumber = 101
    var pumpCmdReg = VFD101_CMD_REG
    var readOnce = 0
    private var bwashRunning = 0
    private var is24hours = true
    private var showStoppers = ShowStoppers()
    
    
    
    //MARK: - Scheduled Backwash Info that has to be added to scheduler files on server
    //NOTE: The format is  [ShowNumber,ShowStartTime,ShowNumberm,ShowStartTime,.....] Show Start Time Format: HHMM
    private var component0AlreadySelected = false
    private var component1AlreadySelected = false
    private var component2AlreadySelected = false
    private var component3AlreadySelected = false
    private var selectedDay = 0
    private var selectedHour = 0
    private var selectedMinute = 0
    private var selectedTimeOfDay = 0
    private var duration = 0  //In Minutes
    private var backWashShowNumber = 999
    private var readBackWashSpeedOnce  = false
    private var frequency: Int?
    private var manualSpeed: Int?
    private var readManualSpeedPLC = false
    private var readManualSpeedOncePLC = false
    var READ_BACKWASH_PATH = ""
    var WRITE_BACKWASH_PATH = ""
    var pumpRegister = VFD_101_DATAREGISTER.startAddr
    var pumpData = VFD_VALUES()
    //private var centralSystem = CentralSystem()
    //MARK: - View Life Cycle
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool){
        checkAMPM()
        
        //Load Backwash Duration for Backwash Scheduler
        setInitialParam()
        initializePumpGestureRecognizer()
        
        //Add notification observer to get system stat
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        self.readOnce = 0
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func setInitialParam(){
        self.navigationItem.title = "FILTRATION - 101"
        self.pumpButton.setTitle("P - 101", for: .normal)
    }
    /***************************************************************************
     * Function :  Check System Stat
     * Input    :  none
     * Output   :  none
     * Comment  :  Checks the connection to the PLC and Server.
     Add the necessary functions that's needed to be called each time
     ***************************************************************************/
    
    @objc func checkSystemStat(){
        let (plcConnection, serverConnection) = CENTRAL_SYSTEM!.getConnectivityStat()
        
        if plcConnection == CONNECTION_STATE_CONNECTED && serverConnection == CONNECTION_STATE_CONNECTED  {
            
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            getSchdeulerStatus()
            readCurrentFiltrationPumpDetails()
            
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
    
    /***************************************************************************
     * Function :  Initialize Pump Gesture Recognizer
     * Input    :  none
     * Output   :  none
     * Comment  :  Create a gesture recogizer to ramp the freqeucny speed or the manual speed up or down
     ***************************************************************************/
    
    private func initializePumpGestureRecognizer(){
        
        //RME: Initiate PUMP Flow Control Gesture Handler
        
        manulPumpGesture = UIPanGestureRecognizer(target: self, action: #selector(changePumpSpeedFrequency(sender:)))
        //frequencyIndicator.isUserInteractionEnabled = true
        frequencyIndicator.addGestureRecognizer(self.manulPumpGesture)
        manulPumpGesture.delegate = self
        
    }
    
    //====================================
    //                                     FILTRATION MONITOR
    //====================================
    
    
    /***************************************************************************
     * Function :  Read Filtration Pump Details
     * Input    :  none
     * Output   :  none
     * Comment  :  Get all the details from the PLC.
     ***************************************************************************/
    
    private func readCurrentFiltrationPumpDetails(){
        
        CENTRAL_SYSTEM?.readRegister(length: 18, startingRegister: Int32(pumpRegister), completion:{ (success, response) in
            
            guard success == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            self.pumpData.vfdReady = statusArrValues[0]
            self.pumpData.vfdRunning = statusArrValues[1]
            self.pumpData.pumpFaulted = statusArrValues[2]
            self.pumpData.pumpWarning = statusArrValues[3]
            self.pumpData.inHandMode = statusArrValues[4]
            self.pumpData.inOffMode = statusArrValues[5]
            self.pumpData.inAutoMode = statusArrValues[6]
            self.pumpData.filtrationControlMode = statusArrValues[7]
            self.pumpData.showControlMode = statusArrValues[8]
            self.pumpData.schedulerControlMode = statusArrValues[9]
            self.pumpData.plcControlMode = statusArrValues[10]
            self.pumpData.vfdWarning = statusArrValues[11]
            self.pumpData.strainerWarning = statusArrValues[12]
            self.pumpData.notInAutoWarning = statusArrValues[13]
            
            let faultStatusArrValues = self.convertIntToBitArr(a: Int(truncating: response![4] as! NSNumber))
            self.pumpData.fault_EStop = faultStatusArrValues[0]
            self.pumpData.fault_Network = faultStatusArrValues[1]
            self.pumpData.fault_VFDActive = faultStatusArrValues[2]
            self.pumpData.fault_lowWaterLevel = faultStatusArrValues[3]
            self.pumpData.fault_lowPressure = faultStatusArrValues[4]
            self.pumpData.fault_GFCITripped = faultStatusArrValues[5]
            self.pumpData.fault_FailToRunAlarm = faultStatusArrValues[6]
            
            self.pumpData.status_OutputFrequency = Int(truncating: response![8] as! NSNumber)
            self.pumpData.status_OutputVoltage = Int(truncating: response![9] as! NSNumber)
            self.pumpData.status_OutputCurrent = Int(truncating: response![10] as! NSNumber)
            self.pumpData.status_OutputMotorPwr = Int(truncating: response![11] as! NSNumber)
            self.pumpData.status_OutputTemperature = Int(truncating: response![12] as! NSNumber)
            
            self.pumpData.status_frequencyShowDataSP = Int(truncating: response![14] as! NSNumber)
            self.pumpData.status_frequencyPLCDataSP = Int(truncating: response![15] as! NSNumber)
            self.pumpData.cfg_frequencySP = Int(truncating: response![16] as! NSNumber)
            self.pumpData.cfg_frequencyBWSP = Int(truncating: response![17] as! NSNumber)
            
            
            
            if self.readOnce == 0{
                self.readCurrentFiltrationSpeed(response: self.pumpData.status_OutputFrequency)
                self.readCurrentManualSpeed(response: self.pumpData.cfg_frequencySP)
                self.readOnce = 1
            }
            
            //print(statusArrValues)
            
        })
        CENTRAL_SYSTEM?.readRegister(length: Int32(SYSTEM_PRESSURE.count), startingRegister: Int32(SYSTEM_PRESSURE.startAddr), completion:{ (success, response) in
            
            guard success == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![0] as! NSNumber))
            
            let psl1001 = self.view.viewWithTag(2001) as? UIImageView
            let psl1003 = self.view.viewWithTag(2002) as? UIImageView
            let psl1005 = self.view.viewWithTag(2003) as? UIImageView
            let psll1001 = self.view.viewWithTag(2004) as? UIImageView
            let psll1003 = self.view.viewWithTag(2005) as? UIImageView
            let psll1004 = self.view.viewWithTag(2006) as? UIImageView
            let psll1005 = self.view.viewWithTag(2007) as? UIImageView
            let psll1006 = self.view.viewWithTag(2008) as? UIImageView
            let f101ANR  = self.view.viewWithTag(2009) as? UIImageView
            let f101BNR  = self.view.viewWithTag(2010) as? UIImageView
            
            statusArrValues[0] == 1 ? (psl1001?.image = #imageLiteral(resourceName: "yellow")) : (psl1001?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[1] == 1 ? (psl1003?.image = #imageLiteral(resourceName: "yellow")) : (psl1003?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[2] == 1 ? (psl1005?.image = #imageLiteral(resourceName: "yellow")) : (psl1005?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[3] == 1 ? (psll1001?.image = #imageLiteral(resourceName: "red")) : (psll1001?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[4] == 1 ? (psll1003?.image = #imageLiteral(resourceName: "red")) : (psll1003?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[5] == 1 ? (psll1004?.image = #imageLiteral(resourceName: "red")) : (psll1004?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[6] == 1 ? (psll1005?.image = #imageLiteral(resourceName: "red")) : (psll1005?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[7] == 1 ? (psll1006?.image = #imageLiteral(resourceName: "red")) : (psll1006?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[14] == 1 ? (f101ANR?.image = #imageLiteral(resourceName: "red")) : (f101ANR?.image = #imageLiteral(resourceName: "blank_icon_on"))
            statusArrValues[15] == 1 ? (f101BNR?.image = #imageLiteral(resourceName: "red")) : (f101BNR?.image = #imageLiteral(resourceName: "blank_icon_on"))
            
            if statusArrValues[3] == 1 || statusArrValues[4] == 1 || statusArrValues[5] == 1 || statusArrValues[6] == 1 || statusArrValues[7] == 1 {
                self.cleanStrainerIndicator.isHidden = false
            } else {
                self.cleanStrainerIndicator.isHidden = true
            }
        })
    }
    
    /***************************************************************************
     * Function :  Read Filtration Pump Speed
     * Input    :  none
     * Output   :  none
     * Comment  :  The frequency background frame will change its size according to the frequency value we got from the PLC
     ***************************************************************************/
    
    private func readCurrentFiltrationSpeed(response:Int) {
        self.frequency = response
        
        if let frequency = frequency {
            let integer = frequency / 10
            let frequencyLocation = (Double(integer) * PIXEL_PER_FREQUENCY)
            let indicatorLocation = 458 - frequencyLocation
            
            
            if integer > Int(MAX_FILTRATION_FREQUENCY){
                frequencySetpointBackground.frame =  CGRect(x: 499, y: 199, width: 25, height: 258)
            }else{
                frequencySetpointBackground.frame =  CGRect(x: 499, y: indicatorLocation, width: 25, height:frequencyLocation)
            }
        }
    }
    
    /***************************************************************************
     * Function :  Read Manual Pump Speed
     * Input    :  none
     * Output   :  none
     * Comment  :  The frequency indicator frame and frequency text will move its y coordinate according to the frequency value we got from the PLC
     ***************************************************************************/
    
    private func readCurrentManualSpeed(response:Int) {
        
            frequencyIndicatorValue.textColor = GREEN_COLOR
            self.manualSpeed = response
            
            if let manualSpeed = manualSpeed {
                let integer = manualSpeed / 10
                let decimal = manualSpeed % 10
                let indicatorLocation = 445 - (Double(integer) * PIXEL_PER_FREQUENCY)
                
                if integer > Int(MAX_FILTRATION_FREQUENCY){
                    frequencyIndicator.frame = CGRect(x: 399, y: 190, width: 86, height: 23)
                    frequencyIndicatorValue.text = "\(MAX_FILTRATION_FREQUENCY)"
                    readManualSpeedOncePLC = true
                }else{
                    
                    frequencyIndicator.frame = CGRect(x: 399, y: indicatorLocation, width: 86, height: 23)
                    frequencyIndicatorValue.text = "\(integer).\(decimal)"
                    readManualSpeedOncePLC = true
                }
            }
    }
    /***************************************************************************
     * Function :  Change Pump's Frequency
     * Input    :  none
     * Output   :  none
     * Comment  :  Check whether the back wash is running or not.
     ***************************************************************************/
    
    
    @objc func changePumpSpeedFrequency(sender: UIPanGestureRecognizer){
        frequencyIndicatorValue.textColor = DEFAULT_GRAY
        
        var touchLocation:CGPoint = sender.location(in: self.view)
        if touchLocation.y  < 200.5 {
            touchLocation.y = 200.5
        }
        if touchLocation.y  > 461 {
            touchLocation.y = 461
        }
        // This is set.
        if touchLocation.y >= 200.5 && touchLocation.y <= 461 {
            print(touchLocation.y)
            //Make sure that we don't go more than pump flow limit
           
            sender.view?.center.y = touchLocation.y
            
            let flowRange = 460.0 - touchLocation.y
            let hertz = Float(flowRange) * CONVERTED_FILTRATION_PIXEL_PER_FREQUENCY!
            
            
            var convertedFrequency = Int(hertz * 10)
            let frequencyValue = convertedFrequency / 10
            var frequencyRemainder = convertedFrequency % 10
            
            if frequencyValue == 50 && frequencyRemainder > 0 {
                frequencyRemainder = 0
            }
            
            if frequencyValue == 0 && frequencyRemainder < 0 {
                frequencyRemainder = 0
            }
            
            frequencyIndicatorValue.text = "\(frequencyValue).\(frequencyRemainder)"
            
            if convertedFrequency > CONVERTED_FREQUENCY_LIMIT {
                convertedFrequency = CONVERTED_FREQUENCY_LIMIT
            } else if convertedFrequency < 0 {
                convertedFrequency = 0
            }
            
            
            if sender.state == .ended {
                CENTRAL_SYSTEM?.writeRegister(register: pumpCmdReg.setFreqSP, value: Int(convertedFrequency))
                self.readOnce = 0
            }
        }
    }
    //MARK: - Set Backwash Scheduler
    
    @IBAction func redirectToPumpDetail(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "pumps", bundle:nil)
        
        let pumpDetail = storyBoard.instantiateViewController(withIdentifier: "autoPumpDetail") as! AutoPumpDetailViewController
        pumpDetail.pumpNumber = pumpNumber
        self.navigationController?.pushViewController(pumpDetail, animated: true)

    }
    
    func checkAMPM(){
        if let formatString: String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) {
            let checker24hrs = formatString.contains("H")
            let checker24hrs2 = formatString.contains("k")
            
            if checker24hrs || checker24hrs2 {
                is24hours = true
            } else {
                is24hours = false
            }
        } else {
            is24hours = true
        }
    }
    
    @IBAction func redirectToPumpScheduler(_ sender: UIButton) {
        let schedulerShowVC = UIStoryboard.init(name: "pumps", bundle: nil).instantiateViewController(withIdentifier: "pumpSchedulerViewController") as! PumpSchedulerViewController
        schedulerShowVC.schedulerTag = sender.tag
        navigationController?.pushViewController(schedulerShowVC, animated: true)
    }
    
    func getSchdeulerStatus(){
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(FILTRATION_PUMP_SCH_BIT), completion: { (success, response) in
                           
           guard success == true else { return }
           
           let filterSchOn = Int(truncating: response![0] as! NSNumber)
             
           if filterSchOn == 1{
               self.pumpSchBtn.setTitleColor(GREEN_COLOR, for: .normal)
           } else {
               self.pumpSchBtn.setTitleColor(DEFAULT_GRAY, for: .normal)
           }
        })
    }
}
