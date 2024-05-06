//
//  DCSettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/30/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class DCSettingsViewController: UIViewController {
    
    @IBOutlet weak var startSPDelayTimer: UITextField!
    @IBOutlet weak var warningSPDelayTimer: UITextField!
    @IBOutlet weak var shutOffSPDelayTimer: UITextField!
    @IBOutlet weak var startSP: UITextField!
    @IBOutlet weak var warningSP: UITextField!
    @IBOutlet weak var shutOffSP: UITextField!
    @IBOutlet weak var maxSP: UILabel!
    @IBOutlet weak var minSP: UILabel!
    @IBOutlet weak var iPadOverrideSP: UITextField!
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var pwrEnableSwtch: UISwitch!
    @IBOutlet weak var pwrOnSwtch: UISwitch!
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var dcValues  = DC_POWER_VALUES()
    var dcNum = 0
    var dcStartingRegister = 0
    var iPadOverrideValReg = 0
    var startSPReg = 0
    var warningSPReg = 0
    var shutSPReg = 0
    var shutSPTimerReg = 0
    var startSPTimerReg = 0
    var warningSPTimerReg = 0
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        constructSaveButton()
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        if dcNum == 151{
            dcStartingRegister = DCP101_POWER.startAddr
            self.navigationItem.title = "DCP - 101"
            iPadOverrideValReg = DCP101_POWER_CFG_OVERRIDEVAL
            startSPReg = DCP101_POWER_CFG_STARTSP
            warningSPReg = DCP101_POWER_CFG_WARNINGSP
            shutSPReg = DCP101_POWER_CFG_SHUTOFFSP
            shutSPTimerReg = DCP101_POWER_CFG_SHUTOFFTIMER
            startSPTimerReg = DCP101_POWER_CFG_STARTTIMER
            warningSPTimerReg = DCP101_POWER_CFG_WARNINGTIMER
            getShooterDataFromPLC()
        }
        if dcNum == 152{
            dcStartingRegister = DCP102_POWER.startAddr
            self.navigationItem.title = "DCP - 102"
            iPadOverrideValReg = DCP102_POWER_CFG_OVERRIDEVAL
            startSPReg = DCP102_POWER_CFG_STARTSP
            warningSPReg = DCP102_POWER_CFG_WARNINGSP
            shutSPReg = DCP102_POWER_CFG_SHUTOFFSP
            shutSPTimerReg = DCP102_POWER_CFG_SHUTOFFTIMER
            startSPTimerReg = DCP102_POWER_CFG_STARTTIMER
            warningSPTimerReg = DCP102_POWER_CFG_WARNINGTIMER
            getShooterDataFromPLC()
        }
        if dcNum == 153{
            dcStartingRegister = DCP103_POWER.startAddr
            self.navigationItem.title = "DCP - 103"
            iPadOverrideValReg = DCP103_POWER_CFG_OVERRIDEVAL
            startSPReg = DCP103_POWER_CFG_STARTSP
            warningSPReg = DCP103_POWER_CFG_WARNINGSP
            shutSPReg = DCP103_POWER_CFG_SHUTOFFSP
            shutSPTimerReg = DCP103_POWER_CFG_SHUTOFFTIMER
            startSPTimerReg = DCP103_POWER_CFG_STARTTIMER
            warningSPTimerReg = DCP103_POWER_CFG_WARNINGTIMER
            getShooterDataFromPLC()
        }
        if dcNum == 154{
            dcStartingRegister = DCP104_POWER.startAddr
            self.navigationItem.title = "DCP - 104"
            iPadOverrideValReg = DCP104_POWER_CFG_OVERRIDEVAL
            startSPReg = DCP104_POWER_CFG_STARTSP
            warningSPReg = DCP104_POWER_CFG_WARNINGSP
            shutSPReg = DCP104_POWER_CFG_SHUTOFFSP
            shutSPTimerReg = DCP104_POWER_CFG_SHUTOFFTIMER
            startSPTimerReg = DCP104_POWER_CFG_STARTTIMER
            warningSPTimerReg = DCP104_POWER_CFG_WARNINGTIMER
            getShooterDataFromPLC()
        }
        if dcNum == 155{
            dcStartingRegister = DCP105_POWER.startAddr
            self.navigationItem.title = "DCP - 105"
            iPadOverrideValReg = DCP105_POWER_CFG_OVERRIDEVAL
            startSPReg = DCP105_POWER_CFG_STARTSP
            warningSPReg = DCP105_POWER_CFG_WARNINGSP
            shutSPReg = DCP105_POWER_CFG_SHUTOFFSP
            shutSPTimerReg = DCP105_POWER_CFG_SHUTOFFTIMER
            startSPTimerReg = DCP105_POWER_CFG_STARTTIMER
            warningSPTimerReg = DCP105_POWER_CFG_WARNINGTIMER
            getShooterDataFromPLC()
        }
        
        //This line of code is an extension added to the view controller by showStoppers module
        //This is the only line needed to add show stopper
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        
        NotificationCenter.default.removeObserver(self)
        self.logger.logData(data:"View Is Disappearing")
        
    }
    
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
                noConnectionErrorLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                noConnectionErrorLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    
    func getShooterDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length: 13 , startingRegister: Int32(self.dcStartingRegister+3), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![0] as! NSNumber))
            self.dcValues.cmd_pwrDisable = cmdArrValues[2]
            self.dcValues.cmd_pwrFrceOn = cmdArrValues[3]
            
            self.dcValues.precision = Int(truncating: response![3] as! NSNumber)
            self.dcValues.cfg_scaleMin = Int(truncating: response![4] as! NSNumber)
            self.dcValues.cfg_scaleMax = Int(truncating: response![5] as! NSNumber)
            self.dcValues.cfg_iPadOverrideVal = Int(truncating: response![6] as! NSNumber)
            self.dcValues.cfg_tempStartSP = Int(truncating: response![7] as! NSNumber)
            self.dcValues.cfg_tempWarningSP = Int(truncating: response![8] as! NSNumber)
            self.dcValues.cfg_tempShutOffSP = Int(truncating: response![9] as! NSNumber)
            self.dcValues.cfg_tempStartTimer = Int(truncating: response![10] as! NSNumber)
            self.dcValues.cfg_tempWarningTimer = Int(truncating: response![11] as! NSNumber)
            self.dcValues.cfg_tempShutOffTimer = Int(truncating: response![12] as! NSNumber)
            
            if self.dcValues.cmd_pwrDisable == 1{
                self.pwrEnableSwtch.isOn = false
            } else {
                self.pwrEnableSwtch.isOn = true
            }
            
            if self.dcValues.cmd_pwrFrceOn == 1{
                self.pwrOnSwtch.isOn = true
            } else {
                self.pwrOnSwtch.isOn = false
            }
            let divisor = Int(truncating: pow(10,self.dcValues.precision) as NSNumber)
            let minValue = Float(self.dcValues.cfg_scaleMin) / Float(truncating: divisor as NSNumber)
            let maxValue = Float(self.dcValues.cfg_scaleMax) / Float(truncating: divisor as NSNumber)
            let iPadValue = Float(self.dcValues.cfg_iPadOverrideVal) / Float(truncating: divisor as NSNumber)
            let startSP = Float(self.dcValues.cfg_tempStartSP) / Float(truncating: divisor as NSNumber)
            let warningSP = Float(self.dcValues.cfg_tempWarningSP) / Float(truncating: divisor as NSNumber)
            let shutSP = Float(self.dcValues.cfg_tempShutOffSP) / Float(truncating: divisor as NSNumber)
            let startTimerSP =  self.dcValues.cfg_tempStartTimer
            let warningTimerSP = self.dcValues.cfg_tempWarningTimer
            let shutTimerSP = self.dcValues.cfg_tempShutOffTimer
            
            self.minSP.text = String(format: "%.2f", minValue)
            self.maxSP.text = String(format: "%.2f", maxValue)
            self.iPadOverrideSP.text = String(format: "%.2f", iPadValue)
            self.startSP.text = String(format: "%.2f", startSP)
            self.warningSP.text = String(format: "%.2f", warningSP)
            self.shutOffSP.text = String(format: "%.2f", shutSP)
            self.startSPDelayTimer.text = String(format: "%d", startTimerSP)
            self.warningSPDelayTimer.text = String(format: "%d", warningTimerSP)
            self.shutOffSPDelayTimer.text = String(format: "%d", shutTimerSP)
        })
    }
    func saveTimerSetpointDelaysToPLC(){
        
        let multiplier = pow(10,dcValues.precision)
        
        if let overVal = iPadOverrideSP.text, !overVal.isEmpty,
           let overValue = Float(overVal) {
            if overValue >= 2.0 && overValue <= 10000.0 {
                let newVal = Int(overValue * Float(truncating: multiplier as NSNumber))
                CENTRAL_SYSTEM?.writeRegister(register: iPadOverrideValReg, value: newVal)
            }
        }
        
        if let startVal = startSP.text, !startVal.isEmpty,
           let startValue = Float(startVal) {
            if startValue >= 2.0 && startValue <= 10000.0 {
                let newVal = Int(startValue * Float(truncating: multiplier as NSNumber))
                CENTRAL_SYSTEM?.writeRegister(register: startSPReg, value: newVal)
            }
        }
        
        if let warningVal = warningSP.text, !warningVal.isEmpty,
           let warningValue = Float(warningVal) {
            if warningValue >= 2.0 && warningValue <= 10000.0 {
                let newVal = Int(warningValue * Float(truncating: multiplier as NSNumber))
                CENTRAL_SYSTEM?.writeRegister(register: warningSPReg, value: newVal)
            }
        }
        
        if let shutVal = shutOffSP.text, !shutVal.isEmpty,
           let shutValue = Float(shutVal) {
            if shutValue >= 2.0 && shutValue <= 10000.0 {
                let newVal = Int(shutValue * Float(truncating: multiplier as NSNumber))
                CENTRAL_SYSTEM?.writeRegister(register: shutSPReg, value: newVal)
            }
        }
        
        if let startTimerVal = startSPDelayTimer.text, !startTimerVal.isEmpty,
           let startTimerValue = Int(startTimerVal) {
            if startTimerValue >= 2 && startTimerValue <= 600 {
                CENTRAL_SYSTEM?.writeRegister(register: startSPTimerReg, value: startTimerValue)
            }
        }
        
        if let warningTimerVal = warningSPDelayTimer.text, !warningTimerVal.isEmpty,
           let warningTimerValue = Int(warningTimerVal) {
            if warningTimerValue >= 2 && warningTimerValue <= 600 {
                CENTRAL_SYSTEM?.writeRegister(register: warningSPTimerReg, value: warningTimerValue)
            }
        }
        
        if let shutTimerVal = shutOffSPDelayTimer.text, !shutTimerVal.isEmpty,
           let shutTimerValue = Int(shutTimerVal) {
            if shutTimerValue >= 2 && shutTimerValue <= 600 {
                CENTRAL_SYSTEM?.writeRegister(register: shutSPTimerReg, value: shutTimerValue)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.getShooterDataFromPLC()
        }
        
    }
    
    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }
    @objc private func saveSetpoints(){
       saveTimerSetpointDelaysToPLC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendCmdEnableValve(_ sender: UISwitch) {
        if dcNum == 151{
            if self.dcValues.cmd_pwrDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_ENABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_ENABLE, value: 1)
            }
        }
        if dcNum == 152{
            if self.dcValues.cmd_pwrDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_ENABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_ENABLE, value: 1)
            }
        }
        if dcNum == 153{
            if self.dcValues.cmd_pwrDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_ENABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_ENABLE, value: 1)
            }
        }
        if dcNum == 154{
            if self.dcValues.cmd_pwrDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_ENABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_ENABLE, value: 1)
            }
        }
        if dcNum == 155{
            if self.dcValues.cmd_pwrDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_ENABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_ENABLE, value: 1)
            }
        }
    }
    @IBAction func sendCmdOn(_ sender: UISwitch) {
        if dcNum == 151{
            if self.dcValues.cmd_pwrFrceOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_ON, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_ON, value: 1)
            }
        }
        if dcNum == 152{
            if self.dcValues.cmd_pwrFrceOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_ON, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_ON, value: 1)
            }
        }
        if dcNum == 153{
            if self.dcValues.cmd_pwrFrceOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_ON, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_ON, value: 1)
            }
        }
        if dcNum == 154{
            if self.dcValues.cmd_pwrFrceOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_ON, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_ON, value: 1)
            }
        }
        if dcNum == 155{
            if self.dcValues.cmd_pwrFrceOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_ON, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_ON, value: 1)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
