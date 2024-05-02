//
//  FogSettingsViewController.swift
//  iPadControls
//
//  Created by Jan Manalo on 10/8/18.
//  Copyright © 2018 WET. All rights reserved.
//

import Foundation

class FogSettingsViewController: UIViewController  {
    
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var ringAdelayTimer: UITextField!
    @IBOutlet weak var ringLdelayTimer: UITextField!
    @IBOutlet weak var ringBdelayTimer: UITextField!
    @IBOutlet weak var plumeAdelayTimer: UITextField!
    @IBOutlet weak var plumeLdelayTimer: UITextField!
    @IBOutlet weak var plumeBdelayTimer: UITextField!
    
    @IBOutlet weak var ringAvlvEnableSwitch: UISwitch!
    @IBOutlet weak var ringAvlvFrceSwitch: UISwitch!
    
    @IBOutlet weak var ringLvlvEnableSwitch: UISwitch!
    @IBOutlet weak var ringLvlvFrceSwitch: UISwitch!
    
    @IBOutlet weak var ringBvlvEnableSwitch: UISwitch!
    @IBOutlet weak var ringBvlvFrceSwitch: UISwitch!
    
    @IBOutlet weak var plumeAvlvEnableSwitch: UISwitch!
    @IBOutlet weak var plumeAvlvFrceSwitch: UISwitch!
    
    @IBOutlet weak var plumeLvlvEnableSwitch: UISwitch!
    @IBOutlet weak var plumeLvlvFrceSwitch: UISwitch!
    
    @IBOutlet weak var plumeBvlvEnableSwitch: UISwitch!
    @IBOutlet weak var plumeBvlvFrceSwitch: UISwitch!
    
    var fogRingAValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogRingLValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogRingBValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeAValues = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeLValues = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeBValues = FOG_MOTOR_SENSOR_VALUES()
    
    private let logger =  Logger()
    
