//
//  ShootersViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/6/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class ShootersViewController: UIViewController,UIGestureRecognizerDelegate {

      @IBOutlet weak var noConnectionView:     UIView!
      @IBOutlet weak var noConnectionErrorLbl: UILabel!
      @IBOutlet weak var shooter1autoHandImg: UIImageView!
      @IBOutlet weak var shooter1PlayStopBtn: UIButton!
      @IBOutlet weak var shooter2autoHandImg: UIImageView!
      @IBOutlet weak var shooter2PlayStopBtn: UIButton!
      @IBOutlet weak var shooter3autoHandImg: UIImageView!
      @IBOutlet weak var shooter3PlayStopBtn: UIButton!
      @IBOutlet weak var airPressScaleMax: UILabel!
      @IBOutlet weak var airPressScaleMin: UILabel!
      @IBOutlet weak var airPressCurrVal: UILabel!
      @IBOutlet weak var airPressCurrView: UIView!
      @IBOutlet weak var airPressHandSPVal: UILabel!
      @IBOutlet weak var airPressHandView: UIView!
      @IBOutlet weak var airPressautoHandImg: UIImageView!
      @IBOutlet weak var airPressBackgnd: UIView!
     
      var manualAirGesture: UIPanGestureRecognizer!
      var pixelPerPress = 550/10.0
      var readOnce = 0
      var readAOnce = 0
      var shooterNum = 0
      var shooterStartingRegister = 0
      private var centralSystem = CentralSystem()
      private let logger =  Logger()
      var shooterValues  = FOG_MOTOR_SENSOR_VALUES()
      var shooter2Values  = FOG_MOTOR_SENSOR_VALUES()
      var shooter3Values  = FOG_MOTOR_SENSOR_VALUES()
      var airPressValues  = AO_VALUES()
    
      override func viewWillAppear(_ animated: Bool){
          //Add notification observer to get system stat
          centralSystem.getNetworkParameters()
          centralSystem.connect()
          CENTRAL_SYSTEM = centralSystem
          NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
          initializePumpGestureRecognizer()
          //This line of code is an extension added to the view controller by showStoppers module
          //This is the only line needed to add show stopper
      }
      private func initializePumpGestureRecognizer(){
          
          //RME: Initiate PUMP Flow Control Gesture Handler
          
          manualAirGesture = UIPanGestureRecognizer(target: self, action: #selector(changeAirPressure(sender:)))
          airPressHandView.isUserInteractionEnabled = true
          airPressHandView.addGestureRecognizer(self.manualAirGesture)
          manualAirGesture.delegate = self
          
      }
      override func viewDidLoad() {
          super.viewDidLoad()

          // Do any additional setup after loading the view.
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
              getShooterDataFromPLC()
              getAirPressureDataFromPLC()
              
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
    func getAirPressureDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length: Int32(APC_SHOOTER.count) , startingRegister: Int32(APC_SHOOTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            
            self.airPressValues.faulted = statusArrValues[2]
            self.airPressValues.inAuto = statusArrValues[3]
            self.airPressValues.inHand = statusArrValues[4]
            self.airPressValues.scalingFault = statusArrValues[5]
            self.airPressValues.outputmoduleFault = statusArrValues[6]
            self.airPressValues.estop = statusArrValues[7]
            
            self.airPressValues.cfg_autoSP = Int(truncating: response![4] as! NSNumber)
            self.airPressValues.cfg_precision = Int(truncating: response![6] as! NSNumber)
            self.airPressValues.cfg_scaleMin = Int(truncating: response![7] as! NSNumber)
            self.airPressValues.cfg_scaleMax = Int(truncating: response![8] as! NSNumber)
            self.airPressValues.cfg_handModeSP = Int(truncating: response![9] as! NSNumber)
            
            let faulted = self.view.viewWithTag(31) as? UILabel
            let scalingFault = self.view.viewWithTag(32) as? UILabel
            let outFault = self.view.viewWithTag(33) as? UILabel
            let eStop = self.view.viewWithTag(34) as? UILabel
            
            self.airPressValues.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
            self.airPressValues.scalingFault == 1 ? ( scalingFault?.isHidden = false) : (scalingFault?.isHidden = true)
            self.airPressValues.outputmoduleFault == 1 ? ( outFault?.isHidden = false) : (outFault?.isHidden = true)
            self.airPressValues.estop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
            
            let divisor = pow(10,self.airPressValues.cfg_precision)
            let scaledMin = Float(self.airPressValues.cfg_scaleMin) / Float(truncating: divisor as NSNumber)
            self.airPressScaleMin.text = String(format: "%.1f", scaledMin)
            
            let scaledMax = Float(self.airPressValues.cfg_scaleMax) / Float(truncating: divisor as NSNumber)
            self.airPressScaleMax.text = String(format: "%.1f", scaledMax)
            self.pixelPerPress = Double(450.0/scaledMax)
            
            if self.airPressValues.inAuto == 1{
                let outputVal = Float(self.airPressValues.cfg_autoSP) / Float(truncating: divisor as NSNumber)
                let indicatorLocation = abs(outputVal * Float(self.pixelPerPress))
                self.airPressCurrView.frame = CGRect(x: 387 + Int(indicatorLocation), y: 617, width: 62, height: 39)
                self.airPressBackgnd.frame = CGRect(x: 0, y: 0, width: Int(indicatorLocation), height: 25)
                self.airPressCurrVal.text = String(format: "%.1f", outputVal)
            }
            
            if self.readAOnce == 0{
               let handSP = Float(self.airPressValues.cfg_handModeSP) / Float(truncating: divisor as NSNumber)
               self.airPressHandSPVal.text = String(format: "%.1f", handSP)
               if self.airPressValues.inAuto == 1{
                   self.airPressautoHandImg.image = #imageLiteral(resourceName: "autoMode")
                   self.airPressautoHandImg.rotate360Degrees(animate: true)
                   self.airPressHandView.isHidden = true
               }
               if self.airPressValues.inHand == 1{
                   self.airPressautoHandImg.image = #imageLiteral(resourceName: "handMode")
                   self.airPressautoHandImg.rotate360Degrees(animate: false)
                   self.airPressHandView.isHidden = false
                   
                   let outputVal = Float(self.airPressValues.cfg_handModeSP) / Float(truncating: divisor as NSNumber)
                   let indicatorLocation = abs(outputVal * Float(self.pixelPerPress))
                   
                   self.airPressHandView.frame = CGRect(x: 387 + Int(indicatorLocation), y: 681, width: 62, height: 39)
                   self.airPressCurrView.frame = CGRect(x: 387 + Int(indicatorLocation), y: 617, width: 62, height: 39)
                   self.airPressBackgnd.frame = CGRect(x: 0, y: 0, width: Int(indicatorLocation), height: 25)
                   
                   self.airPressCurrVal.text = String(format: "%.1f", outputVal)
               }
               self.readAOnce = 1
            }
            
            
        })
    }
    
      func getShooterDataFromPLC(){
          CENTRAL_SYSTEM?.readRegister(length: Int32(YV1001_SHOOTER.count) , startingRegister: Int32(YV1001_SHOOTER.startAddr), completion: { (sucess, response) in
              
              //Check points to make sure the PLC Call was successful
              
              guard sucess == true else{
                  self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                  return
              }
              let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
              //print(statusArrValues)
              self.shooterValues.valveOpen = statusArrValues[1]
              self.shooterValues.valveClose = statusArrValues[2]
              self.shooterValues.faulted = statusArrValues[4]
              self.shooterValues.inAuto = statusArrValues[5]
              self.shooterValues.inHand = statusArrValues[6]
              self.shooterValues.failToOpen = statusArrValues[9]
              self.shooterValues.failToClose = statusArrValues[10]
              self.shooterValues.eStop = statusArrValues[11]
            
              let faulted = self.view.viewWithTag(1) as? UILabel
              let fToOpen = self.view.viewWithTag(2) as? UILabel
              let fToClose = self.view.viewWithTag(3) as? UILabel
              let eStop = self.view.viewWithTag(4) as? UILabel
               
              
              self.shooterValues.faulted == 1 ? (faulted?.isHidden = false) : (faulted?.isHidden = true)
              self.shooterValues.failToOpen == 1 ? ( fToOpen?.isHidden = false) : (fToOpen?.isHidden = true)
              self.shooterValues.failToClose == 1 ? ( fToClose?.isHidden = false) : (fToClose?.isHidden = true)
              self.shooterValues.eStop == 1 ? ( eStop?.isHidden = false) : (eStop?.isHidden = true)
              
              CENTRAL_SYSTEM?.readRegister(length: Int32(YV1002_SHOOTER.count) , startingRegister: Int32(YV1002_SHOOTER.startAddr), completion: { (sucess, response) in
                  
                  //Check points to make sure the PLC Call was successful
                  
                  guard sucess == true else{
                      self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                      return
                  }
                  let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                  //print(statusArrValues)
                  
                  self.shooter2Values.valveOpen = statusArrValues[1]
                  self.shooter2Values.valveClose = statusArrValues[2]
                  self.shooter2Values.faulted = statusArrValues[4]
                  self.shooter2Values.inAuto = statusArrValues[5]
                  self.shooter2Values.inHand = statusArrValues[6]
                  self.shooter2Values.failToOpen = statusArrValues[9]
                  self.shooter2Values.failToClose = statusArrValues[10]
                  self.shooter2Values.eStop = statusArrValues[11]
                
                  let faulted2 = self.view.viewWithTag(11) as? UILabel
                  let fToOpen2 = self.view.viewWithTag(12) as? UILabel
                  let fToClose2 = self.view.viewWithTag(13) as? UILabel
                  let eStop2 = self.view.viewWithTag(14) as? UILabel
                   
                  
                  self.shooter2Values.faulted == 1 ? (faulted2?.isHidden = false) : (faulted2?.isHidden = true)
                  self.shooter2Values.failToOpen == 1 ? ( fToOpen2?.isHidden = false) : (fToOpen2?.isHidden = true)
                  self.shooter2Values.failToClose == 1 ? ( fToClose2?.isHidden = false) : (fToClose2?.isHidden = true)
                  self.shooter2Values.eStop == 1 ? ( eStop2?.isHidden = false) : (eStop2?.isHidden = true)
                  
                  CENTRAL_SYSTEM?.readRegister(length: Int32(YV1003_SHOOTER.count) , startingRegister: Int32(YV1003_SHOOTER.startAddr), completion: { (sucess, response) in
                      
                      //Check points to make sure the PLC Call was successful
                      
                      guard sucess == true else{
                          self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                          return
                      }
                      let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                      //print(statusArrValues)
                      
                      self.shooter3Values.valveOpen = statusArrValues[1]
                      self.shooter3Values.valveClose = statusArrValues[2]
                      self.shooter3Values.faulted = statusArrValues[4]
                      self.shooter3Values.inAuto = statusArrValues[5]
                      self.shooter3Values.inHand = statusArrValues[6]
                      self.shooter3Values.failToOpen = statusArrValues[9]
                      self.shooter3Values.failToClose = statusArrValues[10]
                      self.shooter3Values.eStop = statusArrValues[11]
                      
                      let faulted3 = self.view.viewWithTag(21) as? UILabel
                      let fToOpen3 = self.view.viewWithTag(22) as? UILabel
                      let fToClose3 = self.view.viewWithTag(23) as? UILabel
                      let eStop3 = self.view.viewWithTag(24) as? UILabel
                       
                      
                      self.shooter3Values.faulted == 1 ? (faulted3?.isHidden = false) : (faulted3?.isHidden = true)
                      self.shooter3Values.failToOpen == 1 ? ( fToOpen3?.isHidden = false) : (fToOpen3?.isHidden = true)
                      self.shooter3Values.failToClose == 1 ? ( fToClose3?.isHidden = false) : (fToClose3?.isHidden = true)
                      self.shooter3Values.eStop == 1 ? ( eStop3?.isHidden = false) : (eStop3?.isHidden = true)
                      
                      if self.readOnce == 0{
                          self.parseShooterSystemData()
                          self.readOnce = 1
                      }
                      
                  })
                  
              })
              
          })
      }
      
      func parseShooterSystemData(){
          
          if self.shooterValues.inAuto == 1{
              shooter1autoHandImg.image = #imageLiteral(resourceName: "autoMode")
              shooter1autoHandImg.rotate360Degrees(animate: true)
              shooter1PlayStopBtn.isUserInteractionEnabled = false
          }
          if self.shooterValues.inHand == 1{
              shooter1autoHandImg.image = #imageLiteral(resourceName: "handMode")
              shooter1autoHandImg.rotate360Degrees(animate: false)
              shooter1PlayStopBtn.isUserInteractionEnabled = true
          }
          
          if self.shooterValues.valveOpen == 1{
              shooter1PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter1PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
          }
          if self.shooterValues.valveClose == 1{
              shooter1PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter1PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
          }
          
          
        
          if self.shooter2Values.inAuto == 1{
              shooter2autoHandImg.image = #imageLiteral(resourceName: "autoMode")
              shooter2autoHandImg.rotate360Degrees(animate: true)
              shooter2PlayStopBtn.isUserInteractionEnabled = false
          }
          if self.shooter2Values.inHand == 1{
              shooter2autoHandImg.image = #imageLiteral(resourceName: "handMode")
              shooter2autoHandImg.rotate360Degrees(animate: false)
              shooter2PlayStopBtn.isUserInteractionEnabled = true
          }
          
          if self.shooter2Values.valveOpen == 1{
              shooter2PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter2PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
          }
          if self.shooter2Values.valveClose == 1{
              shooter2PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter2PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
          }
          
          
        
          if self.shooter3Values.inAuto == 1{
              shooter3autoHandImg.image = #imageLiteral(resourceName: "autoMode")
              shooter3autoHandImg.rotate360Degrees(animate: true)
              shooter3PlayStopBtn.isUserInteractionEnabled = false
          }
          if self.shooter3Values.inHand == 1{
              shooter3autoHandImg.image = #imageLiteral(resourceName: "handMode")
              shooter3autoHandImg.rotate360Degrees(animate: false)
              shooter3PlayStopBtn.isUserInteractionEnabled = true
          }
          
          if self.shooter3Values.valveOpen == 1{
              shooter3PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter3PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-green"), for: .normal)
          }
          if self.shooter3Values.valveClose == 1{
              shooter3PlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "background"), for: .normal)
              shooter3PlayStopBtn.setImage(#imageLiteral(resourceName: "valve-red"), for: .normal)
          }
          
      }
    
      @IBAction func sendAutoHandCmd(_ sender: UIButton){
          if sender.tag == 121{
              if shooterValues.inAuto == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDMODE, value: 1)
              }
              if shooterValues.inHand == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDMODE, value: 0)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
              
          }
          if sender.tag == 122{
              if shooter2Values.inAuto == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDMODE, value: 1)
              }
              if shooter2Values.inHand == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDMODE, value: 0)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
          }
          if sender.tag == 123{
              if shooter3Values.inAuto == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDMODE, value: 1)
              }
              if shooter3Values.inHand == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDMODE, value: 0)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
          }
          if sender.tag == 124{
              if airPressValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: APC_SHOOTER_CMD_REG.setHandAuto, value: 1)
              }
              if airPressValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: APC_SHOOTER_CMD_REG.setHandAuto, value: 0)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readAOnce = 0
              }
          }
      }
      @IBAction func sendStartStopCmd(_ sender: UIButton){
         if sender.tag == 5{
              if shooterValues.valveOpen == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDCMD, value: 0)
              } else {
                  CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDCMD, value: 1)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
         }
         if sender.tag == 15{
              if shooter2Values.valveOpen == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDCMD, value: 0)
              } else {
                  CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDCMD, value: 1)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
         }
         if sender.tag == 25{
              if shooter3Values.valveOpen == 1{
                  CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDCMD, value: 0)
              } else {
                  CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDCMD, value: 1)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                  self.readOnce = 0
              }
         }
      }
    
      @objc func changeAirPressure(sender: UIPanGestureRecognizer){
          
          var touchLocation:CGPoint = sender.location(in: self.view)
          //print(touchLocation.x)
          //Make sure that we don't go more than pump flow limit
          if touchLocation.x  < 417 {
              touchLocation.x = 417
          }
          if touchLocation.x  > 867 {
              touchLocation.x = 867
          }
          
          //Make sure that we don't go more than pump flow limit
          if touchLocation.x >= 417 && touchLocation.x <= 867 {
              
              sender.view?.center.x = touchLocation.x
              let multiplier = pow(10,self.airPressValues.cfg_precision)
              let flowRange = 867 - Int(touchLocation.x)
              let herts = Double(Float(self.airPressValues.cfg_scaleMax) / Float(truncating: multiplier as NSNumber)) - Double(flowRange) / self.pixelPerPress
              let convertedVal = Int(Float(herts) * Float(truncating: multiplier as NSNumber))
              print(convertedVal)
              self.airPressHandSPVal.text = String(format: "%.1f", herts)

              if sender.state == .ended {
                CENTRAL_SYSTEM?.writeRegister(register: APC_SHOOTER_CMD_REG.handModeSP, value: convertedVal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.readAOnce = 0
                }
              }
          }
      }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
    
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
        if sender.tag == 6{
           CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag  == 16{
           CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag  == 26{
           CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_FAULTRESET, value: 1)
        }
        if sender.tag  == 36{
            CENTRAL_SYSTEM?.writeBit(bit: APC_SHOOTER_CMD_REG.faultReset, value: 1)
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
