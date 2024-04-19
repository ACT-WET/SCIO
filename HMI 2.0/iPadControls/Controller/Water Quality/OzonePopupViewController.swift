//
//  OzonePopupViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/9/19.
//  Copyright © 2019 WET. All rights reserved.
//

import UIKit

class OzonePopupViewController: UIViewController {
    
    
    @IBOutlet weak var pumpFault: UILabel!
    @IBOutlet weak var motorOverload: UILabel!
    @IBOutlet weak var pressureFault: UILabel!
    @IBOutlet weak var ozonePumpOnOffLbl: UILabel!
    @IBOutlet weak var ozonLabl: UILabel!
    var ozoneId = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pumpFault.isHidden = true
        self.motorOverload.isHidden = true
        self.pressureFault.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        if ozoneId == 1{
            self.ozonLabl.text = "MS - 110 OZONE"
            readOzoneFaults(startRegister: WALL1_OZONE_FAULTS)
        } else if ozoneId == 2{
            self.ozonLabl.text = "MS - 210 OZONE"
            readOzoneFaults(startRegister: WALL2_OZONE_FAULTS)
        } else if ozoneId == 3{
            self.ozonLabl.text = "MS - 310 OZONE"
            readOzoneFaults(startRegister: WALL3_OZONE_FAULTS)
        }
    }
    
    func readOzoneFaults(startRegister: Int){
        CENTRAL_SYSTEM?.readBits(length: 3, startingRegister: Int32(startRegister), completion: { (sucess, response) in
            
            if response != nil{
                
                let pumpRunning = Int(truncating: response![0] as! NSNumber)
                let pumpFault = Int(truncating: response![1] as! NSNumber)
                let motorOverload = Int(truncating: response![2] as! NSNumber)
                
                if pumpRunning == 1{
                    
                    self.ozonePumpOnOffLbl.text = "PUMP CURRENTLY ON"
                    self.ozonePumpOnOffLbl.textColor = GREEN_COLOR
                    
                } else if pumpRunning == 0{
                    
                    self.ozonePumpOnOffLbl.text = "PUMP CURRENTLY OFF"
                    self.ozonePumpOnOffLbl.textColor = DEFAULT_GRAY
                }
                if pumpFault == 1{
                    self.pressureFault.isHidden = false
                } else {
                    self.pressureFault.isHidden = true
                }
                if motorOverload == 1{
                    self.motorOverload.isHidden = false
                } else {
                    self.motorOverload.isHidden = true
                }
            }
            
        })
    }
    
    
    @objc func getData(){
        if ozoneId == 1{
            readOzoneFaults(startRegister: WALL1_OZONE_FAULTS)
        } else if ozoneId == 2{
            readOzoneFaults(startRegister: WALL2_OZONE_FAULTS)
        } else if ozoneId == 3{
            readOzoneFaults(startRegister: WALL3_OZONE_FAULTS)
        }    }
}

