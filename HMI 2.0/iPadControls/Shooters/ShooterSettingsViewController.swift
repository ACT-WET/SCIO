//
//  ShooterSettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/1/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class ShooterSettingsViewController: UIViewController {

    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
      
    @IBOutlet weak var yv1001delayTimer: UITextField!
    @IBOutlet weak var yv1002delayTimer: UITextField!
    @IBOutlet weak var yv1003delayTimer: UITextField!
    
    @IBOutlet weak var yv1001disSwtch: UISwitch!
    @IBOutlet weak var yv1002disSwtch: UISwitch!
    @IBOutlet weak var yv1003disSwtch: UISwitch!
    
    @IBOutlet weak var yv1001openSwtch: UISwitch!
    @IBOutlet weak var yv1002openSwtch: UISwitch!
    @IBOutlet weak var yv1003openSwtch: UISwitch!
    
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var shooterValues1  = FOG_MOTOR_SENSOR_VALUES()
    var shooterValues2  = FOG_MOTOR_SENSOR_VALUES()
    var shooterValues3  = FOG_MOTOR_SENSOR_VALUES()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        getShooterDataFromPLC()
        constructSaveButton()
        //This line of code is an extension added to the view controller by showStoppers module
        //This is the only line needed to add show stopper
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        
        NotificationCenter.default.removeObserver(self)
        self.logger.logData(data:"View Is Disappearing")
        
    }
    
    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }
    @objc private func saveSetpoints(){
       saveTimerSetpointDelaysToPLC()
    }
    
    private func saveTimerSetpointDelaysToPLC(){
        
        if let yv1001val = yv1001delayTimer.text, !yv1001val.isEmpty,
           let yv1001value = Int(yv1001val) {
            if yv1001value >= 2 && yv1001value <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: YV1001_SHOOTER_DELAYTIMER, value: yv1001value)
            }
        }
        
        if let yv1002val = yv1002delayTimer.text, !yv1002val.isEmpty,
           let yv1002value = Int(yv1002val) {
            if yv1002value >= 2 && yv1002value <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: YV1002_SHOOTER_DELAYTIMER, value: yv1002value)
            }
        }
        
        if let yv1003val = yv1003delayTimer.text, !yv1003val.isEmpty,
           let yv1003value = Int(yv1003val) {
            if yv1003value >= 2 && yv1003value <= 60 {
               CENTRAL_SYSTEM?.writeRegister(register: YV1003_SHOOTER_DELAYTIMER, value: yv1003value)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.getShooterDataFromPLC()
        }
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
        CENTRAL_SYSTEM?.readRegister(length:Int32(YV1001_SHOOTER.count)  , startingRegister: Int32(YV1001_SHOOTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.shooterValues1.cmd_valveDisable = cmdArrValues[2]
            self.shooterValues1.cmd_valveFrceOpen = cmdArrValues[3]
            if self.shooterValues1.cmd_valveDisable == 1{
                self.yv1001disSwtch.isOn =  false
            } else {
                self.yv1001disSwtch.isOn =  true
            }
            if self.shooterValues1.cmd_valveFrceOpen == 1{
                self.yv1001openSwtch.isOn =  true
            } else {
                self.yv1001openSwtch.isOn =  false
            }
            self.shooterValues1.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            self.yv1001delayTimer.text = "\(self.shooterValues1.failToOperateDelayTimer)"
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(YV1002_SHOOTER.count)  , startingRegister: Int32(YV1002_SHOOTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.shooterValues2.cmd_valveDisable = cmdArrValues[2]
            self.shooterValues2.cmd_valveFrceOpen = cmdArrValues[3]
            if self.shooterValues2.cmd_valveDisable == 1{
                self.yv1002disSwtch.isOn =  false
            } else {
                self.yv1002disSwtch.isOn =  true
            }
            if self.shooterValues2.cmd_valveFrceOpen == 1{
                self.yv1002openSwtch.isOn =  true
            } else {
                self.yv1002openSwtch.isOn =  false
            }
            self.shooterValues2.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            self.yv1002delayTimer.text = "\(self.shooterValues2.failToOperateDelayTimer)"
            
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(YV1003_SHOOTER.count)  , startingRegister: Int32(YV1003_SHOOTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.shooterValues3.cmd_valveDisable = cmdArrValues[2]
            self.shooterValues3.cmd_valveFrceOpen = cmdArrValues[3]
            if self.shooterValues3.cmd_valveDisable == 1{
                self.yv1003disSwtch.isOn =  false
            } else {
                self.yv1003disSwtch.isOn =  true
            }
            if self.shooterValues3.cmd_valveFrceOpen == 1{
                self.yv1003openSwtch.isOn =  true
            } else {
                self.yv1003openSwtch.isOn =  false
            }
            self.shooterValues3.failToOperateDelayTimer = Int(truncating: response![4] as! NSNumber)
            self.yv1003delayTimer.text = "\(self.shooterValues3.failToOperateDelayTimer)"
        })
    }

    @IBAction func sendCmdEnableValve(_ sender: UISwitch) {
        if sender.tag == 3{
            if self.shooterValues3.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_DISABLE, value: 1)
            }
        }
        if sender.tag == 2{
            if self.shooterValues2.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_DISABLE, value: 1)
            }
        }
        if sender.tag == 1{
            if self.shooterValues1.cmd_valveDisable == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_DISABLE, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_DISABLE, value: 1)
            }
        }
        getShooterDataFromPLC()
    }
    @IBAction func sendCmdForceOpenValve(_ sender: UISwitch) {
        if sender.tag == 13{
            if self.shooterValues3.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_ON, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_ON, value: 0)
            }
        }
        if sender.tag == 12{
            if self.shooterValues2.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_ON, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_ON, value: 0)
            }
        }
        if sender.tag == 11{
            if self.shooterValues1.cmd_valveFrceOpen == 0{
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_ON, value: 1)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_ON, value: 0)
            }
        }
        getShooterDataFromPLC()
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
