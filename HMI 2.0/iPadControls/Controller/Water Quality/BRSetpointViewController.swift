//
//  BRSetpointViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 12/20/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit

class BRSetpointViewController: UIViewController {

    @IBOutlet weak var brSetpointHigh: UITextField!
    @IBOutlet weak var brSetpointLow: UITextField!
    var waterqualityEW = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        readSetPoints()
        // Do any additional setup after loading the view.
    }
    private func readSetPoints(){
        
        CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: 346, completion: { (success, response) in
            guard success == true else { return }
            self.brSetpointLow.text   = "\(response)"
        })
        
        CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: 345, completion: { (success, response) in
            guard success == true else { return }
            self.brSetpointHigh.text   = "\(response)"
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    
    @IBAction func writeSetpoints(_ sender: UIButton) {
        var setpointlow  = Int(self.brSetpointLow.text!)
        var setpointhigh  = Int(self.brSetpointHigh.text!)
        
        if setpointlow == nil {
            setpointlow = 0
        }
        if setpointhigh == nil {
            setpointhigh = 100
        }
        
        if setpointlow! < 0{
            setpointlow = 0
        }
        if setpointlow! > 900{
            setpointlow = 900
        }
        if setpointhigh! > 1000 || setpointhigh! < 100{
            setpointhigh = setpointlow! + 100
        }
       
        
         CENTRAL_SYSTEM?.writeRegister(register: 346, value: Int(setpointlow!))
         CENTRAL_SYSTEM?.writeRegister(register: 345, value: Int(setpointhigh!))
        
    }
    

}
