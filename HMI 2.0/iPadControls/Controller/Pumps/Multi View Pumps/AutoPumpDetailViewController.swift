//
//  PumpDetailViewController.swift
//  iPadControls
//
//  Created by Arpi Derm on 12/27/16.
//  Copyright © 2016 WET. All rights reserved.
//

import UIKit

class AutoPumpDetailViewController: UIViewController,UIGestureRecognizerDelegate{
    
    var pumpNumber = 0
    
    private var pumpIndicatorLimit = 0
    
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    //MARK: - Class Reference Objects -- Dependencies
    
    private let logger = Logger()
    private let helper = Helper()
    
    @IBOutlet weak var shwSpeedName: UILabel!
    @IBOutlet weak var manualSpeedView: UIView!
    @IBOutlet weak var manualSpeedValue: UITextField!
    @IBOutlet weak var showSpeedValue: UITextField!
    @IBOutlet weak var setFrequencyHandle: UIView!
    @IBOutlet weak var frequencySetLabel: UILabel!
    @IBOutlet weak var autoResetSwtch: UISwitch!
    
    //MARK: - Frequency Label Indicators
    
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var frequencyValueLabel: UILabel!
    @IBOutlet weak var frequencyIndicator: UIView!
    @IBOutlet weak var frequencyIndicatorValue: UILabel!
    @IBOutlet weak var frequencySetpointBackground: UIView!
    
    
    //MARK: - Voltage Label Indicators
    
    @IBOutlet weak var voltageLabel: UILabel!
    @IBOutlet weak var voltageValueLabel: UILabel!
    @IBOutlet weak var voltageIndicator: UIView!
    @IBOutlet weak var voltageIndicatorValue: UILabel!
    @IBOutlet weak var voltageSetpointBackground: UIView!
    @IBOutlet weak var voltageBackground: UIView!
    
    //MARK: - Current Label Indicators
    
    @IBOutlet weak var currentBackground: UIView!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentSetpointBackground: UIView!
    @IBOutlet weak var currentIndicator: UIView!
    @IBOutlet weak var currentIndicatorValues: UILabel!
    
    //MARK: - Temperature Label Indicators
    
    @IBOutlet weak var temperatureIndicator: UIView!
    @IBOutlet weak var temperatureIndicatorValue: UILabel!
    @IBOutlet weak var temperatureGreen: UIView!
    @IBOutlet weak var temperatureYellow: UIView!
    @IBOutlet weak var temperatureRed: UIView!
    @IBOutlet weak var temperatureBackground: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    //MARK: - Auto or Manual
    @IBOutlet weak var autoModeIndicator: UIImageView!
    @IBOutlet weak var handModeIndicator: UIImageView!
    @IBOutlet weak var autoManualButton: UIButton!
    @IBOutlet weak var playStopButtonIcon: UIButton!
    private var isManualMode = false
    
    
    //MARK: - Data Structures
    
    private var langData = Dictionary<String, String>()
    private var pumpModel:Pump?
    private var iPadNumber = 0
    private var showStoppers = ShowStoppers()
    private var pumpState = 0 //POSSIBLE STATES: 0 (Auto) 1 (Hand) 2 (Off)
    private var localStat = 0
    private var readFrequencyCount = 0
    private var readOnce = 0
    private var readPumpDetailSpecsOnce = 0
    private var readManualFrequencySpeed = false
    private var readManualFrequencySpeedOnce = false
    private var HZMax = 0
    
    private var voltageMaxRangeValue = 0
    private var voltageMinRangeValue = 0
    private var voltageLimit = 0
    private var pixelPerVoltage  = 0.0
    
    private var currentLimit = 0
    private var currentMaxRangeValue = 0
    private var pixelPerCurrent = 0.0
    
