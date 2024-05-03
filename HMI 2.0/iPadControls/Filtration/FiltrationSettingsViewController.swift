//
//  FiltrationSettingsViewController.swift
//  iPadControls
//
//  Created by Arpi Derm on 2/28/17.
//  Copyright © 2017 WET. All rights reserved.
//

import UIKit

class FiltrationSettingsViewController: UIViewController, UITextFieldDelegate{

     
        @IBOutlet weak var noConnectionView: UIView!
        @IBOutlet weak var noConnectionErrorLbl: UILabel!
        
        @IBOutlet weak var pslTimer: UITextField!
        @IBOutlet weak var psllTimer: UITextField!
        @IBOutlet weak var vfd101FailToRunTimer: UITextField!
        private var readSettings = true
        private var centralSystem = CentralSystem()
        //MARK: - View Life Cycle
        let logger = Logger()
        override func viewDidLoad(){
            
            super.viewDidLoad()

        }
        
        override func viewWillAppear(_ animated: Bool) {
            centralSystem.getNetworkParameters()
            centralSystem.connect()
            CENTRAL_SYSTEM = centralSystem
            constructSaveButton()
            
            //Add notification observer to get system stat
            NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
            readValues()
        }
        
        
        override func viewWillDisappear(_ animated: Bool) {
            NotificationCenter.default.removeObserver(self)
        }
        
        
        @objc func checkSystemStat(){
            let (plcConnection,_) = CENTRAL_SYSTEM!.getConnectivityStat()
            
            if plcConnection == CONNECTION_STATE_CONNECTED {
                
                //Change the connection stat indicator
                noConnectionView.alpha = 0
                
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
        //MARK: - Construct Save bar button item
        
        private func constructSaveButton(){
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
            
        }
        
        
        private func readValues() {
            CENTRAL_SYSTEM?.readRegister(length: Int32(FILTRATION_DELAYTIMERS.count) , startingRegister: Int32(FILTRATION_DELAYTIMERS.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                
                self.pslTimer.text = "\(Int(truncating: response![0] as! NSNumber))"
                self.psllTimer.text = "\(Int(truncating: response![3] as! NSNumber))"
                
            })
            CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(VFD101_CFG_DELAYTIMER), completion: { (success, response) in
                
                guard success == true else { return }
                
               self.vfd101FailToRunTimer.text = "\(Int(truncating: response![0] as! NSNumber))"
            })
            
            
        }
        
        
        
        //MARK: - Save  Setpoints
        
        @objc private func saveSetpoints(){
           if let vfd101Val = vfd101FailToRunTimer.text, !vfd101Val.isEmpty,
              let vfd101Value = Int(vfd101Val) {
               if vfd101Value >= 0 && vfd101Value <= 60 {
                  CENTRAL_SYSTEM?.writeRegister(register: VFD101_CFG_DELAYTIMER, value: vfd101Value)
               }
           }
           if let psl1001Val = pslTimer.text, !psl1001Val.isEmpty,
              let psl1001Value = Int(psl1001Val) {
               if psl1001Value >= 0 && psl1001Value <= 60 {
                  CENTRAL_SYSTEM?.writeRegister(register: FILTRATION_PSL1001_FAULT_TIMER, value: psl1001Value)
               }
           }
           if let psll1001Val = psllTimer.text, !psll1001Val.isEmpty,
              let psll1001Value = Int(psll1001Val) {
               if psll1001Value >= 0 && psll1001Value <= 60 {
                  CENTRAL_SYSTEM?.writeRegister(register: FILTRATION_PSLL1001_FAULT_TIMER, value: psll1001Value)
               }
           }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.readValues()
            }
        }
    }
