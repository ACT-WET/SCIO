//
//  PumpSettingsViewController.swift
//  iPadControls
//
//  Created by Arpi Derm on 12/28/16.
//  Copyright © 2016 WET. All rights reserved.
//

import UIKit

class PumpSettingsViewController: UIViewController{

    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionLbl: UILabel!
    
    @IBOutlet weak var psll1003TimerTxt: UITextField!
    @IBOutlet weak var psll1004TimerTxt: UITextField!
    @IBOutlet weak var psll1005TimerTxt: UITextField!
    @IBOutlet weak var psll1006TimerTxt: UITextField!
    @IBOutlet weak var psll10034WarningTimerTxt: UITextField!
    @IBOutlet weak var psll10056WarningTimerTxt: UITextField!
    
    @IBOutlet weak var vfd103TimerTxt: UITextField!
    @IBOutlet weak var vfd104TimerTxt: UITextField!
    @IBOutlet weak var vfd105TimerTxt: UITextField!
    @IBOutlet weak var vfd106TimerTxt: UITextField!
    @IBOutlet weak var vfd107TimerTxt: UITextField!
    @IBOutlet weak var vfd108TimerTxt: UITextField!
    @IBOutlet weak var vfd109TimerTxt: UITextField!
    
    @IBOutlet weak var blosmaxFreq: UILabel!
    @IBOutlet weak var blosminFreq: UILabel!
    @IBOutlet weak var blosmaxVolt: UILabel!
    @IBOutlet weak var blosminVolt: UILabel!
    @IBOutlet weak var blosmaxCurr: UILabel!
    @IBOutlet weak var blosminCurr: UILabel!
    
    @IBOutlet weak var plumemaxFreq: UILabel!
    @IBOutlet weak var plumeminFreq: UILabel!
    @IBOutlet weak var plumemaxVolt: UILabel!
    @IBOutlet weak var plumeminVolt: UILabel!
    @IBOutlet weak var plumemaxCurr: UILabel!
    @IBOutlet weak var plumeminCurr: UILabel!
    
    private var centralSystem = CentralSystem()
    //Object References
    let logger = Logger()
    
    //Show stoppers tructure
    var showStopper = ShowStoppers()
    