    private var temperatureMaxRangeValue = 0
    private var pixelPerTemperature = 0.0
    private var temperatureLimit = 125
    private var pumpFaulted = false
    var currentScalingFactorPump = 10
    var pumpRegister = 0
    var pumpPreviosMode = 0
    var pumpData = VFD_VALUES()
    var pumpCmdReg = VFD101_CMD_REG
    private var centralSystem = CentralSystem()
    var manualPumpGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var vfdNumber: UILabel!
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
    }
    
    //MARK: - Memory Management
    
    
    //MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool){
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        setupPumpLabel()
        pumpIndicatorLimit = 0
        //Configure Pump Screen Text Content Based On Device Language
        configureScreenTextContent()
        readCurrentPumpDetailsSpecs()
        initializePumpGestureRecognizer()
        
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    private func initializePumpGestureRecognizer(){
        
        //RME: Initiate PUMP Flow Control Gesture Handler
        
        manualPumpGesture = UIPanGestureRecognizer(target: self, action: #selector(changePumpSpeedFrequency(sender:)))
        setFrequencyHandle.isUserInteractionEnabled = true
        setFrequencyHandle.addGestureRecognizer(self.manualPumpGesture)
        manualPumpGesture.delegate = self
        
    }
     
    func setupPumpLabel(){
        switch pumpNumber {
            case 101: vfdNumber.text = "VFD - 101"
                      pumpRegister = VFD_101_DATAREGISTER.startAddr
                      pumpCmdReg = VFD101_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "pumps"), for: .normal)
            case 103: vfdNumber.text = "VFD - 103"
                      pumpRegister = VFD_103_DATAREGISTER.startAddr
                      pumpCmdReg = VFD103_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "pumps"), for: .normal)
            case 104: vfdNumber.text = "VFD - 104"
                      pumpRegister = VFD_104_DATAREGISTER.startAddr
                      pumpCmdReg = VFD104_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "pumps"), for: .normal)
            case 105: vfdNumber.text = "VFD - 105"
                      pumpRegister = VFD_105_DATAREGISTER.startAddr
                      pumpCmdReg = VFD105_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "pumps"), for: .normal)
            case 106: vfdNumber.text = "VFD - 106"
                      pumpRegister = VFD_106_DATAREGISTER.startAddr
                      pumpCmdReg = VFD106_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "pumps"), for: .normal)
            case 107: vfdNumber.text = "VFD - 107"
                      pumpRegister = VFD_107_DATAREGISTER.startAddr
                      pumpCmdReg = VFD107_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "plume"), for: .normal)
                      self.autoManualButton.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
            case 108: vfdNumber.text = "VFD - 108"
                      pumpRegister = VFD_108_DATAREGISTER.startAddr
                      pumpCmdReg = VFD108_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "plume"), for: .normal)
                      self.autoManualButton.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
            case 109: vfdNumber.text = "VFD - 109"
                      pumpRegister = VFD_109_DATAREGISTER.startAddr
                      pumpCmdReg = VFD109_CMD_REG
                      self.autoManualButton.setImage(#imageLiteral(resourceName: "plume"), for: .normal)
                      self.autoManualButton.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
        default:
            print("FAULT TAG")
        }
        self.showSpeedValue.isHidden = true
        self.shwSpeedName.text = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    private func readCurrentPumpData() {
        
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
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.pumpData.cmd_enableAutoReset = cmdArrValues[7]
            
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
            
            self.getVoltageReading(response: self.pumpData.status_OutputVoltage)
            self.getCurrentReading(response: self.pumpData.status_OutputCurrent)
            self.getTemperatureReading(response: self.pumpData.status_OutputTemperature)
            self.getFrequencyReading(response: self.pumpData.status_OutputFrequency)
            
           
            
            let estop = self.view.viewWithTag(200) as? UILabel
            let pressFault = self.view.viewWithTag(201) as? UILabel
            let vfdFault = self.view.viewWithTag(202) as? UILabel
            let gfciFault = self.view.viewWithTag(203) as? UILabel
            let network = self.view.viewWithTag(204) as? UILabel
            let cleanStrainer = self.view.viewWithTag(205) as? UILabel
            let lowWW = self.view.viewWithTag(206) as? UILabel
            let pumpFault = self.view.viewWithTag(207) as? UILabel
            
            self.pumpData.fault_EStop == 1 ? (estop?.isHidden = false) : (estop?.isHidden = true)
            self.pumpData.fault_lowPressure == 1 ? (pressFault?.isHidden = false) : (pressFault?.isHidden = true)
            self.pumpData.fault_VFDActive == 1 ? (vfdFault?.isHidden = false) : (vfdFault?.isHidden = true)
            self.pumpData.fault_GFCITripped == 1 ? (gfciFault?.isHidden = false) : (gfciFault?.isHidden = true)
            self.pumpData.fault_Network == 1 ? (network?.isHidden = false) : (network?.isHidden = true)
            self.pumpData.strainerWarning == 1 ? (cleanStrainer?.isHidden = false) : (cleanStrainer?.isHidden = true)
            self.pumpData.fault_lowWaterLevel == 1 ? (lowWW?.isHidden = false) : (lowWW?.isHidden = true)
            self.pumpData.pumpFaulted == 1 ? (pumpFault?.isHidden = false) : (pumpFault?.isHidden = true)
            
            if self.readOnce == 0{
                self.readCurrentPumpDetailsSpecs()
                self.parseFaultsDataFromPLC()
                self.readPlayStopBit()
                self.checkForAutoManMode(auto:self.pumpData.inAutoMode, hand:self.pumpData.inHandMode, off:self.pumpData.inOffMode)
                self.readOnce = 1
            }
            
            //print(statusArrValues)
            
        })
    }
    
    //MARK: - Set Pump Number To PL

    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0

            
            //Now that the connection is established, run functions
            readCurrentPumpData()
            //readCurrentPumpDetailsSpecs()
            
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
    
    //====================================
    //                                     GET PUMP DETAILS AND READINGS
    //====================================
    
    //MARK: - Configure Screen Text Content Based On Device Language
    
    private func configureScreenTextContent(){
        
        langData = helper.getLanguageSettigns(screenName: PUMPS_LANGUAGE_DATA_PARAM)
        
        frequencyLabel.text = langData["FREQUENCY"]!
        voltageLabel.text = langData["VOLTAGE"]!
        currentLabel.text = langData["CURRENT"]!
        temperatureLabel.text = langData["TEMPERATURE"]!
        
        
        guard pumpModel != nil else {
            
            logger.logData(data: "PUMPS: PUMP MODEL EMPTY")
            
            //If the pump model is empty, put default parameters to avoid system crash
            navigationItem.title = langData["PUMPS DETAILS"]!
            noConnectionErrorLbl.text = "CHECK SETTINGS"
            
            return
            
        }
        
        navigationItem.title = langData[pumpModel!.screenName!]!
        noConnectionErrorLbl.text = pumpModel!.outOfRangeMessage!
        
    }
    
    @objc private func readCurrentPumpDetailsSpecs() {
        if pumpNumber == 103 || pumpNumber == 104 || pumpNumber == 105 || pumpNumber == 106 {
            CENTRAL_SYSTEM?.readRegister(length: Int32(BLOSSOM_PLUME_MAX_SP.count) , startingRegister: Int32(BLOSSOM_PLUME_MAX_SP.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                self.HZMax = Int(truncating: response![1] as! NSNumber)
                self.voltageMinRangeValue = Int(truncating: response![2] as! NSNumber)
                self.voltageMaxRangeValue = Int(truncating: response![3] as! NSNumber)
                self.currentMaxRangeValue = Int(truncating: response![5] as! NSNumber)
                self.temperatureMaxRangeValue = 125
                
                self.frequencyValueLabel.text = "\(self.HZMax)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum volatage value just add 100.
                
                self.voltageLimit = self.voltageMaxRangeValue + 100
                self.voltageValueLabel.text   = "\(self.voltageLimit)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum current value just add 10.
                self.currentLimit = self.currentMaxRangeValue + 10
                self.currentValueLabel.text = "\(self.currentLimit)"
                
                //Note temperature always stays at 100 limit.
                
                
                //Add necessary view elements to the view
                self.constructViewElements()
            })
            
        }
        if pumpNumber == 107 || pumpNumber == 108 || pumpNumber == 109 {
            CENTRAL_SYSTEM?.readRegister(length: Int32(BLOSSOM_PLUME_MAX_SP.count) , startingRegister: Int32(BLOSSOM_PLUME_MAX_SP.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                self.HZMax = Int(truncating: response![7] as! NSNumber)
                self.voltageMinRangeValue = Int(truncating: response![8] as! NSNumber)
                self.voltageMaxRangeValue = Int(truncating: response![9] as! NSNumber)
                self.currentMaxRangeValue = Int(truncating: response![11] as! NSNumber)
                self.temperatureMaxRangeValue = 125
                
                self.frequencyValueLabel.text = "\(self.HZMax)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum volatage value just add 100.
                
                self.voltageLimit = self.voltageMaxRangeValue + 100
                self.voltageValueLabel.text   = "\(self.voltageLimit)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum current value just add 10.
                self.currentLimit = self.currentMaxRangeValue + 10
                self.currentValueLabel.text = "\(self.currentLimit)"
                
                //Note temperature always stays at 100 limit.
                
                
                //Add necessary view elements to the view
                self.constructViewElements()
            })
            
        }
        if pumpNumber == 101 {
            CENTRAL_SYSTEM?.readRegister(length: Int32(FILTRATION_MAX_SP.count) , startingRegister: Int32(FILTRATION_MAX_SP.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                self.HZMax = Int(truncating: response![1] as! NSNumber)
                self.voltageMinRangeValue = Int(truncating: response![2] as! NSNumber)
                self.voltageMaxRangeValue = Int(truncating: response![3] as! NSNumber)
                self.currentMaxRangeValue = Int(truncating: response![5] as! NSNumber)
                self.frequencyValueLabel.text = "\(self.HZMax)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum volatage value just add 100.
                
                self.voltageLimit = self.voltageMaxRangeValue + 100
                self.voltageValueLabel.text   = "\(self.voltageLimit)"
                
                // What we are getting is a range, not the maximum value. So to get the maximum current value just add 10.
                self.currentLimit = self.currentMaxRangeValue + 10
                self.currentValueLabel.text = "\(self.currentLimit)"
                
                //Note temperature always stays at 100 limit.
                
                
                //Add necessary view elements to the view
                self.temperatureMaxRangeValue = 125
                self.constructViewElements()
                
            })
        }
    }
    
    //MARK: - Construct View Elements
    
    private func constructViewElements(){
        constructVoltageSlider()
        constructCurrentSlider()
        constructTemperatureSlider()        
    }
    
    
    private func constructVoltageSlider(){
        let frame = 450.0
        pixelPerVoltage = frame / Double(voltageLimit)
        if pixelPerVoltage == Double.infinity {
            pixelPerVoltage = 0
        }
        
        
        let length = Double(voltageMaxRangeValue) * pixelPerVoltage
        let height = Double(voltageMaxRangeValue - voltageMinRangeValue) * pixelPerVoltage
        
        
        voltageSetpointBackground.backgroundColor = GREEN_COLOR
        voltageSetpointBackground.frame = CGRect(x: 0, y: (SLIDER_PIXEL_RANGE - length), width: 25, height: height)
        
    }
    
    private func constructCurrentSlider(){
        let frame = 450.0
        pixelPerCurrent = frame / Double(currentLimit)
        if pixelPerCurrent == Double.infinity {
            pixelPerCurrent = 0
        }
        
        var length = Double(currentMaxRangeValue) * pixelPerCurrent
        
        if length > 450{
            length = 450
        }
        
        
        currentSetpointBackground.backgroundColor = GREEN_COLOR
        currentSetpointBackground.frame = CGRect(x: 0, y: (SLIDER_PIXEL_RANGE - length), width: 25, height: length)
    }
    
    private func constructTemperatureSlider(){
        let frame = 450.0
        let temperatureMidRangeValue = 75.0
        let temperatureRedRangeValue = 100.0
        pixelPerTemperature = frame / Double(temperatureLimit)
        if pixelPerTemperature == Double.infinity {
            pixelPerTemperature = 0
        }
        
        
        let temperatureRange = Double(temperatureMaxRangeValue) * pixelPerTemperature
        let temperatureRedHeight = (Double(temperatureMaxRangeValue) - temperatureRedRangeValue) * pixelPerTemperature
        let temperatureYellowHeight = (Double(temperatureRedRangeValue) - temperatureMidRangeValue) * pixelPerTemperature
        
        temperatureYellow.backgroundColor = .yellow
        temperatureRed.backgroundColor = RED_COLOR
        temperatureGreen.backgroundColor = GREEN_COLOR
        
        temperatureRed.frame = CGRect(x: 0, y: 0, width: 25, height: temperatureRedHeight)
        temperatureYellow.frame = CGRect(x: 0, y: temperatureRedHeight, width: 25, height: temperatureYellowHeight)
        temperatureGreen.frame = CGRect(x: 0, y: (SLIDER_PIXEL_RANGE - temperatureRange), width: 25, height: temperatureRange)
        
        
        
    }
    
    //MARK: - Read Water On Fire Values
    
    private func parseFaultsDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length: 18, startingRegister: Int32(pumpRegister), completion:{ (success, response) in
            
            guard success == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            self.pumpData.status_frequencyShowDataSP = Int(truncating: response![14] as! NSNumber)
            self.pumpData.status_frequencyPLCDataSP = Int(truncating: response![15] as! NSNumber)
            self.pumpData.cfg_frequencySP = Int(truncating: response![16] as! NSNumber)
            self.pumpData.cfg_frequencyBWSP = Int(truncating: response![17] as! NSNumber)
            
            if self.pumpData.cmd_enableAutoReset == 1{
                self.autoResetSwtch.isOn = true
            } else {
                self.autoResetSwtch.isOn = false
            }
            self.getManualSpeedReading(manSpeed: self.pumpData.cfg_frequencySP, showSpeed:self.pumpData.cfg_frequencyBWSP)
            
            //print(statusArrValues)
            
        })
    }
    
    //MARK: - Get Voltage Reading
    
    private func getVoltageReading(response:Int){
        let voltage = response
        let voltageValue = voltage / 10
        let voltageRemainder = voltage % 10
        let indicatorLocation = abs(790 - (Double(voltageValue) * pixelPerVoltage))
        
        if voltageValue >= voltageLimit {
            voltageIndicator.frame = CGRect(x: 459, y: 288, width: 92, height: 23)
        } else if voltageValue <= 0 {
            voltageIndicator.frame = CGRect(x: 459, y: 738, width: 92, height: 23)
        } else {
            voltageIndicator.frame = CGRect(x: 459, y: indicatorLocation, width: 92, height: 23)
        }
        
        voltageIndicatorValue.text = "\(voltageValue).\(voltageRemainder)"
        
        if voltageValue > voltageMaxRangeValue || voltageValue < voltageMinRangeValue {
            voltageIndicatorValue.textColor = RED_COLOR
        } else {
            voltageIndicatorValue.textColor = GREEN_COLOR
        }
    }
    
    //MARK: Get Current Reading
    
    
    
    
    private func getCurrentReading(response:Int){
        let current = response
        let currentValue = current / currentScalingFactorPump
        let currentRemainder = current % currentScalingFactorPump
        let indicatorLocation = abs(690 - (Double(currentValue) * pixelPerCurrent))
        
        if currentValue >= currentLimit {
            currentIndicator.frame = CGRect(x: 640, y: 288, width: 92, height: 23)
        } else if currentValue <= 0 {
            currentIndicator.frame = CGRect(x: 640, y: 738, width: 92, height: 23)
        } else {
            currentIndicator.frame = CGRect(x: 640, y: indicatorLocation, width: 92, height: 23)
        }
        
        currentIndicatorValues.text = "\(currentValue).\(currentRemainder)"
        
        if currentValue > Int(currentMaxRangeValue){
            currentIndicatorValues.textColor = RED_COLOR
        } else {
            currentIndicatorValues.textColor = GREEN_COLOR
        }
    }
    
    //MARK: - Get Temperature Reading
    
    private func getTemperatureReading(response:Int){
        let temperature = response
        let temperatureMid = 75
        let temperatureRed = 100
        let indicatorLocation = 736 - (Double(temperature) * pixelPerTemperature)
        
        if temperature >= 125 {
            temperatureIndicator.frame = CGRect(x: 830, y: 286, width: 75, height: 23)
        } else if temperature <= 0 {
            temperatureIndicator.frame = CGRect(x: 830, y: 736, width: 75, height: 23)
        } else {
            temperatureIndicator.frame = CGRect(x: 830, y: indicatorLocation, width: 75, height: 23)
        }
        
        
        temperatureIndicatorValue.text = "\(temperature)"
        
        if temperature >= temperatureRed && temperature <= temperatureMaxRangeValue{
            temperatureIndicatorValue.textColor = RED_COLOR
        }else if temperature >= temperatureMid && temperature < temperatureRed {
            temperatureIndicatorValue.textColor = .yellow
        }else{
            temperatureIndicatorValue.textColor = GREEN_COLOR
        }
        
    }
    
    //MARK: - Get Frequency Reading
    
    private func getFrequencyReading(response:Int){
        // If pumpstate == 0 (Auto) then show the frequency indicator/background frame/indicator value. Note: the frequency indicator's user interaction is disabled.
        
        let frequency = response
        
        let frequencyValue = frequency / 10
        let frequencyRemainder = frequency % 10
        var pixelPerFrequency = 450.0 / Double(HZMax)
        if pixelPerFrequency == Double.infinity {
            pixelPerFrequency = 0
        }
        
        let length = Double(frequencyValue) * pixelPerFrequency
        
        if frequencyValue > Int(HZMax){
            frequencySetpointBackground.frame =  CGRect(x: 0, y: 0, width: 25, height: 450)
            frequencyIndicator.frame = CGRect(x: 252, y: 288, width: 86, height: 23)
            frequencyIndicatorValue.text = "\(HZMax)"
        } else {
            frequencySetpointBackground.frame =  CGRect(x: 0, y: (SLIDER_PIXEL_RANGE - length), width: 25, height: length)
            frequencyIndicator.frame = CGRect(x: 252, y: (738 - length), width: 86, height: 23)
            frequencyIndicatorValue.text = "\(frequencyValue).\(frequencyRemainder)"
            
            
        }
        
    }
    
    
    //====================================
    //                                      AUTO / MANUAL MODE
    //====================================
    
    
    //MARK: - Check For Auto/Man Mode
    
    private func checkForAutoManMode(auto:Int, hand:Int, off:Int){
        
        let inAuto = auto
        let inHand = hand
        let inOFF  = off
        
        if inAuto == 1{
            
            //Pump is in auto mode
            self.pumpState = 0
            self.pumpPreviosMode = 0
            self.changeAutManModeIndicatorRotation(autoMode: true)
            self.manualSpeedView.alpha = 0
            self.frequencyIndicator.isHidden = false
            self.setFrequencyHandle.isHidden = true
            playStopButtonIcon.isHidden = true
            
        }else if inOFF == 1{
            
            //Pump is in off mode
            self.pumpState = 1
            self.autoModeIndicator.alpha = 0
            self.handModeIndicator.alpha = 0
            self.manualSpeedView.alpha = 0
            self.frequencyIndicator.isHidden = true
            self.setFrequencyHandle.isHidden = true
            playStopButtonIcon.isHidden = true
            
        } else if inHand == 1{
            
            //Pump is in manual mode
            self.pumpState = 2
            self.pumpPreviosMode = 1
            self.changeAutManModeIndicatorRotation(autoMode: false)
            self.manualSpeedView.alpha = 1
            self.frequencyIndicator.isHidden = false
            self.setFrequencyHandle.isHidden = false
            playStopButtonIcon.isHidden = false
            
        }
    }
    
    
    
    
    @IBAction func changeAutoManMode(_ sender: UIButton) {
        if self.pumpData.inHandMode == 1 {
            //Turn OFF
            self.pumpPreviosMode = 1
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setOff, value: 1)
        }
        if self.pumpData.inAutoMode == 1 {
            //Turn OFF
            self.pumpPreviosMode = 0
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setOff, value: 1)
        }
        if self.pumpData.inOffMode == 1 && self.pumpPreviosMode == 1 {
            //Turn Auto
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setAuto, value: 1)
        }
        if self.pumpData.inOffMode == 1 && self.pumpPreviosMode == 0 {
            //Turn Hand
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setHand, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
        }
    }
    
    
    private func readPlayStopBit() {
        if self.pumpData.vfdRunning == 1 {
            //stop
            playStopButtonIcon.setImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            
        } else {
            //play
            playStopButtonIcon.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            
        }
    }
    
    @IBAction func playStopButtonPressed(_ sender: UIButton) {
        
        if self.pumpData.vfdRunning == 1 {
            //stop
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setHandStop, value: 1)
        } else {
            //play
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.setHandStart, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
        }
    }
    
    
    //MARK: - Change Auto/Man Mode Indicator Rotation
    
    func changeAutManModeIndicatorRotation(autoMode:Bool){
        
        /*
         NOTE: 2 Possible Options
         Option 1: Automode (animate) = True => Will result in any view object to rotate 360 degrees infinitly
         Option 2: Automode (animate) = False => Will result in any view object to stand still
         */
        
        
        
        if autoMode == true{  
            self.autoModeIndicator.alpha = 1
            self.handModeIndicator.alpha = 0
            autoModeIndicator.rotate360Degrees(animate: true)
            
        }else{
            
            self.autoModeIndicator.alpha = 0
            self.handModeIndicator.alpha = 1
            
        }
        
    }
    
    
    
    //====================================
    //                                      MANUAL PUMP CONTROL
    //====================================
    
    
    private func getManualSpeedReading(manSpeed:Int,showSpeed:Int){
        let manualSpeed = manSpeed
        let shwSpeed = showSpeed
        
        let manualSpeedValue = manualSpeed / 10
        let manualSpeedRemainder = manualSpeed % 10
        let shwSpeedValue = shwSpeed / 10
        let shwSpeedRemainder = shwSpeed % 10
        var pixelPerFrequency = 450.0 / Double(HZMax)
        
        if pixelPerFrequency == Double.infinity {
            pixelPerFrequency = 0
        }
        let length = Double(manualSpeedValue) * pixelPerFrequency
        
        if manualSpeedValue > Int(HZMax){
            setFrequencyHandle.frame = CGRect(x: 443, y: 285, width: 108, height: 26)
            self.manualSpeedValue.text  = "\(HZMax)"
            self.frequencySetLabel.text = "\(HZMax)"
        } else {
            setFrequencyHandle.frame = CGRect(x: 443, y: (735 - length), width: 108, height: 26)
            self.manualSpeedValue.text  = "\(manualSpeedValue).\(manualSpeedRemainder)"
            self.frequencySetLabel.text = "\(manualSpeedValue).\(manualSpeedRemainder)"
        }
        if shwSpeedValue > Int(HZMax){
            self.showSpeedValue.text  = "\(HZMax)"
        } else {
            self.showSpeedValue.text  = "\(shwSpeedValue).\(shwSpeedRemainder)"
        }
    }
    
    
    
    @objc func changePumpSpeedFrequency(sender: UIPanGestureRecognizer){
        
        var touchLocation:CGPoint = sender.location(in: self.view)
        print(touchLocation.y)
        //Make sure that we don't go more than pump flow limit
        if touchLocation.y  < 298 {
            touchLocation.y = 298
        }
        if touchLocation.y  > 748 {
            touchLocation.y = 748
        }
        
        //Make sure that we don't go more than pump flow limit
        if touchLocation.y >= 298 && touchLocation.y <= 748 {
            
            sender.view?.center.y = touchLocation.y
            
            let flowRange = 748 - Int(touchLocation.y)
            let pixelPerFrequency = 450.0 / Double(HZMax)
            let herts = Double(flowRange) / pixelPerFrequency
            let formattedHerts = String(format: "%.1f", herts)
            let convertedHerts = Int(herts * 10)
            frequencySetLabel.text = formattedHerts
            print(convertedHerts)
            
            
            if sender.state == .ended {
                CENTRAL_SYSTEM?.writeRegister(register: pumpCmdReg.setFreqSP, value: Int(convertedHerts))
                self.readOnce = 0
            }
        }
    }
    
    @IBAction func setManualSpeed(_ sender: UIButton) {
        var manSpeed  = Float(self.manualSpeedValue.text!)
        var shwSpeed  = Float(self.showSpeedValue.text!)
        self.manualSpeedValue.text = ""
        self.showSpeedValue.text = ""
        if manSpeed == nil{
            manSpeed = 0
        }
        if manSpeed! > 70 {
            manSpeed = 70
        }
        manSpeed = manSpeed! * 10
        if shwSpeed == nil{
            shwSpeed = 0
        }
        if shwSpeed! > 70 {
            shwSpeed = 70
        }
        shwSpeed = shwSpeed! * 10
        
        CENTRAL_SYSTEM?.writeRegister(register: pumpCmdReg.setFreqSP, value: Int(manSpeed!))
        CENTRAL_SYSTEM?.writeRegister(register: pumpCmdReg.setBWSP, value: Int(shwSpeed!))
        self.readOnce = 0
        readManualFrequencySpeedOnce = false
    }
    private func setReadManualSpeedBoolean(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.readManualFrequencySpeed = true
        }
    }
    
    @IBAction func sendFaultResetCmd(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.faultReset, value: 1)
    }
    
    @IBAction func sendWarningResetCmd(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.warningReset, value: 1)
    }
    
    @IBAction func sendAutoResetSwtchCmd(_ sender: UISwitch) {
        if self.pumpData.cmd_enableAutoReset == 1{
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.enableAutoReset, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: pumpCmdReg.enableAutoReset, value: 1)
        }
    }
}
