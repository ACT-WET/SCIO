//
//  DCPowerDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/30/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class DCPowerDetailViewController: UIViewController {
    
    @IBOutlet weak var scaledVal: UILabel!
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var dcPwrautoHandImg: UIImageView!
    @IBOutlet weak var dcPwrLbl: UILabel!
    @IBOutlet weak var dcPwrPlayStopBtn: UIButton!
    var dcNum = 0
    var dcStartingRegister = 0
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var dcValues  = DC_POWER_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        if dcNum == 151{
            self.dcPwrLbl.text = "DCP-101"
            dcStartingRegister = DCP101_POWER.startAddr
            self.navigationItem.title = "DCP - 101"
        }
        if dcNum == 152{
            self.dcPwrLbl.text = "DCP-102"
            dcStartingRegister = DCP102_POWER.startAddr
            self.navigationItem.title = "DCP - 102"
        }
        if dcNum == 153{
            self.dcPwrLbl.text = "DCP-103"
            dcStartingRegister = DCP103_POWER.startAddr
            self.navigationItem.title = "DCP - 103"
        }
        if dcNum == 154{
            self.dcPwrLbl.text = "DCP-104"
            dcStartingRegister = DCP104_POWER.startAddr
            self.navigationItem.title = "DCP - 104"
        }
        if dcNum == 155{
            self.dcPwrLbl.text = "DCP-105"
            dcStartingRegister = DCP105_POWER.startAddr
            self.navigationItem.title = "DCP - 105"
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
        CENTRAL_SYSTEM?.readRegister(length: 7 , startingRegister: Int32(self.dcStartingRegister), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dcValues.pwrEnabled = statusArrValues[0]
            self.dcValues.pwrOn = statusArrValues[1]
            self.dcValues.coolingFanOn = statusArrValues[2]
            self.dcValues.faulted = statusArrValues[3]
            self.dcValues.inAuto = statusArrValues[4]
            self.dcValues.inHand = statusArrValues[5]
            self.dcValues.warningHighTemp = statusArrValues[6]
            self.dcValues.hihighTemp = statusArrValues[7]
            self.dcValues.sensorFault = statusArrValues[8]
            self.dcValues.scalingFault = statusArrValues[9]
            self.dcValues.outOfRange = statusArrValues[10]
            self.dcValues.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dcValues.cmd_HandMode = cmdArrValues[0]
            self.dcValues.cmd_HandStartStop = cmdArrValues[1]
            
            self.dcValues.scaledValue = Int(truncating: response![4] as! NSNumber)
            self.dcValues.precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseDCSystemData()
        })
    }
    
    func parseDCSystemData(){
        
        if self.dcValues.inAuto == 1{
            dcPwrautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            dcPwrautoHandImg.rotate360Degrees(animate: true)
            dcPwrPlayStopBtn.isHidden = true
        }
        if self.dcValues.inHand == 1{
            dcPwrautoHandImg.image = #imageLiteral(resourceName: "handMode")
            dcPwrautoHandImg.rotate360Degrees(animate: false)
            dcPwrPlayStopBtn.isHidden = false
        }
        
        if self.dcValues.cmd_HandStartStop == 1{
            dcPwrPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.dcValues.cmd_HandStartStop == 0{
            dcPwrPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        
        
        let enabled = self.view.viewWithTag(2001) as? UIImageView
        let pwrOn = self.view.viewWithTag(2002) as? UIImageView
        let fanOn = self.view.viewWithTag(2003) as? UIImageView
        let inAuto = self.view.viewWithTag(2004) as? UIImageView
        let inHand = self.view.viewWithTag(2005) as? UIImageView
        let warning = self.view.viewWithTag(2006) as? UIImageView
        let highTemp = self.view.viewWithTag(2007) as? UIImageView
        let sensorFault = self.view.viewWithTag(2008) as? UIImageView
        let faulted = self.view.viewWithTag(2009) as? UIImageView
        let scaling = self.view.viewWithTag(2010) as? UIImageView
        let outOfRange = self.view.viewWithTag(2011) as? UIImageView
        let eStop = self.view.viewWithTag(2012) as? UIImageView
         
        dcValues.eStop == 1 ? ( eStop?.image = #imageLiteral(resourceName: "red")) : (eStop?.image = #imageLiteral(resourceName: "green"))
        dcValues.inAuto == 1 ? ( inAuto?.image = #imageLiteral(resourceName: "green")) : (inAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dcValues.inHand == 1 ? ( inHand?.image = #imageLiteral(resourceName: "green")) : (inHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dcValues.faulted == 1 ? ( faulted?.image = #imageLiteral(resourceName: "red")) : (faulted?.image = #imageLiteral(resourceName: "green"))
        dcValues.pwrOn == 1 ? ( pwrOn?.image = #imageLiteral(resourceName: "green")) : (pwrOn?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dcValues.coolingFanOn == 1 ? ( fanOn?.image = #imageLiteral(resourceName: "green")) : (fanOn?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dcValues.warningHighTemp == 1 ? ( warning?.image = #imageLiteral(resourceName: "yellow")) : (warning?.image = #imageLiteral(resourceName: "green"))
        dcValues.hihighTemp == 1 ? ( highTemp?.image = #imageLiteral(resourceName: "red")) : (highTemp?.image = #imageLiteral(resourceName: "green"))
        dcValues.sensorFault == 1 ? ( sensorFault?.image = #imageLiteral(resourceName: "red")) : (sensorFault?.image = #imageLiteral(resourceName: "green"))
        dcValues.scalingFault == 1 ? ( scaling?.image = #imageLiteral(resourceName: "red")) : (scaling?.image = #imageLiteral(resourceName: "green"))
        dcValues.outOfRange == 1 ? ( outOfRange?.image = #imageLiteral(resourceName: "red")) : (outOfRange?.image = #imageLiteral(resourceName: "green"))
        dcValues.pwrEnabled == 1 ? ( enabled?.image = #imageLiteral(resourceName: "green")) : (enabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
        
        let divisor = pow(10,dcValues.precision)
        let scaledValue = Float(dcValues.scaledValue) / Float(truncating: divisor as NSNumber)
        self.scaledVal.text = String(format: "%.2f", scaledValue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendAutoHandCmd(_ sender: UIButton){
        if dcNum == 151{
            if dcValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDMODE, value: 1)
            }
            if dcValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDMODE, value: 0)
            }
        }
        if dcNum == 152{
            if dcValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDMODE, value: 1)
            }
            if dcValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDMODE, value: 0)
            }
        }
        if dcNum == 153{
            if dcValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDMODE, value: 1)
            }
            if dcValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDMODE, value: 0)
            }
        }
        if dcNum == 154{
            if dcValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDMODE, value: 1)
            }
            if dcValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDMODE, value: 0)
            }
        }
        if dcNum == 155{
            if dcValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDMODE, value: 1)
            }
            if dcValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDMODE, value: 0)
            }
        }
    }
    @IBAction func sendStartStopCmd(_ sender: UIButton){
       if dcNum == 151{
            if dcValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_HANDCMD, value: 1)
            }
       }
       if dcNum == 152{
            if dcValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_HANDCMD, value: 1)
            }
       }
       if dcNum == 153{
            if dcValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_HANDCMD, value: 1)
            }
       }
       if dcNum == 154{
            if dcValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_HANDCMD, value: 1)
            }
       }
       if dcNum == 155{
            if dcValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_HANDCMD, value: 1)
            }
       }
    }
    
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
        if dcNum == 151{
           CENTRAL_SYSTEM?.writeBit(bit: DCP101_POWER_CMD_FAULTRESET, value: 1)
        }
        if dcNum == 152{
           CENTRAL_SYSTEM?.writeBit(bit: DCP102_POWER_CMD_FAULTRESET, value: 1)
        }
        if dcNum == 153{
           CENTRAL_SYSTEM?.writeBit(bit: DCP103_POWER_CMD_FAULTRESET, value: 1)
        }
        if dcNum == 154{
           CENTRAL_SYSTEM?.writeBit(bit: DCP104_POWER_CMD_FAULTRESET, value: 1)
        }
        if dcNum == 155{
           CENTRAL_SYSTEM?.writeBit(bit: DCP105_POWER_CMD_FAULTRESET, value: 1)
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
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }

}