    override func viewWillAppear(_ animated: Bool) {
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
         constructSaveButton()
         readFogLData()
         readFogAData()
         readFogBData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self)
    }

    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }
    @objc private func saveSetpoints(){
       saveTimerSetpointDelaysToPLC()
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
    
    private func readFogBData() {
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1587_B.count) , startingRegister: Int32(FOGRING_YV1587_B.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingBValues.cmd_valveDisable = cmdArrValues[2]
            self.fogRingBValues.cmd_valveFrceOpen = cmdArrValues[3]
            self.fogRingBValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            
            self.ringBdelayTimer.text = "\(self.fogRingBValues.failToOperateDelayTimer)"
            
            if self.fogRingBValues.cmd_valveDisable == 1{
                self.ringBvlvEnableSwitch.isOn = false
            } else {
                self.ringBvlvEnableSwitch.isOn = true
            }
            
            if self.fogRingBValues.cmd_valveFrceOpen == 1{
                self.ringBvlvFrceSwitch.isOn = true
            } else {
                self.ringBvlvFrceSwitch.isOn = false
            }
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1589_B.count) , startingRegister: Int32(FOGPLUME_YV1589_B.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeBValues.cmd_valveDisable = cmdArrValues[2]
                self.fogPlumeBValues.cmd_valveFrceOpen = cmdArrValues[3]
                self.fogPlumeBValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
                
                self.plumeBdelayTimer.text = "\(self.fogPlumeBValues.failToOperateDelayTimer)"
                
                if self.fogPlumeBValues.cmd_valveDisable == 1{
                    self.plumeBvlvEnableSwitch.isOn = false
                } else {
                    self.plumeBvlvEnableSwitch.isOn = true
                }
                
                if self.fogPlumeBValues.cmd_valveFrceOpen == 1{
                    self.plumeBvlvFrceSwitch.isOn = true
                } else {
                    self.plumeBvlvFrceSwitch.isOn = false
                }
            })
        })
    }
    private func readFogAData() {
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1580_A.count) , startingRegister: Int32(FOGRING_YV1580_A.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingAValues.cmd_valveDisable = cmdArrValues[2]
            self.fogRingAValues.cmd_valveFrceOpen = cmdArrValues[3]
            self.fogRingAValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            
            self.ringAdelayTimer.text = "\(self.fogRingAValues.failToOperateDelayTimer)"
            
            if self.fogRingAValues.cmd_valveDisable == 1{
                self.ringAvlvEnableSwitch.isOn = false
            } else {
                self.ringAvlvEnableSwitch.isOn = true
            }
            
            if self.fogRingAValues.cmd_valveFrceOpen == 1{
                self.ringAvlvFrceSwitch.isOn = true
            } else {
                self.ringAvlvFrceSwitch.isOn = false
            }
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1582_A.count) , startingRegister: Int32(FOGPLUME_YV1582_A.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeAValues.cmd_valveDisable = cmdArrValues[2]
                self.fogPlumeAValues.cmd_valveFrceOpen = cmdArrValues[3]
                self.fogPlumeAValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
                
                self.plumeAdelayTimer.text = "\(self.fogPlumeAValues.failToOperateDelayTimer)"
                
                if self.fogPlumeAValues.cmd_valveDisable == 1{
                    self.plumeAvlvEnableSwitch.isOn = false
                } else {
                    self.plumeAvlvEnableSwitch.isOn = true
                }
                
                if self.fogPlumeAValues.cmd_valveFrceOpen == 1{
                    self.plumeAvlvFrceSwitch.isOn = true
                } else {
                    self.plumeAvlvFrceSwitch.isOn = false
                }
            })
        })
    }
    
    private func readFogLData() {
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1583_L.count) , startingRegister: Int32(FOGRING_YV1583_L.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingLValues.cmd_valveDisable = cmdArrValues[2]
            self.fogRingLValues.cmd_valveFrceOpen = cmdArrValues[3]
            self.fogRingLValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            
            self.ringLdelayTimer.text = "\(self.fogRingLValues.failToOperateDelayTimer)"
            
            if self.fogRingLValues.cmd_valveDisable == 1{
                self.ringLvlvEnableSwitch.isOn = false
            } else {
                self.ringLvlvEnableSwitch.isOn = true
            }
            
            if self.fogRingLValues.cmd_valveFrceOpen == 1{
                self.ringLvlvFrceSwitch.isOn = true
            } else {
                self.ringLvlvFrceSwitch.isOn = false
            }
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1585_L.count) , startingRegister: Int32(FOGPLUME_YV1585_L.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeLValues.cmd_valveDisable = cmdArrValues[2]
                self.fogPlumeLValues.cmd_valveFrceOpen = cmdArrValues[3]
                self.fogPlumeLValues.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
                
                self.plumeLdelayTimer.text = "\(self.fogPlumeLValues.failToOperateDelayTimer)"
                
                if self.fogPlumeLValues.cmd_valveDisable == 1{
                    self.plumeLvlvEnableSwitch.isOn = false
                } else {
                    self.plumeLvlvEnableSwitch.isOn = true
                }
                
                if self.fogPlumeLValues.cmd_valveFrceOpen == 1{
                    self.plumeLvlvFrceSwitch.isOn = true
                } else {
                    self.plumeLvlvFrceSwitch.isOn = false
                }
            })
        })
    }
    
    private func saveTimerSetpointDelaysToPLC(){
        
        if let ringLDelayVal = ringLdelayTimer.text, !ringLDelayVal.isEmpty,
           let ringLDelayValue = Int(ringLDelayVal) {
            if ringLDelayValue >= 2 && ringLDelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: RING_L_DELAYTIMER, value: ringLDelayValue)
            }
        }
        
        if let ringADelayVal = ringAdelayTimer.text, !ringADelayVal.isEmpty,
           let ringADelayValue = Int(ringADelayVal) {
            if ringADelayValue >= 2 && ringADelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: RING_A_DELAYTIMER, value: ringADelayValue)
            }
        }
        
        if let ringBDelayVal = ringBdelayTimer.text, !ringBDelayVal.isEmpty,
           let ringBDelayValue = Int(ringBDelayVal) {
            if ringBDelayValue >= 2 && ringBDelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: RING_B_DELAYTIMER, value: ringBDelayValue)
            }
        }
        
        if let plumeLDelayVal = plumeLdelayTimer.text, !plumeLDelayVal.isEmpty,
           let plumeLDelayValue = Int(plumeLDelayVal) {
            if plumeLDelayValue >= 2 && plumeLDelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: PLUME_L_DELAYTIMER, value: plumeLDelayValue)
            }
        }
        if let plumeADelayVal = plumeAdelayTimer.text, !plumeADelayVal.isEmpty,
           let plumeADelayValue = Int(plumeADelayVal) {
            if plumeADelayValue >= 2 && plumeADelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: PLUME_A_DELAYTIMER, value: plumeADelayValue)
            }
        }
        if let plumeBDelayVal = plumeBdelayTimer.text, !plumeBDelayVal.isEmpty,
           let plumeBDelayValue = Int(plumeBDelayVal) {
            if plumeBDelayValue >= 2 && plumeBDelayValue <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: PLUME_B_DELAYTIMER, value: plumeBDelayValue)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.readFogLData()
            self.readFogAData()
            self.readFogBData()
        }
    }
    
    @IBAction func sendCmdEnableValve(_ sender: UISwitch) {
        if sender.tag == 2{
            if self.fogRingLValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_iPAD_DISABLE, value: 1)
            }
        }
        if sender.tag == 1{
            if self.fogRingAValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_iPAD_DISABLE, value: 1)
            }
        }
        if sender.tag == 3{
            if self.fogRingBValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_iPAD_DISABLE, value: 1)
            }
        }
        if sender.tag == 5{
            if self.fogPlumeLValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_iPAD_DISABLE, value: 1)
            }
        }
        if sender.tag == 4{
            if self.fogPlumeAValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_iPAD_DISABLE, value: 1)
            }
        }
        if sender.tag == 6{
            if self.fogPlumeBValues.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_iPAD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_iPAD_DISABLE, value: 1)
            }
        }
    }
    @IBAction func sendCmdForceOpenValve(_ sender: UISwitch) {
        if sender.tag == 12{
            if self.fogRingLValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
        if sender.tag == 11{
            if self.fogRingAValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
        if sender.tag == 13{
            if self.fogRingBValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
        if sender.tag == 15{
            if self.fogPlumeLValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
        if sender.tag == 14{
            if self.fogPlumeAValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
        if sender.tag == 16{
            if self.fogPlumeBValues.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_iPAD_FORCEOPEN, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_iPAD_FORCEOPEN, value: 0)
            }
        }
    }
}
