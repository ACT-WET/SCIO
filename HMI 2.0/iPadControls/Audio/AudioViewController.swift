//
//  AudioViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/22/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {
    
    @IBOutlet weak var sendCmdStatus: UILabel!
    @IBOutlet weak var sendCmd2Status: UILabel!
    @IBOutlet weak var sendCmd3Status: UILabel!
    @IBOutlet weak var sendCmd4Status: UILabel!
    @IBOutlet weak var sendCmd5Status: UILabel!
    
    let helper      = Helper()
    private let logger =  Logger()
    var langData    = Dictionary<String, String>()
    var httpManager = HTTPComm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool){
        
        
        //Get Current iPad Number That Was Previously Selected
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    
    @objc func checkSystemStat(){
     
    }
    
    override func viewWillDisappear(_ animated: Bool){
        NotificationCenter.default.removeObserver(self)
    }
    

    @IBAction func sendAudioCmds(_ sender: UIButton) {
        self.sendCmdStatus.text = "SENDING SEVERE WEATHER ANNOUNCEMENT TO MCRX"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.sendCmdStatus.text = "PROCESSING REQUEST"
        }
        httpManager.httpPost(url: "\(MCRX_HTTP_PASS)51") { (response) in
            let statuscode = Int(truncating:response as! NSNumber)
            if statuscode == 200{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.sendCmdStatus.text = "COMMAND RECEIVED"
                    self.sendCmdStatus.textColor =  GREEN_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmdStatus.textColor =  RED_COLOR
                        self.sendCmdStatus.text = ""
                    }
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.sendCmdStatus.text = "COMMAND NOT SENT"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmdStatus.textColor =  RED_COLOR
                        self.sendCmdStatus.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendAudio2Cmds(_ sender: UIButton) {
        self.sendCmd2Status.text = "SENDING MAINTENANCE ANNOUNCEMENT TO MCRX"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.sendCmd2Status.text = "PROCESSING REQUEST"
        }
        httpManager.httpPost(url: "\(MCRX_HTTP_PASS)52") { (response) in
            let statuscode = Int(truncating:response as! NSNumber)
            if statuscode == 200{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.sendCmd2Status.text = "COMMAND RECEIVED"
                    self.sendCmd2Status.textColor =  GREEN_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd2Status.textColor =  RED_COLOR
                        self.sendCmd2Status.text = ""
                    }
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.sendCmd2Status.text = "COMMAND NOT SENT"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd2Status.textColor =  RED_COLOR
                        self.sendCmd2Status.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendAudio3Cmds(_ sender: UIButton) {
        self.sendCmd3Status.text = "SENDING CONDUCT REMINDER ANNOUNCEMENT TO MCRX"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.sendCmd3Status.text = "PROCESSING REQUEST"
        }
        httpManager.httpPost(url: "\(MCRX_HTTP_PASS)53") { (response) in
            let statuscode = Int(truncating:response as! NSNumber)
            if statuscode == 200{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.sendCmd3Status.text = "COMMAND RECEIVED"
                    self.sendCmd3Status.textColor =  GREEN_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd3Status.textColor =  RED_COLOR
                        self.sendCmd3Status.text = ""
                    }
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.sendCmd3Status.text = "COMMAND NOT SENT"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd3Status.textColor =  RED_COLOR
                        self.sendCmd3Status.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendAudio4Cmds(_ sender: UIButton) {
        self.sendCmd4Status.text = "SENDING CONDUCT CLOSURE ANNOUNCEMENT TO MCRX"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.sendCmd4Status.text = "PROCESSING REQUEST"
        }
        httpManager.httpPost(url: "\(MCRX_HTTP_PASS)54") { (response) in
            let statuscode = Int(truncating:response as! NSNumber)
            if statuscode == 200{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.sendCmd4Status.text = "COMMAND RECEIVED"
                    self.sendCmd4Status.textColor =  GREEN_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd4Status.textColor =  RED_COLOR
                        self.sendCmd4Status.text = ""
                    }
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.sendCmd4Status.text = "COMMAND NOT SENT"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd4Status.textColor =  RED_COLOR
                        self.sendCmd4Status.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func sendAudio5Cmds(_ sender: UIButton) {
        self.sendCmd5Status.text = "SENDING CURRENTLY CLOSED ANNOUNCEMENT TO MCRX"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.sendCmd5Status.text = "PROCESSING REQUEST"
        }
        httpManager.httpPost(url: "\(MCRX_HTTP_PASS)55") { (response) in
            let statuscode = Int(truncating:response as! NSNumber)
            if statuscode == 200{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.sendCmd5Status.text = "COMMAND RECEIVED"
                    self.sendCmd5Status.textColor =  GREEN_COLOR
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd5Status.textColor =  RED_COLOR
                        self.sendCmd5Status.text = ""
                    }
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.sendCmd5Status.text = "COMMAND NOT SENT"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.sendCmd5Status.textColor =  RED_COLOR
                        self.sendCmd5Status.text = ""
                    }
                }
            }
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
