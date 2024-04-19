//
//  SaltPurgeSettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 10/8/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SaltPurgeSettingsViewController: UIViewController {

    @IBOutlet weak var offSP: UITextField!
    @IBOutlet weak var onSP: UITextField!
    @IBOutlet weak var valveTimer: UITextField!
    private var centralSystem = CentralSystem()
   override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }
    
    @objc private func saveSetpoints(){
        
        self.saveSetpointsToPLC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        constructSaveButton()
        readSaltFillStats()
    }
    
    func readSaltFillStats (){
        
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PURGE_ONSP), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.onSP.text =  String(format: "%.1f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PURGE_OFFSP), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.offSP.text =  String(format: "%.1f", value)
            })
            
        CENTRAL_SYSTEM!.readRegister(length: 3, startingRegister: Int32(PURGEVALVE_TIMER), completion:{ (success, response) in
            
            guard success == true else { return }
                
            let value = Int(truncating: response![0] as! NSNumber)
            
            
            self.valveTimer.text = "\(value)"
        })
    }
    
    private func saveSetpointsToPLC(){
        
        let valveTimer = Int(self.valveTimer.text!)
        
        //Checkpoints to make sure Setpoint Input Is Not Empty
        
        guard valveTimer != nil else{
            return
        }
        
        CENTRAL_SYSTEM?.writeRegister(register: PURGEVALVE_TIMER, value: valveTimer!)
        
        let onSP = Float(self.onSP.text!)
        let offSP = Float(self.offSP.text!)
        
        
        guard onSP != nil && offSP != nil else{
            return
        }
        
        
        
        CENTRAL_SYSTEM?.writeRealValue(register: PURGE_ONSP, value: onSP!)
        CENTRAL_SYSTEM?.writeRealValue(register: PURGE_OFFSP, value: offSP!)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.readSaltFillStats()
        }
    }

}
