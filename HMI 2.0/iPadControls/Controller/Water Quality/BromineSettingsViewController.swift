//
//  BromineSettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/5/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class BromineSettingsViewController: UIViewController {
   @IBOutlet weak var noConnectionView:     UIView!
   @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var tv100xDelayTimer: UITextField!
    @IBOutlet weak var dosingDelayTimer: UITextField!
    @IBOutlet weak var vlveOpenTimer: UITextField!
    @IBOutlet weak var vlveCloseTimer: UITextField!
    @IBOutlet weak var startDosingTimer: UITextField!
    @IBOutlet weak var stopDosingTimer: UITextField!
    @IBOutlet weak var startSP: UITextField!
    @IBOutlet weak var stopSP: UITextField!
    
    @IBOutlet weak var dumpVlveSwtch: UISwitch!
    @IBOutlet weak var frceVlve: UISwitch!
    @IBOutlet weak var brEnable: UISwitch!
    @IBOutlet weak var brDosing: UISwitch!
    
    private let logger = Logger()
    private var readOnce = 0
    private var readTOnce = 0
    private var centralSystem = CentralSystem()
    private let helper = Helper()
    var brValues  = BR_VALUES()
    var dumpValValues  = FOG_MOTOR_SENSOR_VALUES()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool){
        
        NotificationCenter.default.removeObserver(self)
        self.readOnce = 0
    }
    
    override func viewWillAppear(_ animated: Bool){
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        setupWQLabel()
        constructSaveButton()
        readCurrentKVData()
        readCurrentTVData()
        //Configure Pump Screen Text Content Based On Device Language
        
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    
    func setupWQLabel(){
        self.navigationItem.title = "TV100X KV1001 DETAILS"
    }
    
    private func constructSaveButton(){
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveWQSettings))

    }
    @objc private func saveWQSettings(){
      
      if let tvVal = tv100xDelayTimer.text, !tvVal.isEmpty,
         let tvValue = Int(tvVal) {
          if tvValue >= 2 && tvValue <= 60 {
              CENTRAL_SYSTEM?.writeRegister(register: FREEZE_VALVE_CMD_REG.failToOperateTimer, value: tvValue)
          }
      }
      
      if let doseVal = dosingDelayTimer.text, !doseVal.isEmpty,
         let doseValue = Int(doseVal) {
          if doseValue >= 1 && doseValue <= 24 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.dosingTimeout, value: doseValue)
          }
      }
        
      if let vlveOpenVal = vlveOpenTimer.text, !vlveOpenVal.isEmpty,
         let vlveOpenValue = Int(vlveOpenVal) {
          if vlveOpenValue >= 1 && vlveOpenValue <= 3600 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.vlveOpen, value: vlveOpenValue)
          }
      }
      
      if let vlveCloseVal = vlveCloseTimer.text, !vlveCloseVal.isEmpty,
         let vlveCloseValue = Int(vlveCloseVal) {
          if vlveCloseValue >= 1 && vlveCloseValue <= 3600 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.vlveClose, value: vlveCloseValue)
          }
      }
      
      if let strtDosingVal = startDosingTimer.text, !strtDosingVal.isEmpty,
         let strtDosingValue = Int(strtDosingVal) {
          if strtDosingValue >= 1 && strtDosingValue <= 60 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.startTimer, value: strtDosingValue)
          }
      }
      
      if let stopDosingVal = stopDosingTimer.text, !stopDosingVal.isEmpty,
         let stopDosingValue = Int(stopDosingVal) {
          if stopDosingValue >= 1 && stopDosingValue <= 60 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.stopTimer, value: stopDosingValue)
          }
      }
      
      if let strtDosingSPVal = startSP.text, !strtDosingSPVal.isEmpty,
         let strtDosingSPValue = Int(strtDosingSPVal) {
          if strtDosingSPValue >= 1 && strtDosingSPValue <= 10000 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.startSP, value: strtDosingSPValue)
          }
      }
      
      if let stopDosingSPVal = stopSP.text, !stopDosingSPVal.isEmpty,
         let stopDosingSPValue = Int(stopDosingSPVal) {
          if stopDosingSPValue >= 1 && stopDosingSPValue <= 10000 {
              CENTRAL_SYSTEM?.writeRegister(register: BR_VALVE_CMD_REG.stopSP, value: stopDosingSPValue)
          }
      }
        
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
          self.readOnce = 0
          self.readTOnce = 0
      }
    }
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0

            readCurrentKVData()
            readCurrentTVData()
            
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

    func readCurrentKVData(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(BR_VALVE_DATAREGISTER.count), startingRegister: Int32(BR_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.brValues.cmd_valveDisable = cmdArrValues[3]
            self.brValues.cmd_valveFrceOpen = cmdArrValues[4]
            //print(statusArrValues)
            
            self.brValues.cfg_startDosingSP = Int(truncating: response![5] as! NSNumber)
            self.brValues.cfg_stopDosingSP = Int(truncating: response![6] as! NSNumber)
            self.brValues.cfg_startDosingDelayTimer = Int(truncating: response![7] as! NSNumber)
            self.brValues.cfg_stopDosingDelayTimer = Int(truncating: response![8] as! NSNumber)
            self.brValues.cfg_valveOpenDelayTimer = Int(truncating: response![9] as! NSNumber)
            self.brValues.cfg_valveCloseDelayTimer = Int(truncating: response![10] as! NSNumber)
            self.brValues.cfg_dosingTimeoutDelayTimer = Int(truncating: response![11] as! NSNumber)
            
            if self.readOnce == 0{
                self.readOnce = 1
                if self.brValues.cmd_valveDisable == 1{
                    self.brEnable.isOn = true
                } else {
                    self.brEnable.isOn = false
                }
                if self.brValues.cmd_valveFrceOpen == 1{
                    self.brDosing.isOn = true
                } else {
                    self.brDosing.isOn = false
                }
                
                self.startSP.text = String(format: "%d", self.brValues.cfg_startDosingSP)
                self.stopSP.text = String(format: "%d", self.brValues.cfg_stopDosingSP)
                self.startDosingTimer.text = String(format: "%d", self.brValues.cfg_startDosingDelayTimer)
                self.stopDosingTimer.text = String(format: "%d", self.brValues.cfg_stopDosingDelayTimer)
                self.vlveOpenTimer.text = String(format: "%d", self.brValues.cfg_valveOpenDelayTimer)
                self.vlveCloseTimer.text = String(format: "%d", self.brValues.cfg_valveCloseDelayTimer)
                self.dosingDelayTimer.text = String(format: "%d", self.brValues.cfg_dosingTimeoutDelayTimer)
                
            }
            //self.parseWQSystemData(data:self.wqValues, tag:1)
        })
    }
    func readCurrentTVData(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(FREEZE_VALVE_DATAREGISTER.count), startingRegister: Int32(FREEZE_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dumpValValues.cmd_valveDisable = cmdArrValues[2]
            self.dumpValValues.cmd_valveFrceOpen = cmdArrValues[3]
            //print(statusArrValues)
            
            self.dumpValValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            
            if self.readTOnce == 0{
                self.readTOnce = 1
                if self.dumpValValues.cmd_valveDisable == 1{
                    self.dumpVlveSwtch.isOn = true
                } else {
                    self.dumpVlveSwtch.isOn = false
                }
                if self.dumpValValues.cmd_valveFrceOpen == 1{
                    self.frceVlve.isOn = true
                } else {
                    self.frceVlve.isOn = false
                }
                
                self.tv100xDelayTimer.text = String(format: "%d", self.dumpValValues.failToOperateDelayTimer)
            }
            //self.parseWQSystemData(data:self.wqValues, tag:1)
        })
    }
    
    @IBAction func sendCmdVlveFrceOpen(_ sender: UISwitch) {
        if self.dumpValValues.cmd_valveFrceOpen == 1{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdFrcOpen, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdFrcOpen, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readTOnce = 0
        }
    }
    
    @IBAction func sendCmdVlveEnable(_ sender: UISwitch) {
        if self.dumpValValues.cmd_valveDisable == 1{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdDisableValve, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdDisableValve, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readTOnce = 0
        }
    }
    @IBAction func sendCmdBrEnable(_ sender: UISwitch) {
        if self.brValues.cmd_valveDisable == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdDisableValve, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdDisableValve, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
        }
    }
    @IBAction func sendCmdDose(_ sender: UISwitch) {
        if self.brValues.cmd_valveFrceOpen == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdFrcOpen, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdFrcOpen, value: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readOnce = 0
        }
    }
}