    //Selected Pump Number and Details
    var pumpDetails:PumpDetail?

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
    
    }

    
    //MARK: - View Did Appear
    
    override func viewWillAppear(_ animated: Bool){
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        
        self.getCurrentSetpoints()
        self.constructSaveButton()
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Get Current Setpoints
    
    private func getCurrentSetpoints(){
        CENTRAL_SYSTEM?.readRegister(length: Int32(BLOSSOM_PLUME_MAX_SP.count) , startingRegister: Int32(BLOSSOM_PLUME_MAX_SP.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.blosminFreq.text = "\(Int(truncating: response![0] as! NSNumber))"
            self.blosmaxFreq.text = "\(Int(truncating: response![1] as! NSNumber))"
            self.blosminVolt.text = "\(Int(truncating: response![2] as! NSNumber))"
            self.blosmaxVolt.text = "\(Int(truncating: response![3] as! NSNumber))"
            self.blosminCurr.text = "\(Int(truncating: response![4] as! NSNumber))"
            self.blosmaxCurr.text = "\(Int(truncating: response![5] as! NSNumber))"
            
            self.plumeminFreq.text = "\(Int(truncating: response![6] as! NSNumber))"
            self.plumemaxFreq.text = "\(Int(truncating: response![7] as! NSNumber))"
            self.plumeminVolt.text = "\(Int(truncating: response![8] as! NSNumber))"
            self.plumemaxVolt.text = "\(Int(truncating: response![9] as! NSNumber))"
            self.plumeminCurr.text = "\(Int(truncating: response![10] as! NSNumber))"
            self.plumemaxCurr.text = "\(Int(truncating: response![11] as! NSNumber))"
        })
        
        CENTRAL_SYSTEM?.readRegister(length: Int32(BLOSSOM_DELAYTIMERS.count) , startingRegister: Int32(BLOSSOM_DELAYTIMERS.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.psll10034WarningTimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
            self.psll10056WarningTimerTxt.text = "\(Int(truncating: response![1] as! NSNumber))"
            self.psll1003TimerTxt.text = "\(Int(truncating: response![3] as! NSNumber))"
            self.psll1004TimerTxt.text = "\(Int(truncating: response![4] as! NSNumber))"
            self.psll1005TimerTxt.text = "\(Int(truncating: response![5] as! NSNumber))"
            self.psll1006TimerTxt.text = "\(Int(truncating: response![6] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD103_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd103TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD104_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd104TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD105_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd105TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD106_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd106TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD107_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd107TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD108_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd108TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        CENTRAL_SYSTEM?.readRegister(length: 1 , startingRegister: Int32(VFD109_CFG_DELAYTIMER), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            
            self.vfd109TimerTxt.text = "\(Int(truncating: response![0] as! NSNumber))"
        })
        
    }
    
    
    //MARK: - Construct Save bar button item
    
    private func constructSaveButton(){
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(savePumpSettings))

    }

    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            noConnectionView.isUserInteractionEnabled = false
            
        } else {
            noConnectionView.alpha = 1
            if plcConnection == CONNECTION_STATE_FAILED {
                noConnectionLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                noConnectionLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    
    
    //MARK: - Pressure Delay Setpoint
    
    @objc private func savePumpSettings(){
       
          if let warning1Val = psll10034WarningTimerTxt.text, !warning1Val.isEmpty,
             let warning1Value = Int(warning1Val) {
              if warning1Value >= 0 && warning1Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL10034_WARNING_TIMER, value: warning1Value)
              }
          }
        
          if let warning2Val = psll10056WarningTimerTxt.text, !warning2Val.isEmpty,
             let warning2Value = Int(warning2Val) {
              if warning2Value >= 0 && warning2Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL10056_WARNING_TIMER, value: warning2Value)
              }
          }
          
          if let fault1Val = psll1003TimerTxt.text, !fault1Val.isEmpty,
             let fault1Value = Int(fault1Val) {
              if fault1Value >= 0 && fault1Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL1003_FAULT_TIMER, value: fault1Value)
              }
          }
          
          if let fault2Val = psll1004TimerTxt.text, !fault2Val.isEmpty,
             let fault2Value = Int(fault2Val) {
              if fault2Value >= 0 && fault2Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL1004_FAULT_TIMER, value: fault2Value)
              }
          }
          
          if let fault3Val = psll1005TimerTxt.text, !fault3Val.isEmpty,
             let fault3Value = Int(fault3Val) {
              if fault3Value >= 0 && fault3Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL1005_FAULT_TIMER, value: fault3Value)
              }
          }
        
          if let fault4Val = psll1006TimerTxt.text, !fault4Val.isEmpty,
             let fault4Value = Int(fault4Val) {
              if fault4Value >= 0 && fault4Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: BLOSSOM_PSL1006_FAULT_TIMER, value: fault4Value)
              }
          }
        
          if let vfd103Val = vfd103TimerTxt.text, !vfd103Val.isEmpty,
             let vfd103Value = Int(vfd103Val) {
              if vfd103Value >= 0 && vfd103Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD103_CFG_DELAYTIMER, value: vfd103Value)
              }
          }
          
          if let vfd104Val = vfd104TimerTxt.text, !vfd104Val.isEmpty,
             let vfd104Value = Int(vfd104Val) {
              if vfd104Value >= 0 && vfd104Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD104_CFG_DELAYTIMER, value: vfd104Value)
              }
          }
          
          if let vfd105Val = vfd105TimerTxt.text, !vfd105Val.isEmpty,
             let vfd105Value = Int(vfd105Val) {
              if vfd105Value >= 0 && vfd105Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD105_CFG_DELAYTIMER, value: vfd105Value)
              }
          }
          
          if let vfd106Val = vfd106TimerTxt.text, !vfd106Val.isEmpty,
             let vfd106Value = Int(vfd106Val) {
              if vfd106Value >= 0 && vfd106Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD106_CFG_DELAYTIMER, value: vfd106Value)
              }
          }
          
          if let vfd107Val = vfd107TimerTxt.text, !vfd107Val.isEmpty,
             let vfd107Value = Int(vfd107Val) {
              if vfd107Value >= 0 && vfd107Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD107_CFG_DELAYTIMER, value: vfd107Value)
              }
          }
          
          if let vfd108Val = vfd108TimerTxt.text, !vfd108Val.isEmpty,
             let vfd108Value = Int(vfd108Val) {
              if vfd108Value >= 0 && vfd108Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD108_CFG_DELAYTIMER, value: vfd108Value)
              }
          }
          
          if let vfd109Val = vfd109TimerTxt.text, !vfd109Val.isEmpty,
             let vfd109Value = Int(vfd109Val) {
              if vfd109Value >= 0 && vfd109Value <= 60 {
                 CENTRAL_SYSTEM?.writeRegister(register: VFD109_CFG_DELAYTIMER, value: vfd109Value)
              }
          }
        
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
              self.getCurrentSetpoints()
          }
    }

}
