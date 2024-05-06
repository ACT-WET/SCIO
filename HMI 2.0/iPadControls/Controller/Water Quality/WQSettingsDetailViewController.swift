//
//  WQSettingsDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/3/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class WQSettingsDetailViewController: UIViewController {
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var abvHHTimer: UITextField!
    @IBOutlet weak var abvHTimer: UITextField!
    @IBOutlet weak var blwLTimer: UITextField!
    @IBOutlet weak var blwLLTimer: UITextField!
    @IBOutlet weak var blwLLLTimer: UITextField!
    @IBOutlet weak var iPadOverrideSP: UITextField!
    @IBOutlet weak var abvHHSP: UITextField!
    @IBOutlet weak var abvHSP: UITextField!
    @IBOutlet weak var blwLSP: UITextField!
    @IBOutlet weak var blwLLSP: UITextField!
    @IBOutlet weak var blwLLLSP: UITextField!
    @IBOutlet weak var scaledMax: UILabel!
    @IBOutlet weak var scaledMin: UILabel!
    
    @IBOutlet weak var iPadOverrideSwtch: UISwitch!
    @IBOutlet weak var frceHigh: UISwitch!
    @IBOutlet weak var frceLow: UISwitch!
    
    private let logger = Logger()
    private var readOnce = 0
    private var centralSystem = CentralSystem()
    private let helper = Helper()
    var wqRegister = pH_SENSOR_DATAREGISTER
    var wqCmdReg = pH_CMD_REG
    var wqValues  = AI_VALUES()
    var sensorNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool){
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        setupWQLabel()
        constructSaveButton()
        readCurrentWQData()
        //Configure Pump Screen Text Content Based On Device Language
        
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    
    func setupWQLabel(){
        switch sensorNumber {
            case 103: self.navigationItem.title = "pH DETAILS"
                      wqRegister = pH_SENSOR_DATAREGISTER
                      wqCmdReg = pH_CMD_REG
            case 104: self.navigationItem.title = "ORP DETAILS"
                      wqRegister = ORP_SENSOR_DATAREGISTER
                      wqCmdReg = ORP_CMD_REG
            case 105: self.navigationItem.title = "CONDUCTIVITY DETAILS"
                      wqRegister = CONDUCTIVITY_SENSOR_DATAREGISTER
                      wqCmdReg = CONDUCTIVITY_CMD_REG
            case 106: self.navigationItem.title = "BROMINE DETAILS"
                      wqRegister = BR_SENSOR_DATAREGISTER
                      wqCmdReg = BR_CMD_REG
            case 107: self.navigationItem.title = "AT1001 DETAILS"
                      wqRegister = AT1001_TEMP_DATAREGISTER
                      wqCmdReg = AT1001_CMD_REG
            case 108: self.navigationItem.title = "TT1002 DETAILS"
                      wqRegister = TT1002_TEMP_DATAREGISTER
                      wqCmdReg = TT1002_CMD_REG
            case 109: self.navigationItem.title = "TT1003 DETAILS"
                      wqRegister = TT1003_TEMP_DATAREGISTER
                      wqCmdReg = TT1003_CMD_REG
            default:
                print("FAULT TAG")
        }
    }
    
    private func constructSaveButton(){
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveWQSettings))

    }
    @objc private func saveWQSettings(){
      let multiplier = pow(10,wqValues.status_precision)
      
      if let overVal = iPadOverrideSP.text, !overVal.isEmpty,
         let overValue = Float(overVal) {
          if overValue >= 2.0 && overValue <= 10000.0 {
              let newVal = Int(overValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.overrideSP, value: newVal)
          }
      }
      
      if let abvHHVal = abvHHSP.text, !abvHHVal.isEmpty,
         let abvHHValue = Float(abvHHVal) {
          if abvHHValue >= 2.0 && abvHHValue <= 10000.0 {
              let newVal = Int(abvHHValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.abvHHSP, value: newVal)
          }
      }
        
      if let abvHVal = abvHSP.text, !abvHVal.isEmpty,
         let abvHValue = Float(abvHVal) {
          if abvHValue >= 2.0 && abvHValue <= 10000.0 {
              let newVal = Int(abvHValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.abvHSP, value: newVal)
          }
      }
        
      if let blwLVal = blwLSP.text, !blwLVal.isEmpty,
         let blwLValue = Float(blwLVal) {
          if blwLValue >= 2.0 && blwLValue <= 10000.0 {
              let newVal = Int(blwLValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLSP, value: newVal)
          }
      }
      
      if let blwLLVal = blwLLSP.text, !blwLLVal.isEmpty,
         let blwLLValue = Float(blwLLVal) {
          if blwLLValue >= 2.0 && blwLLValue <= 10000.0 {
              let newVal = Int(blwLLValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLLSP, value: newVal)
          }
      }
      
      if let blwLLLVal = blwLLLSP.text, !blwLLLVal.isEmpty,
         let blwLLLValue = Float(blwLLLVal) {
          if blwLLLValue >= 2.0 && blwLLLValue <= 10000.0 {
              let newVal = Int(blwLLLValue * Float(truncating: multiplier as NSNumber))
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLLLSP, value: newVal)
          }
      }
        
      if let abvHHTimerVal = abvHHTimer.text, !abvHHTimerVal.isEmpty,
         let abvHHTimerValue = Int(abvHHTimerVal) {
          if abvHHTimerValue >= 2 && abvHHTimerValue <= 600 {
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.abvHHTimer, value: abvHHTimerValue)
          }
      }
        
      if let abvHTimerVal = abvHTimer.text, !abvHTimerVal.isEmpty,
         let abvHTimerValue = Int(abvHTimerVal) {
          if abvHTimerValue >= 2 && abvHTimerValue <= 600 {
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.abvHTimer, value: abvHTimerValue)
          }
      }
        
      if let blwLTimerVal = blwLTimer.text, !blwLTimerVal.isEmpty,
         let blwLTimerValue = Int(blwLTimerVal) {
          if blwLTimerValue >= 2 && blwLTimerValue <= 600 {
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLTimer, value: blwLTimerValue)
          }
      }
      
      if let blwLLTimerVal = blwLLTimer.text, !blwLLTimerVal.isEmpty,
         let blwLLTimerValue = Int(blwLLTimerVal) {
          if blwLLTimerValue >= 2 && blwLLTimerValue <= 600 {
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLLTimer, value: blwLLTimerValue)
          }
      }
        
      if let blwLLLTimerVal = blwLLLTimer.text, !blwLLLTimerVal.isEmpty,
         let blwLLLTimerValue = Int(blwLLLTimerVal) {
          if blwLLLTimerValue >= 2 && blwLLLTimerValue <= 600 {
              CENTRAL_SYSTEM?.writeRegister(register: wqCmdReg.blwLLLTimer, value: blwLLLTimerValue)
          }
      }
      
       
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
          self.readOnce = 0
      }
    }
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0

            
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

    func readCurrentWQData(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(wqRegister.count), startingRegister: Int32(wqRegister.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.wqValues.cmd_iPadOverride = cmdArrValues[0]
            self.wqValues.cmd_frceHigh = cmdArrValues[1]
            self.wqValues.cmd_frceLow = cmdArrValues[2]
            //print(statusArrValues)
            
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            self.wqValues.status_ScaledValMin = Int(truncating: response![7] as! NSNumber)
            self.wqValues.status_ScaledValMax = Int(truncating: response![8] as! NSNumber)
            self.wqValues.cfg_overrideValSP = Int(truncating: response![9] as! NSNumber)
            self.wqValues.cfg_abvHHSP = Int(truncating: response![10] as! NSNumber)
            self.wqValues.cfg_abvHSP = Int(truncating: response![11] as! NSNumber)
            self.wqValues.cfg_blwLSP = Int(truncating: response![12] as! NSNumber)
            self.wqValues.cfg_blwLLSP = Int(truncating: response![13] as! NSNumber)
            self.wqValues.cfg_blwLLLSP = Int(truncating: response![14] as! NSNumber)
            self.wqValues.cfg_abvHHTimer = Int(truncating: response![15] as! NSNumber)
            self.wqValues.cfg_abvHTimer = Int(truncating: response![16] as! NSNumber)
            self.wqValues.cfg_blwLTimer = Int(truncating: response![17] as! NSNumber)
            self.wqValues.cfg_blwLLTimer = Int(truncating: response![18] as! NSNumber)
            self.wqValues.cfg_blwLLLTimer = Int(truncating: response![19] as! NSNumber)
            
            if self.readOnce == 0{
                self.readOnce = 1
                if self.wqValues.cmd_iPadOverride == 1{
                    self.iPadOverrideSwtch.isOn = true
                } else {
                    self.iPadOverrideSwtch.isOn = false
                }
                if self.wqValues.cmd_frceHigh == 1{
                    self.frceHigh.isOn = true
                } else {
                    self.frceHigh.isOn = false
                }
                if self.wqValues.cmd_frceLow == 1{
                    self.frceLow.isOn = true
                } else {
                    self.frceLow.isOn = false
                }
                
                let divisor = Int(truncating: pow(10,self.wqValues.status_precision) as NSNumber)
                let minValue = Float(self.wqValues.status_ScaledValMin) / Float(truncating: divisor as NSNumber)
                let maxValue = Float(self.wqValues.status_ScaledValMax) / Float(truncating: divisor as NSNumber)
                let iPadValue = Float(self.wqValues.cfg_overrideValSP) / Float(truncating: divisor as NSNumber)
                let abvHHSP =  Float(self.wqValues.cfg_abvHHSP) / Float(truncating: divisor as NSNumber)
                let abvHSP =  Float(self.wqValues.cfg_abvHSP) / Float(truncating: divisor as NSNumber)
                let blwLSP =  Float(self.wqValues.cfg_blwLSP) / Float(truncating: divisor as NSNumber)
                let blwLLSP =  Float(self.wqValues.cfg_blwLLSP) / Float(truncating: divisor as NSNumber)
                let blwLLLSP =  Float(self.wqValues.cfg_blwLLLSP) / Float(truncating: divisor as NSNumber)
                let abvHHTimer = self.wqValues.cfg_abvHHTimer
                let abvHTimer = self.wqValues.cfg_abvHTimer
                let blwLTimer = self.wqValues.cfg_blwLTimer
                let blwLLTimer = self.wqValues.cfg_blwLLTimer
                let blwLLLTimer = self.wqValues.cfg_blwLLLTimer
                
                self.iPadOverrideSP.text = String(format: "%.2f", iPadValue)
                self.scaledMin.text = String(format: "%.2f", minValue)
                self.scaledMax.text = String(format: "%.2f", maxValue)
                self.abvHHSP.text = String(format: "%.2f", abvHHSP)
                self.abvHSP.text = String(format: "%.2f", abvHSP)
                self.blwLSP.text = String(format: "%.2f", blwLSP)
                self.blwLLSP.text = String(format: "%.2f", blwLLSP)
                self.blwLLLSP.text = String(format: "%.2f", blwLLLSP)

                
                self.abvHHTimer.text = String(format: "%d", abvHHTimer)
                self.abvHTimer.text = String(format: "%d", abvHTimer)
                self.blwLTimer.text = String(format: "%d", blwLTimer)
                self.blwLLTimer.text = String(format: "%d", blwLLTimer)
                self.blwLLLTimer.text = String(format: "%d", blwLLLTimer)
                
            }
            //self.parseWQSystemData(data:self.wqValues, tag:1)
        })
    }
    
    @IBAction func sendCmdOverride(_ sender: UISwitch) {
        if self.wqValues.cmd_iPadOverride == 1{
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.overrideCmd, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.overrideCmd, value: 1)
        }
    }
    @IBAction func sendCmdHi(_ sender: UISwitch) {
        if self.wqValues.cmd_frceHigh == 1{
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.frcHiCmd, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.frcHiCmd, value: 1)
        }
    }
    @IBAction func sendCmdLow(_ sender: UISwitch) {
        if self.wqValues.cmd_frceLow == 1{
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.frceLwCmd, value: 0)
        } else {
            CENTRAL_SYSTEM?.writeBit(bit: wqCmdReg.frceLwCmd, value: 1)
        }
    }
}
