//
//  DCPowerViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/6/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class DCPowerViewController: UIViewController {

    @IBOutlet weak var dcp101autoHandImg: UIImageView!
    @IBOutlet weak var dcp102autoHandImg: UIImageView!
    @IBOutlet weak var dcp103autoHandImg: UIImageView!
    @IBOutlet weak var dcp104autoHandImg: UIImageView!
    @IBOutlet weak var dcp105autoHandImg: UIImageView!
    
    @IBOutlet weak var parLightSwitch: UISwitch!
    @IBOutlet weak var dcp101fanStartStpBtn: UIButton!
    @IBOutlet weak var dcp102fanStartStpBtn: UIButton!
    @IBOutlet weak var dcp103fanStartStpBtn: UIButton!
    @IBOutlet weak var dcp104fanStartStpBtn: UIButton!
    @IBOutlet weak var dcp105fanStartStpBtn: UIButton!
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var dcp101ResetBtn: UIButton!
    @IBOutlet weak var dcp102ResetBtn: UIButton!
    @IBOutlet weak var dcp103ResetBtn: UIButton!
    @IBOutlet weak var dcp104ResetBtn: UIButton!
    @IBOutlet weak var dcp105ResetBtn: UIButton!
    @IBOutlet weak var dcpPwrCycleBtn: UIButton!
    
    var dc1Values  = DC_POWER_VALUES()
    var dc2Values  = DC_POWER_VALUES()
    var dc3Values  = DC_POWER_VALUES()
    var dc4Values  = DC_POWER_VALUES()
    var dc5Values  = DC_POWER_VALUES()
    var readOnce = 0
    var read2Once = 0
    var read3Once = 0
    var read4Once = 0
    var read5Once = 0
    var read6Once = 0
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
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
            getDCPDataFromPLC()
            readParLights()
            
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
      override func viewDidLoad() {
          super.viewDidLoad()

          // Do any additional setup after loading the view.
      }
    func readParLights(){
        if self.read6Once == 0{
           CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(PAR_LIGHT_POWER_BIT), completion: { (success, response) in
               
               guard success == true else { return }
               
               let status = Int(truncating: response![0] as! NSNumber)
               
               if status == 1{
                   self.parLightSwitch.isOn = true
               } else {
                   self.parLightSwitch.isOn = false
               }
               self.read6Once = 1
           })
        }
    }
    
    func getDCPDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:7 , startingRegister: Int32(DCP101_POWER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dc1Values.pwrEnabled = statusArrValues[0]
            self.dc1Values.pwrOn = statusArrValues[1]
            self.dc1Values.coolingFanOn = statusArrValues[2]
            self.dc1Values.faulted = statusArrValues[3]
            self.dc1Values.inAuto = statusArrValues[4]
            self.dc1Values.inHand = statusArrValues[5]
            self.dc1Values.warningHighTemp = statusArrValues[6]
            self.dc1Values.hihighTemp = statusArrValues[7]
            self.dc1Values.sensorFault = statusArrValues[8]
            self.dc1Values.scalingFault = statusArrValues[9]
            self.dc1Values.outOfRange = statusArrValues[10]
            self.dc1Values.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dc1Values.cmd_HandMode = cmdArrValues[0]
            self.dc1Values.cmd_HandStartStop = cmdArrValues[1]
            
            self.dc1Values.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dc1Values.precision = Int(truncating: response![6] as! NSNumber)
            
            let scaledVal = self.view.viewWithTag(2) as? UILabel
            let pwrOn = self.view.viewWithTag(3) as? UILabel
            let enabled = self.view.viewWithTag(4) as? UILabel
            let faulted = self.view.viewWithTag(5) as? UILabel
            let sensorFault = self.view.viewWithTag(6) as? UILabel
            let scaling = self.view.viewWithTag(7) as? UILabel
            let outOfRange = self.view.viewWithTag(8) as? UILabel
            let eStop = self.view.viewWithTag(9) as? UILabel
             
            self.dc1Values.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dc1Values.pwrOn == 1 ? ( pwrOn?.isHidden = false) : (pwrOn?.isHidden = true)
            self.dc1Values.sensorFault == 1 ? ( sensorFault?.isHidden = false) : (sensorFault?.isHidden = true)
            self.dc1Values.scalingFault == 1 ? ( scaling?.isHidden = false) : (scaling?.isHidden = true)
            self.dc1Values.outOfRange == 1 ? ( outOfRange?.isHidden = false) : (outOfRange?.isHidden = true)
            self.dc1Values.pwrEnabled == 1 ? ( enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.dc1Values.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.dc1Values.precision)
            let scaledValue = Float(self.dc1Values.scaledValue) / Float(truncating: divisor as NSNumber)
            scaledVal!.text = String(format: "%.1f", scaledValue)
            
            if self.dc1Values.faulted == 1{
              self.dcp101ResetBtn.isHidden = false
            } else {
              self.dcp101ResetBtn.isHidden = true
            }
            
            if self.dc1Values.warningHighTemp == 1{
                scaledVal!.textColor = YELLOW_COLOR
            } else if self.dc1Values.hihighTemp == 1{
                scaledVal!.textColor = RED_COLOR
            } else {
                scaledVal!.textColor = .white
            }
            
            if self.readOnce == 0{
                if self.dc1Values.inAuto == 1{
                    self.dcp101autoHandImg.image = #imageLiteral(resourceName: "autoMode")
                    self.dcp101autoHandImg.rotate360Degrees(animate: true)
                    self.dcp101fanStartStpBtn.isUserInteractionEnabled = false
                }
                if self.dc1Values.inHand == 1{
                    self.dcp101autoHandImg.image = #imageLiteral(resourceName: "handMode")
                    self.dcp101autoHandImg.rotate360Degrees(animate: false)
                    self.dcp101fanStartStpBtn.isUserInteractionEnabled = true
                }
                
                if self.dc1Values.coolingFanOn == 1{
                    self.dcp101fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanGreen"), for: .normal)
                    self.dcp101fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                if self.dc1Values.coolingFanOn == 0{
                    self.dcp101fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanRed"), for: .normal)
                    self.dcp101fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                self.readOnce = 1
            }
        })
        
        CENTRAL_SYSTEM?.readRegister(length:7 , startingRegister: Int32(DCP102_POWER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dc2Values.pwrEnabled = statusArrValues[0]
            self.dc2Values.pwrOn = statusArrValues[1]
            self.dc2Values.coolingFanOn = statusArrValues[2]
            self.dc2Values.faulted = statusArrValues[3]
            self.dc2Values.inAuto = statusArrValues[4]
            self.dc2Values.inHand = statusArrValues[5]
            self.dc2Values.warningHighTemp = statusArrValues[6]
            self.dc2Values.hihighTemp = statusArrValues[7]
            self.dc2Values.sensorFault = statusArrValues[8]
            self.dc2Values.scalingFault = statusArrValues[9]
            self.dc2Values.outOfRange = statusArrValues[10]
            self.dc2Values.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dc2Values.cmd_HandMode = cmdArrValues[0]
            self.dc2Values.cmd_HandStartStop = cmdArrValues[1]
            
            self.dc2Values.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dc2Values.precision = Int(truncating: response![6] as! NSNumber)
            
            let scaledVal = self.view.viewWithTag(12) as? UILabel
            let pwrOn = self.view.viewWithTag(13) as? UILabel
            let enabled = self.view.viewWithTag(14) as? UILabel
            let faulted = self.view.viewWithTag(15) as? UILabel
            let sensorFault = self.view.viewWithTag(16) as? UILabel
            let scaling = self.view.viewWithTag(17) as? UILabel
            let outOfRange = self.view.viewWithTag(18) as? UILabel
            let eStop = self.view.viewWithTag(19) as? UILabel
             
            self.dc2Values.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dc2Values.pwrOn == 1 ? ( pwrOn?.isHidden = false) : (pwrOn?.isHidden = true)
            self.dc2Values.sensorFault == 1 ? ( sensorFault?.isHidden = false) : (sensorFault?.isHidden = true)
            self.dc2Values.scalingFault == 1 ? ( scaling?.isHidden = false) : (scaling?.isHidden = true)
            self.dc2Values.outOfRange == 1 ? ( outOfRange?.isHidden = false) : (outOfRange?.isHidden = true)
            self.dc2Values.pwrEnabled == 1 ? ( enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.dc2Values.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.dc2Values.precision)
            let scaledValue = Float(self.dc2Values.scaledValue) / Float(truncating: divisor as NSNumber)
            scaledVal!.text = String(format: "%.1f", scaledValue)
            
            if self.dc2Values.faulted == 1{
              self.dcp102ResetBtn.isHidden = false
            } else {
              self.dcp102ResetBtn.isHidden = true
            }
            
            if self.dc2Values.warningHighTemp == 1{
                scaledVal!.textColor = YELLOW_COLOR
            } else if self.dc2Values.hihighTemp == 1{
                scaledVal!.textColor = RED_COLOR
            } else {
                scaledVal!.textColor = .white
            }
            
            if self.read2Once == 0{
                if self.dc2Values.inAuto == 1{
                    self.dcp102autoHandImg.image = #imageLiteral(resourceName: "autoMode")
                    self.dcp102autoHandImg.rotate360Degrees(animate: true)
                    self.dcp102fanStartStpBtn.isUserInteractionEnabled = false
                }
                if self.dc2Values.inHand == 1{
                    self.dcp102autoHandImg.image = #imageLiteral(resourceName: "handMode")
                    self.dcp102autoHandImg.rotate360Degrees(animate: false)
                    self.dcp102fanStartStpBtn.isUserInteractionEnabled = true
                }
                
                if self.dc2Values.coolingFanOn == 1{
                    self.dcp102fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanGreen"), for: .normal)
                    self.dcp102fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                if self.dc2Values.coolingFanOn == 0{
                    self.dcp102fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanRed"), for: .normal)
                    self.dcp102fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                self.read2Once = 1
            }
        })
        
        CENTRAL_SYSTEM?.readRegister(length:7 , startingRegister: Int32(DCP103_POWER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dc3Values.pwrEnabled = statusArrValues[0]
            self.dc3Values.pwrOn = statusArrValues[1]
            self.dc3Values.coolingFanOn = statusArrValues[2]
            self.dc3Values.faulted = statusArrValues[3]
            self.dc3Values.inAuto = statusArrValues[4]
            self.dc3Values.inHand = statusArrValues[5]
            self.dc3Values.warningHighTemp = statusArrValues[6]
            self.dc3Values.hihighTemp = statusArrValues[7]
            self.dc3Values.sensorFault = statusArrValues[8]
            self.dc3Values.scalingFault = statusArrValues[9]
            self.dc3Values.outOfRange = statusArrValues[10]
            self.dc3Values.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dc3Values.cmd_HandMode = cmdArrValues[0]
            self.dc3Values.cmd_HandStartStop = cmdArrValues[1]
            
            self.dc3Values.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dc3Values.precision = Int(truncating: response![6] as! NSNumber)
            
            let scaledVal = self.view.viewWithTag(22) as? UILabel
            let pwrOn = self.view.viewWithTag(23) as? UILabel
            let enabled = self.view.viewWithTag(24) as? UILabel
            let faulted = self.view.viewWithTag(25) as? UILabel
            let sensorFault = self.view.viewWithTag(26) as? UILabel
            let scaling = self.view.viewWithTag(27) as? UILabel
            let outOfRange = self.view.viewWithTag(28) as? UILabel
            let eStop = self.view.viewWithTag(29) as? UILabel
             
            self.dc3Values.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dc3Values.pwrOn == 1 ? ( pwrOn?.isHidden = false) : (pwrOn?.isHidden = true)
            self.dc3Values.sensorFault == 1 ? ( sensorFault?.isHidden = false) : (sensorFault?.isHidden = true)
            self.dc3Values.scalingFault == 1 ? ( scaling?.isHidden = false) : (scaling?.isHidden = true)
            self.dc3Values.outOfRange == 1 ? ( outOfRange?.isHidden = false) : (outOfRange?.isHidden = true)
            self.dc3Values.pwrEnabled == 1 ? ( enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.dc3Values.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.dc3Values.precision)
            let scaledValue = Float(self.dc3Values.scaledValue) / Float(truncating: divisor as NSNumber)
            scaledVal!.text = String(format: "%.1f", scaledValue)
            
            if self.dc3Values.faulted == 1{
              self.dcp103ResetBtn.isHidden = false
            } else {
              self.dcp103ResetBtn.isHidden = true
            }
            
            if self.dc3Values.warningHighTemp == 1{
                scaledVal!.textColor = YELLOW_COLOR
            } else if self.dc3Values.hihighTemp == 1{
                scaledVal!.textColor = RED_COLOR
            } else {
                scaledVal!.textColor = .white
            }
            
            if self.read3Once == 0{
                if self.dc3Values.inAuto == 1{
                    self.dcp103autoHandImg.image = #imageLiteral(resourceName: "autoMode")
                    self.dcp103autoHandImg.rotate360Degrees(animate: true)
                    self.dcp103fanStartStpBtn.isUserInteractionEnabled = false
                }
                if self.dc3Values.inHand == 1{
                    self.dcp103autoHandImg.image = #imageLiteral(resourceName: "handMode")
                    self.dcp103autoHandImg.rotate360Degrees(animate: false)
                    self.dcp103fanStartStpBtn.isUserInteractionEnabled = true
                }
                
                if self.dc3Values.coolingFanOn == 1{
                    self.dcp103fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanGreen"), for: .normal)
                    self.dcp103fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                if self.dc3Values.coolingFanOn == 0{
                    self.dcp103fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanRed"), for: .normal)
                    self.dcp103fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                self.read3Once = 1
            }
        })
        
        CENTRAL_SYSTEM?.readRegister(length:7 , startingRegister: Int32(DCP104_POWER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dc4Values.pwrEnabled = statusArrValues[0]
            self.dc4Values.pwrOn = statusArrValues[1]
            self.dc4Values.coolingFanOn = statusArrValues[2]
            self.dc4Values.faulted = statusArrValues[3]
            self.dc4Values.inAuto = statusArrValues[4]
            self.dc4Values.inHand = statusArrValues[5]
            self.dc4Values.warningHighTemp = statusArrValues[6]
            self.dc4Values.hihighTemp = statusArrValues[7]
            self.dc4Values.sensorFault = statusArrValues[8]
            self.dc4Values.scalingFault = statusArrValues[9]
            self.dc4Values.outOfRange = statusArrValues[10]
            self.dc4Values.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dc4Values.cmd_HandMode = cmdArrValues[0]
            self.dc4Values.cmd_HandStartStop = cmdArrValues[1]
            
            self.dc4Values.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dc4Values.precision = Int(truncating: response![6] as! NSNumber)
            
            let scaledVal = self.view.viewWithTag(32) as? UILabel
            let pwrOn = self.view.viewWithTag(33) as? UILabel
            let enabled = self.view.viewWithTag(34) as? UILabel
            let faulted = self.view.viewWithTag(35) as? UILabel
            let sensorFault = self.view.viewWithTag(36) as? UILabel
            let scaling = self.view.viewWithTag(37) as? UILabel
            let outOfRange = self.view.viewWithTag(38) as? UILabel
            let eStop = self.view.viewWithTag(39) as? UILabel
             
            self.dc4Values.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dc4Values.pwrOn == 1 ? ( pwrOn?.isHidden = false) : (pwrOn?.isHidden = true)
            self.dc4Values.sensorFault == 1 ? ( sensorFault?.isHidden = false) : (sensorFault?.isHidden = true)
            self.dc4Values.scalingFault == 1 ? ( scaling?.isHidden = false) : (scaling?.isHidden = true)
            self.dc4Values.outOfRange == 1 ? ( outOfRange?.isHidden = false) : (outOfRange?.isHidden = true)
            self.dc4Values.pwrEnabled == 1 ? ( enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.dc4Values.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.dc4Values.precision)
            let scaledValue = Float(self.dc4Values.scaledValue) / Float(truncating: divisor as NSNumber)
            scaledVal!.text = String(format: "%.1f", scaledValue)
            
            if self.dc4Values.faulted == 1{
              self.dcp104ResetBtn.isHidden = false
            } else {
              self.dcp104ResetBtn.isHidden = true
            }
            
            if self.dc4Values.warningHighTemp == 1{
                scaledVal!.textColor = YELLOW_COLOR
            } else if self.dc4Values.hihighTemp == 1{
                scaledVal!.textColor = RED_COLOR
            } else {
                scaledVal!.textColor = .white
            }
            
            if self.read4Once == 0{
                if self.dc4Values.inAuto == 1{
                    self.dcp104autoHandImg.image = #imageLiteral(resourceName: "autoMode")
                    self.dcp104autoHandImg.rotate360Degrees(animate: true)
                    self.dcp104fanStartStpBtn.isUserInteractionEnabled = false
                }
                if self.dc4Values.inHand == 1{
                    self.dcp104autoHandImg.image = #imageLiteral(resourceName: "handMode")
                    self.dcp104autoHandImg.rotate360Degrees(animate: false)
                    self.dcp104fanStartStpBtn.isUserInteractionEnabled = true
                }
                
                if self.dc4Values.coolingFanOn == 1{
                    self.dcp104fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanGreen"), for: .normal)
                    self.dcp104fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                if self.dc4Values.coolingFanOn == 0{
                    self.dcp104fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanRed"), for: .normal)
                    self.dcp104fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                self.read4Once = 1
            }
        })
        
        CENTRAL_SYSTEM?.readRegister(length:7 , startingRegister: Int32(DCP105_POWER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dc5Values.pwrEnabled = statusArrValues[0]
            self.dc5Values.pwrOn = statusArrValues[1]
            self.dc5Values.coolingFanOn = statusArrValues[2]
            self.dc5Values.faulted = statusArrValues[3]
            self.dc5Values.inAuto = statusArrValues[4]
            self.dc5Values.inHand = statusArrValues[5]
            self.dc5Values.warningHighTemp = statusArrValues[6]
            self.dc5Values.hihighTemp = statusArrValues[7]
            self.dc5Values.sensorFault = statusArrValues[8]
            self.dc5Values.scalingFault = statusArrValues[9]
            self.dc5Values.outOfRange = statusArrValues[10]
            self.dc5Values.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dc5Values.cmd_HandMode = cmdArrValues[0]
            self.dc5Values.cmd_HandStartStop = cmdArrValues[1]
            
            self.dc5Values.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dc5Values.precision = Int(truncating: response![6] as! NSNumber)
            
            let scaledVal = self.view.viewWithTag(42) as? UILabel
            let pwrOn = self.view.viewWithTag(43) as? UILabel
            let enabled = self.view.viewWithTag(44) as? UILabel
            let faulted = self.view.viewWithTag(45) as? UILabel
            let sensorFault = self.view.viewWithTag(46) as? UILabel
            let scaling = self.view.viewWithTag(47) as? UILabel
            let outOfRange = self.view.viewWithTag(48) as? UILabel
            let eStop = self.view.viewWithTag(49) as? UILabel
             
            self.dc5Values.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.dc5Values.pwrOn == 1 ? ( pwrOn?.isHidden = false) : (pwrOn?.isHidden = true)
            self.dc5Values.sensorFault == 1 ? ( sensorFault?.isHidden = false) : (sensorFault?.isHidden = true)
            self.dc5Values.scalingFault == 1 ? ( scaling?.isHidden = false) : (scaling?.isHidden = true)
            self.dc5Values.outOfRange == 1 ? ( outOfRange?.isHidden = false) : (outOfRange?.isHidden = true)
            self.dc5Values.pwrEnabled == 1 ? ( enabled?.isHidden = false) : (enabled?.isHidden = true)
            self.dc5Values.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.dc5Values.precision)
            let scaledValue = Float(self.dc5Values.scaledValue) / Float(truncating: divisor as NSNumber)
            scaledVal!.text = String(format: "%.1f", scaledValue)
            
            if self.dc5Values.faulted == 1{
              self.dcp105ResetBtn.isHidden = false
            } else {
              self.dcp105ResetBtn.isHidden = true
            }
            
            if self.dc5Values.warningHighTemp == 1{
                scaledVal!.textColor = YELLOW_COLOR
            } else if self.dc5Values.hihighTemp == 1{
                scaledVal!.textColor = RED_COLOR
            } else {
                scaledVal!.textColor = .white
            }
            
            if self.read5Once == 0{
                if self.dc5Values.inAuto == 1{
                    self.dcp105autoHandImg.image = #imageLiteral(resourceName: "autoMode")
                    self.dcp105autoHandImg.rotate360Degrees(animate: true)
                    self.dcp105fanStartStpBtn.isUserInteractionEnabled = false
                }
                if self.dc5Values.inHand == 1{
                    self.dcp105autoHandImg.image = #imageLiteral(resourceName: "handMode")
                    self.dcp105autoHandImg.rotate360Degrees(animate: false)
                    self.dcp105fanStartStpBtn.isUserInteractionEnabled = true
                }
                
                if self.dc5Values.coolingFanOn == 1{
                    self.dcp105fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanGreen"), for: .normal)
                    self.dcp105fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                if self.dc5Values.coolingFanOn == 0{
                    self.dcp105fanStartStpBtn.setImage(#imageLiteral(resourceName: "fanRed"), for: .normal)
                    self.dcp105fanStartStpBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
                }
                self.read5Once = 1
            }
        })
    }
     
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
        if sender.tag == 10{
           CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag == 20{
           CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag == 30{
           CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag == 40{
           CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag == 50{
           CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_FAULTRESET, value: 1)
        }
    }
    
    @IBAction func sendStartStopCmd(_ sender: UIButton){
        if sender.tag == 1{
            if dc1Values.coolingFanOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDCMD, value: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.readOnce = 0
            }
       }
       if sender.tag == 11{
            if dc2Values.coolingFanOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDCMD, value: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read2Once = 0
            }
       }
       if sender.tag == 21{
            if dc3Values.coolingFanOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDCMD, value: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read3Once = 0
            }
       }
       if sender.tag == 31{
            if dc4Values.coolingFanOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDCMD, value: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read4Once = 0
            }
       }
       if sender.tag == 41{
            if dc5Values.coolingFanOn == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDCMD, value: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read5Once = 0
            }
       }
    }
    
    @IBAction func sendAutoHandCmd(_ sender: UIButton){
        if sender.tag == 151{
            if dc1Values.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDMODE, value: 1)
            }
            if dc1Values.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDMODE, value: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.readOnce = 0
            }
        }
        if sender.tag == 152{
            if dc2Values.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDMODE, value: 1)
            }
            if dc2Values.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDMODE, value: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read2Once = 0
            }
        }
        if sender.tag == 153{
            if dc3Values.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDMODE, value: 1)
            }
            if dc3Values.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDMODE, value: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read3Once = 0
            }
        }
        if sender.tag == 154{
            if dc4Values.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDMODE, value: 1)
            }
            if dc4Values.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDMODE, value: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read4Once = 0
            }
        }
        if sender.tag == 155{
            if dc5Values.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDMODE, value: 1)
            }
            if dc5Values.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDMODE, value: 0)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.read5Once = 0
            }
        }
    }
    
    @IBAction func sendCmdPwrCycle(_ sender: UIButton) {
        if sender.tag == 160{
           CENTRAL_SYSTEM?.writeBit(bit: DCP_POWER_CYCLE_CMD, value: 1)
           self.dcpPwrCycleBtn.isUserInteractionEnabled = false
           self.dcpPwrCycleBtn.isEnabled = false
           DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
               self.dcpPwrCycleBtn.isUserInteractionEnabled = true
               self.dcpPwrCycleBtn.isEnabled = true
           })
        }
    }
    
    @IBAction func sendCmdSwtch(_ sender: UISwitch) {
        if self.parLightSwitch.isOn == true{
           CENTRAL_SYSTEM?.writeBit(bit: PAR_LIGHT_POWER_BIT, value: 1)
        } else {
           CENTRAL_SYSTEM?.writeBit(bit: PAR_LIGHT_POWER_BIT, value: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.read6Once = 0
        }
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
