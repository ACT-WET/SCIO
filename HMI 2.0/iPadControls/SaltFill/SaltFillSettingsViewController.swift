//
//  SaltFillSettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/14/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SaltFillSettingsViewController: UIViewController {
    
    @IBOutlet weak var ltscaledMaxName: UILabel!
    @IBOutlet weak var ltscaledMinName: UILabel!
    @IBOutlet weak var ptscaledMaxName: UILabel!
    @IBOutlet weak var ptscaledMinName: UILabel!
    @IBOutlet weak var ltabvHSPName: UILabel!
    @IBOutlet weak var ptabvHSPName: UILabel!
    @IBOutlet weak var ltblwLSPName: UILabel!
    @IBOutlet weak var ptblwLSPName: UILabel!
    
    @IBOutlet weak var ltscaledMaxVal: UITextField!
    @IBOutlet weak var ptscaledMaxVal: UITextField!
    @IBOutlet weak var ltscaledMinVal: UITextField!
    @IBOutlet weak var ptscaledMinVal: UITextField!
    @IBOutlet weak var ltabvHSPVal: UITextField!
    @IBOutlet weak var ptabvHSPVal: UITextField!
    @IBOutlet weak var ltblwLSPVal: UITextField!
    @IBOutlet weak var ptblwLSPVal: UITextField!
    @IBOutlet weak var fillabvHTimerVal: UITextField!
    @IBOutlet weak var fillblwLTimerVal: UITextField!
    @IBOutlet weak var fillTimeoutTimerVal: UITextField!
    private var centralSystem = CentralSystem()
    var saltFillNumber = 0
    
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
//         NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        switch saltFillNumber {
            case 1: self.ltscaledMaxName.text = "LT1101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT1101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT1101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT1101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT1101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT1101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT1101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT1101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT1101 / LT1101 SETTINGS"
            case 2: self.ltscaledMaxName.text = "LT2101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT2101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT2101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT2101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT2101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT2101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT2101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT2101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT2101 / LT2101 SETTINGS"
            case 3: self.ltscaledMaxName.text = "LT3101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT3101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT3101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT3101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT3101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT3101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT3101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT3101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT3101 / LT3101 SETTINGS"
            case 4: self.ltscaledMaxName.text = "LT4101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT4101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT4101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT4101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT4101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT4101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT4101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT4101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT4101 / LT4101 SETTINGS"
            case 5: self.ltscaledMaxName.text = "LT5101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT5101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT5101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT5101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT5101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT5101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT5101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT5101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT5101 / LT5101 SETTINGS"
            case 6: self.ltscaledMaxName.text = "LT6101 SCALED VALUE MAX (cm)"
                    self.ltscaledMinName.text = "LT6101 SCALED VALUE MIN (cm)"
                    self.ptscaledMaxName.text = "PT6101 SCALED VALUE MAX (cm)"
                    self.ptscaledMinName.text = "PT6101 SCALED VALUE MIN (cm)"
                    self.ltabvHSPName.text = "LT6101 ABOVE HI SP (cm)"
                    self.ltblwLSPName.text = "LT6101 BELOW L SP (cm)"
                    self.ptabvHSPName.text = "PT6101 ABOVE HI SP (cm)"
                    self.ptblwLSPName.text = "PT6101 BELOW L SP (cm)"
                    self.navigationItem.title = "PT6101 / LT6101 SETTINGS"
        default:
            print("Wrong Tag: SaltFill")
        }
        readSaltFillStats()
    }
    
    
    @objc func checkSystemStat(){
        readSaltFillStats()
    }
    
    func readSaltFillStats (){
        let offset = (saltFillNumber - 1)*20
        switch saltFillNumber {
        case 1...6:
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1_SCALEDMAX + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ltscaledMaxVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1_SCALEDMIN + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ltscaledMinVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PT1_SCALEDMAX + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ptscaledMaxVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PT1_SCALEDMIN + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ptscaledMinVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1_ABVH + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ltabvHSPVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(LT1_BLWL + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ltblwLSPVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PT1_ABVH + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ptabvHSPVal.text =  String(format: "%.0f", value)
            })
            CENTRAL_SYSTEM?.readRealRegister(register: Int(PT1_BLWL + offset), length: 2, completion: { (success, response) in
                guard success == true else { return }
                let value = Float(response)!
                self.ptblwLSPVal.text =  String(format: "%.0f", value)
            })
        default:
            print("wrong Tag")
        }
        CENTRAL_SYSTEM!.readRegister(length: 3, startingRegister: Int32(SALT_FILLABVH_TIMER), completion:{ (success, response) in
            
            guard success == true else { return }
                
            let abvH = Int(truncating: response![0] as! NSNumber)
            let blwL = Int(truncating: response![1] as! NSNumber)
            let fillTimeout = Int(truncating: response![2] as! NSNumber)
            
            
            self.fillabvHTimerVal.text = "\(abvH)"
            self.fillblwLTimerVal.text = "\(blwL)"
            self.fillTimeoutTimerVal.text = "\(fillTimeout)"
        })
    }
    
    private func saveSetpointsToPLC(){
        
        let abvHTimer = Int(self.fillabvHTimerVal.text!)
        let blwLTimer = Int(self.fillblwLTimerVal.text!)
        let timeoutTimer = Int(self.fillTimeoutTimerVal.text!)
        
        //Checkpoints to make sure Setpoint Input Is Not Empty
        
        guard abvHTimer != nil && abvHTimer != nil && abvHTimer != nil else{
            return
        }
        
        CENTRAL_SYSTEM?.writeRegister(register: SALT_FILLABVH_TIMER, value: abvHTimer!)
        CENTRAL_SYSTEM?.writeRegister(register: SALT_FILLBLWL_TIMER, value: blwLTimer!)
        CENTRAL_SYSTEM?.writeRegister(register: SALT_FILLTIMEOUT_TIMER, value: timeoutTimer!)
        
        let ltscalMax = Float(self.ltscaledMaxVal.text!)
        let ltscalMin = Float(self.ltscaledMinVal.text!)
        let ptscalMax = Float(self.ptscaledMaxVal.text!)
        let ptscalMin = Float(self.ptscaledMinVal.text!)
        let ltabvH = Float(self.ltabvHSPVal.text!)
        let ltblwL = Float(self.ltblwLSPVal.text!)
        let ptabvH = Float(self.ptabvHSPVal.text!)
        let ptblwL = Float(self.ptblwLSPVal.text!)
        
        guard ltscalMax != nil && ltscalMin != nil && ptscalMax != nil && ptscalMin != nil && ltabvH != nil && ltblwL != nil && ptabvH != nil && ptblwL != nil else{
            return
        }
        
        let offset = (saltFillNumber - 1)*20
        
        CENTRAL_SYSTEM?.writeRealValue(register: LT1_SCALEDMAX + offset, value: ltscalMax!)
        CENTRAL_SYSTEM?.writeRealValue(register: PT1_SCALEDMAX + offset, value: ptscalMax!)
        CENTRAL_SYSTEM?.writeRealValue(register: LT1_SCALEDMIN + offset, value: ltscalMin!)
        CENTRAL_SYSTEM?.writeRealValue(register: PT1_SCALEDMIN + offset, value: ptscalMin!)
        CENTRAL_SYSTEM?.writeRealValue(register: LT1_ABVH + offset, value: ltabvH!)
        CENTRAL_SYSTEM?.writeRealValue(register: LT1_BLWL + offset, value: ltblwL!)
        CENTRAL_SYSTEM?.writeRealValue(register: PT1_ABVH + offset, value: ptabvH!)
        CENTRAL_SYSTEM?.writeRealValue(register: PT1_BLWL + offset, value: ptblwL!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.readSaltFillStats()
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
