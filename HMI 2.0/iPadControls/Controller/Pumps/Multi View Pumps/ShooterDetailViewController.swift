//
//  ShooterDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/30/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class ShooterDetailViewController: UIViewController {
    
    
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var shooterLbl: UILabel!
    @IBOutlet weak var shooterautoHandImg: UIImageView!
    @IBOutlet weak var shooterPlayStopBtn: UIButton!
    var shooterNum = 0
    var shooterStartingRegister = 0
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var shooterValues  = FOG_MOTOR_SENSOR_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        if shooterNum == 121{
            self.shooterLbl.text = "YV-1001"
            shooterStartingRegister = YV1001_SHOOTER.startAddr
            self.navigationItem.title = "YV - 1001"
        }
        if shooterNum == 122{
            self.shooterLbl.text = "YV-1002"
            shooterStartingRegister = YV1002_SHOOTER.startAddr
            self.navigationItem.title = "YV - 1002"
        }
        if shooterNum == 123{
            self.shooterLbl.text = "YV-1003"
            shooterStartingRegister = YV1003_SHOOTER.startAddr
            self.navigationItem.title = "YV - 1003"
        }
        
        //This line of code is an extension added to the view controller by showStoppers module
        //This is the only line needed to add show stopper
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
    
    func getShooterDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length: 4 , startingRegister: Int32(self.shooterStartingRegister), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.shooterValues.valveEnabled = statusArrValues[0]
            self.shooterValues.valveOpen = statusArrValues[1]
            self.shooterValues.valveClose = statusArrValues[2]
            self.shooterValues.valveTransition = statusArrValues[3]
            self.shooterValues.faulted = statusArrValues[4]
            self.shooterValues.inAuto = statusArrValues[5]
            self.shooterValues.inHand = statusArrValues[6]
            self.shooterValues.autoCmdActive = statusArrValues[7]
            self.shooterValues.handCmdActive = statusArrValues[8]
            self.shooterValues.failToOpen = statusArrValues[9]
            self.shooterValues.failToClose = statusArrValues[10]
            self.shooterValues.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.shooterValues.cmd_HandMode = cmdArrValues[0]
            self.shooterValues.cmd_HandStartStop = cmdArrValues[1]
            
            self.parseShooterSystemData()
        })
    }
    
    func parseShooterSystemData(){
        
        if self.shooterValues.inAuto == 1{
            shooterautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            shooterautoHandImg.rotate360Degrees(animate: true)
            shooterPlayStopBtn.isHidden = true
        }
        if self.shooterValues.inHand == 1{
            shooterautoHandImg.image = #imageLiteral(resourceName: "handMode")
            shooterautoHandImg.rotate360Degrees(animate: false)
            shooterPlayStopBtn.isHidden = false
        }
        
        if self.shooterValues.cmd_HandStartStop == 1{
            shooterPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.shooterValues.cmd_HandStartStop == 0{
            shooterPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        
        
        let enabled = self.view.viewWithTag(2001) as? UIImageView
        let vlvopen = self.view.viewWithTag(2002) as? UIImageView
        let vlvclose = self.view.viewWithTag(2003) as? UIImageView
        let vlvtrans = self.view.viewWithTag(2004) as? UIImageView
        let inAuto = self.view.viewWithTag(2005) as? UIImageView
        let inHand = self.view.viewWithTag(2006) as? UIImageView
        let autoCmdActive = self.view.viewWithTag(2007) as? UIImageView
        let handCmdActive = self.view.viewWithTag(2008) as? UIImageView
        let faulted = self.view.viewWithTag(2009) as? UIImageView
        let fToOpen = self.view.viewWithTag(2010) as? UIImageView
        let fToClose = self.view.viewWithTag(2011) as? UIImageView
        let eStop = self.view.viewWithTag(2012) as? UIImageView
         
        shooterValues.valveEnabled == 1 ? ( enabled?.image = #imageLiteral(resourceName: "green")) : (enabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.valveOpen == 1 ? ( vlvopen?.image = #imageLiteral(resourceName: "green")) : (vlvopen?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.valveClose == 1 ? ( vlvclose?.image = #imageLiteral(resourceName: "green")) : (vlvclose?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.valveTransition == 1 ? ( vlvtrans?.image = #imageLiteral(resourceName: "green")) : (vlvtrans?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.inAuto == 1 ? ( inAuto?.image = #imageLiteral(resourceName: "green")) : (inAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.inHand == 1 ? ( inHand?.image = #imageLiteral(resourceName: "green")) : (inHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.faulted == 1 ? ( faulted?.image = #imageLiteral(resourceName: "red")) : (faulted?.image = #imageLiteral(resourceName: "green"))
        shooterValues.autoCmdActive == 1 ? ( autoCmdActive?.image = #imageLiteral(resourceName: "green")) : (autoCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.handCmdActive == 1 ? ( handCmdActive?.image = #imageLiteral(resourceName: "green")) : (handCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        shooterValues.failToOpen == 1 ? ( fToOpen?.image = #imageLiteral(resourceName: "red")) : (fToOpen?.image = #imageLiteral(resourceName: "green"))
        shooterValues.failToClose == 1 ? ( fToClose?.image = #imageLiteral(resourceName: "red")) : (fToClose?.image = #imageLiteral(resourceName: "green"))
        shooterValues.eStop == 1 ? ( eStop?.image = #imageLiteral(resourceName: "red")) : (eStop?.image = #imageLiteral(resourceName: "green"))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendAutoHandCmd(_ sender: UIButton){
        if shooterNum == 121{
            if shooterValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDMODE, value: 1)
            }
            if shooterValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDMODE, value: 0)
            }
        }
        if shooterNum == 122{
            if shooterValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDMODE, value: 1)
            }
            if shooterValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDMODE, value: 0)
            }
        }
        if shooterNum == 123{
            if shooterValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDMODE, value: 1)
            }
            if shooterValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDMODE, value: 0)
            }
        }
    }
    @IBAction func sendStartStopCmd(_ sender: UIButton){
       if shooterNum == 121{
            if shooterValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_HANDCMD, value: 1)
            }
       }
       if shooterNum == 122{
            if shooterValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_HANDCMD, value: 1)
            }
       }
       if shooterNum == 123{
            if shooterValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_HANDCMD, value: 1)
            }
       }
    }
    
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
        if shooterNum == 121{
           CENTRAL_SYSTEM?.writeBit(bit: YV1001_SHOOTER_CMD_FAULTRESET, value: 1)
        }
        if shooterNum == 122{
           CENTRAL_SYSTEM?.writeBit(bit: YV1002_SHOOTER_CMD_FAULTRESET, value: 1)
        }
        if shooterNum == 123{
           CENTRAL_SYSTEM?.writeBit(bit: YV1003_SHOOTER_CMD_FAULTRESET, value: 1)
        }
    }

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
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
