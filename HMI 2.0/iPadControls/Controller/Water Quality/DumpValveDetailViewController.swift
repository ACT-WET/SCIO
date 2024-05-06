//
//  DumpValveDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/4/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class DumpValveDetailViewController: UIViewController {

    @IBOutlet weak var handSwtch: UISwitch!
    @IBOutlet weak var handModeView: UIView!
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var autoHandImg: UIImageView!
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var readOnce = 0
    var dumpValValues  = FOG_MOTOR_SENSOR_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        self.navigationItem.title = "FREEZE DUMP VALVE DETAILS"
        
        
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
            getDumpValveDataFromPLC()
            
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getDumpValveDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(FREEZE_VALVE_DATAREGISTER.count), startingRegister: Int32(FREEZE_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.dumpValValues.valveEnabled = statusArrValues[0]
            self.dumpValValues.valveOpen = statusArrValues[1]
            self.dumpValValues.valveClose = statusArrValues[2]
            self.dumpValValues.valveTransition = statusArrValues[3]
            self.dumpValValues.faulted = statusArrValues[4]
            self.dumpValValues.inAuto = statusArrValues[5]
            self.dumpValValues.inHand = statusArrValues[6]
            self.dumpValValues.autoCmdActive = statusArrValues[7]
            self.dumpValValues.handCmdActive = statusArrValues[8]
            self.dumpValValues.failToOpen = statusArrValues[9]
            self.dumpValValues.failToClose = statusArrValues[10]
            self.dumpValValues.eStop = statusArrValues[11]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.dumpValValues.cmd_HandStartStop = cmdArrValues[1]
            
            if self.readOnce == 0{
               self.readOnce = 1
               if self.dumpValValues.cmd_HandStartStop == 1{
                   self.handSwtch.isOn = true
               } else {
                   self.handSwtch.isOn = false
               }
            }
            self.parseDumpData()
        })
    }
    
    func parseDumpData(){
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
         
        dumpValValues.valveEnabled == 1 ? ( enabled?.image = #imageLiteral(resourceName: "green")) : (enabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.valveOpen == 1 ? ( vlvopen?.image = #imageLiteral(resourceName: "green")) : (vlvopen?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.valveClose == 1 ? ( vlvclose?.image = #imageLiteral(resourceName: "green")) : (vlvclose?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.valveTransition == 1 ? ( vlvtrans?.image = #imageLiteral(resourceName: "green")) : (vlvtrans?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.inAuto == 1 ? ( inAuto?.image = #imageLiteral(resourceName: "green")) : (inAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.inHand == 1 ? ( inHand?.image = #imageLiteral(resourceName: "green")) : (inHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.faulted == 1 ? ( faulted?.image = #imageLiteral(resourceName: "red")) : (faulted?.image = #imageLiteral(resourceName: "green"))
        dumpValValues.autoCmdActive == 1 ? ( autoCmdActive?.image = #imageLiteral(resourceName: "green")) : (autoCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.handCmdActive == 1 ? ( handCmdActive?.image = #imageLiteral(resourceName: "green")) : (handCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        dumpValValues.failToOpen == 1 ? ( fToOpen?.image = #imageLiteral(resourceName: "red")) : (fToOpen?.image = #imageLiteral(resourceName: "green"))
        dumpValValues.failToClose == 1 ? ( fToClose?.image = #imageLiteral(resourceName: "red")) : (fToClose?.image = #imageLiteral(resourceName: "green"))
        dumpValValues.eStop == 1 ? ( eStop?.image = #imageLiteral(resourceName: "red")) : (eStop?.image = #imageLiteral(resourceName: "green"))
        
        if dumpValValues.inAuto == 1{
            autoHandImg.image = #imageLiteral(resourceName: "autoMode")
            autoHandImg.rotate360Degrees(animate: true)
            handModeView.isHidden = true
        }
        if dumpValValues.inHand == 1{
            autoHandImg.image = #imageLiteral(resourceName: "handMode")
            autoHandImg.rotate360Degrees(animate: false)
            handModeView.isHidden = false
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
    @IBAction func sendAutoHandCmd(_ sender: UIButton) {
        if dumpValValues.inAuto == 1{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandMode, value: 1)
        }
        if dumpValValues.inHand == 1{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandMode, value: 0)
        }
        
    }
    @IBAction func sendHandCmd(_ sender: UISwitch) {
        if self.dumpValValues.cmd_HandStartStop == 1{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandCmd, value: 0)
        }
        if self.dumpValValues.cmd_HandStartStop == 0{
            CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.setHandCmd, value: 1)
        }
    }
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
         CENTRAL_SYSTEM?.writeBit(bit: FREEZE_VALVE_CMD_REG.cmdFaultReset, value: 1)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
