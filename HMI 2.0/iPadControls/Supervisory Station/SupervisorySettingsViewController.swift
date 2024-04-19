//
//  SupervisorySettingsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 10/12/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit
class SupervisorySettingsViewController: UIViewController {
    
    @IBOutlet weak var bc102DelayTimer: UITextField!
    @IBOutlet weak var bc101DelayTimer: UITextField!
    @IBOutlet weak var bc102Retry: UITextField!
    @IBOutlet weak var bc101Retry: UITextField!
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrLbl: UILabel!
    
    @IBOutlet weak var bc101Auto: UIButton!
    @IBOutlet weak var bc101Disable: UIButton!
    @IBOutlet weak var bc101frcIgnite: UIButton!
    
    @IBOutlet weak var bc102Auto: UIButton!
    @IBOutlet weak var bc102Disable: UIButton!
    @IBOutlet weak var bc102frcIgnite: UIButton!
    
    private var centralSystem = CentralSystem()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        self.navigationItem.title = "BURNER CONTROLLER SETTINGS"
        readSettings()
        constructSaveButton()
    }
    
    private func constructSaveButton(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveSetpoints))
        
    }
    
    @objc private func saveSetpoints(){
        guard let bc101DelayT = bc101DelayTimer.text,
            let bc101DelayVal = Int(bc101DelayT),
            let bc102DelayT = bc102DelayTimer.text,
            let bc102DelayVal = Int(bc102DelayT),
            let bc101RetryT = bc101Retry.text,
            let bc101RetryVal = Int(bc101RetryT),
            let bc102RetryT = bc102Retry.text,
            let bc102RetryVal = Int(bc102RetryT) else { return }
        
        CENTRAL_SYSTEM?.writeRegister(register: BC101_RESETDELAY, value: bc101DelayVal)
        CENTRAL_SYSTEM?.writeRegister(register: BC102_RESETDELAY, value: bc102DelayVal)
        CENTRAL_SYSTEM?.writeRegister(register: BC101_RETRY, value: bc101RetryVal)
        CENTRAL_SYSTEM?.writeRegister(register: BC102_RETRY, value: bc102RetryVal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.readSettings()
        }
    }
        
        
    @objc func checkSystemStat(){
        let (plcConnection,_) = CENTRAL_SYSTEM!.getConnectivityStat()
        
        if plcConnection == CONNECTION_STATE_CONNECTED{
            
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            //readSettings()
            noConnectionView.isUserInteractionEnabled = false
            
        }  else {
            noConnectionView.alpha = 1
            if plcConnection == CONNECTION_STATE_FAILED {
                noConnectionErrLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
            } else if plcConnection == CONNECTION_STATE_CONNECTING {
                noConnectionErrLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            }
        }
    }
    
    func readSettings(){
        CENTRAL_SYSTEM?.readRegister(length: 13, startingRegister: Int32(BC101_RESETDELAY), completion: { (success, response) in
            
            guard success == true else { return }
            let bc101delay = Int(truncating: response![0] as! NSNumber)
            let bc101retry = Int(truncating: response![1] as! NSNumber)
            let bc101CmdState = Int(truncating: response![2] as! NSNumber)
            
            let bc102delay = Int(truncating: response![10] as! NSNumber)
            let bc102retry = Int(truncating: response![11] as! NSNumber)
            let bc102CmdState = Int(truncating: response![12] as! NSNumber)
            
            
            self.bc101DelayTimer.text = "\(bc101delay)"
            self.bc102DelayTimer.text = "\(bc102delay)"
            self.bc101Retry.text = "\(bc101retry)"
            self.bc102Retry.text = "\(bc102retry)"
            
            if bc101CmdState == 0{
                self.bc101Auto.setTitleColor(GREEN_COLOR, for: .normal)
                self.bc101Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            } else if bc101CmdState == 1{
                self.bc101Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101Disable.setTitleColor(GREEN_COLOR, for: .normal)
                self.bc101frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            } else if bc101CmdState == 2{
                self.bc101Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101frcIgnite.setTitleColor(GREEN_COLOR, for: .normal)
            } else {
                self.bc101Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc101frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            }
            
            if bc102CmdState == 0{
                self.bc102Auto.setTitleColor(GREEN_COLOR, for: .normal)
                self.bc102Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            } else if bc102CmdState == 1{
                self.bc102Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102Disable.setTitleColor(GREEN_COLOR, for: .normal)
                self.bc102frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            } else if bc102CmdState == 2{
                self.bc102Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102frcIgnite.setTitleColor(GREEN_COLOR, for: .normal)
            } else {
                self.bc102Auto.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102Disable.setTitleColor(DEFAULT_GRAY, for: .normal)
                self.bc102frcIgnite.setTitleColor(DEFAULT_GRAY, for: .normal)
            }
        })
    }
    
    @IBAction func sendBC101Cmd(_ sender: UIButton) {
        if sender.tag == 11{
            CENTRAL_SYSTEM?.writeRegister(register: BC101_iPADCMD, value: 0)
        }
        if sender.tag == 12{
            CENTRAL_SYSTEM?.writeRegister(register: BC101_iPADCMD, value: 1)
        }
        if sender.tag == 13{
            CENTRAL_SYSTEM?.writeRegister(register: BC101_iPADCMD, value: 2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.readSettings()
        }
    }
    
    @IBAction func sendBC102Cmd(_ sender: UIButton) {
        if sender.tag == 21{
           CENTRAL_SYSTEM?.writeRegister(register: BC102_iPADCMD, value: 0)
        }
        if sender.tag == 22{
           CENTRAL_SYSTEM?.writeRegister(register: BC102_iPADCMD, value: 1)
        }
        if sender.tag == 23{
           CENTRAL_SYSTEM?.writeRegister(register: BC102_iPADCMD, value: 2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.readSettings()
        }
    }
    
}
