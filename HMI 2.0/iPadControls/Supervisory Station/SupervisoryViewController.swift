//
//  FireSpireViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/20/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SupervisoryViewController: UIViewController {
    private var centralSystem = CentralSystem()
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrLbl: UILabel!
    @IBOutlet weak var fireSchBtn: UIButton!
    
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
        self.navigationItem.title = "BURNER CONTROLLER"
            readSupervisoryStats()
    }
        
        
        @objc func checkSystemStat(){
            let (plcConnection,_) = CENTRAL_SYSTEM!.getConnectivityStat()
            
            if plcConnection == CONNECTION_STATE_CONNECTED{
                
                //Change the connection stat indicator
                noConnectionView.alpha = 0
                readSupervisoryStats()
                getSchdeulerStatus()
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
    
    func readSupervisoryStats(){
        
        CENTRAL_SYSTEM?.readRegister(length: 11, startingRegister: Int32(BC101_iPADCMD), completion:{ (success, response) in
                    
            guard success == true else { return }
            let bc101state = Int(truncating: response![0] as! NSNumber)
            let bc102state = Int(truncating: response![10] as! NSNumber)
           
            let bc101 = self.view.viewWithTag(4) as? UILabel
            let bc102 = self.view.viewWithTag(8) as? UILabel
               
            if bc101state == 0{
                bc101?.text = "AUTO"
            } else if bc101state == 1{
                bc101?.text = "DISABLE"
            } else if bc101state == 2{
                bc101?.text = "FORCE IGNITION"
            }
            
            if bc102state == 0{
                bc102?.text = "AUTO"
            } else if bc102state == 1{
                bc102?.text = "DISABLE"
            } else if bc102state == 2{
                bc102?.text = "FORCE IGNITION"
            }
        })
        CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(BC101_STATUS), completion:{ (success, response) in
                   
              guard success == true else { return }
              let state = Int(truncating: response![0] as! NSNumber)
              let base_2_binary = String(state, radix: 2)
              let Bit_16:String = self.pad(string: base_2_binary, toSize: 16)
              let arr = Bit_16.map { String($0) }
        
              let callFIgn = self.view.viewWithTag(1) as? UIImageView
              let burnerFault = self.view.viewWithTag(2) as? UIImageView
              let flameStatus = self.view.viewWithTag(3) as? UIImageView
               
              arr[15] == "1" ? ( callFIgn?.image = #imageLiteral(resourceName: "green")) : (callFIgn?.image = #imageLiteral(resourceName: "background"))
              arr[14] == "1" ? ( burnerFault?.image = #imageLiteral(resourceName: "red")) : (burnerFault?.image = #imageLiteral(resourceName: "background"))
              arr[13] == "1" ? ( flameStatus?.image = #imageLiteral(resourceName: "green")) : (flameStatus?.image = #imageLiteral(resourceName: "background"))
       })
       CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(BC102_STATUS), completion:{ (success, response) in
                   
              guard success == true else { return }
              let state = Int(truncating: response![0] as! NSNumber)
              let base_2_binary = String(state, radix: 2)
              let Bit_16:String = self.pad(string: base_2_binary, toSize: 16)
              let arr = Bit_16.map { String($0) }
        
              let callFIgn = self.view.viewWithTag(5) as? UIImageView
              let burnerFault = self.view.viewWithTag(6) as? UIImageView
              let flameStatus = self.view.viewWithTag(7) as? UIImageView
        
               
              arr[15] == "1" ? ( callFIgn?.image = #imageLiteral(resourceName: "green")) : (callFIgn?.image = #imageLiteral(resourceName: "background"))
              arr[14] == "1" ? ( burnerFault?.image = #imageLiteral(resourceName: "red")) : (burnerFault?.image = #imageLiteral(resourceName: "background"))
              arr[13] == "1" ? ( flameStatus?.image = #imageLiteral(resourceName: "green")) : (flameStatus?.image = #imageLiteral(resourceName: "background"))
       })
       
       CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(FIRE_ALARM), completion:{ (success, response) in
                   
              guard success == true else { return }
              let state = Int(truncating: response![0] as! NSNumber)
              let base_2_binary = String(state, radix: 2)
              let Bit_16:String = self.pad(string: base_2_binary, toSize: 16)
              let arr = Bit_16.map { String($0) }
        
              let estop = self.view.viewWithTag(4002) as? UIImageView
              let bc101retry = self.view.viewWithTag(4003) as? UIImageView
              let bc102retry = self.view.viewWithTag(4004) as? UIImageView
              let wwNR = self.view.viewWithTag(4005) as? UIImageView
              let bcTimeout = self.view.viewWithTag(4006) as? UIImageView
              
               
              arr[15] == "1" ? ( estop?.image = #imageLiteral(resourceName: "red")) : (estop?.image = #imageLiteral(resourceName: "background"))
              arr[14] == "1" ? ( bc101retry?.image = #imageLiteral(resourceName: "red")) : (bc101retry?.image = #imageLiteral(resourceName: "background"))
              arr[13] == "1" ? ( bc102retry?.image = #imageLiteral(resourceName: "red")) : (bc102retry?.image = #imageLiteral(resourceName: "background"))
              arr[12] == "1" ? ( wwNR?.image = #imageLiteral(resourceName: "red")) : (wwNR?.image = #imageLiteral(resourceName: "background"))
              arr[11] == "1" ? ( bcTimeout?.image = #imageLiteral(resourceName: "red")) : (bcTimeout?.image = #imageLiteral(resourceName: "background"))
       })
       
       CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(FIRE_ALARM), completion: { (success, response) in
           
           guard success == true else { return }
           
           let status = Int(truncating: response![0] as! NSNumber)
           let fireAlarm = self.view.viewWithTag(4001) as? UIImageView
        
           status == 1 ? ( fireAlarm?.image = #imageLiteral(resourceName: "red")) : (fireAlarm?.image = #imageLiteral(resourceName: "background"))
       })
    }
    
    func pad(string : String, toSize: Int) -> String {
      var padded = string
      for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
      }
        return padded
    }
    
    func getSchdeulerStatus(){
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(FIRE_PUMP_SCH_BIT), completion: { (success, response) in
                           
           guard success == true else { return }
           
           let filterSchOn = Int(truncating: response![0] as! NSNumber)
             
           if filterSchOn == 1{
               self.fireSchBtn.setTitleColor(GREEN_COLOR, for: .normal)
           } else {
               self.fireSchBtn.setTitleColor(DEFAULT_GRAY, for: .normal)
           }
        })
    }

    @IBAction func showAlertSettings(_ sender: UIButton) {
        self.addAlertAction(button: sender)
    }
    
    @IBAction func redirectToFireScheduler(_ sender: UIButton) {
        let schedulerShowVC = UIStoryboard.init(name: "pumps", bundle: nil).instantiateViewController(withIdentifier: "pumpSchedulerViewController") as! PumpSchedulerViewController
        schedulerShowVC.schedulerTag = sender.tag
        screen_Name = "pumps"
        navigationController?.pushViewController(schedulerShowVC, animated: true)
    }
}
