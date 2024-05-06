//
//  BromineDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/4/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class BromineDetailViewController: UIViewController {

    @IBOutlet weak var handBtn: UIButton!
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var autoHandImg: UIImageView!
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var readOnce = 0
    var brValues  = BR_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        self.navigationItem.title = "BROMINE VALVE DETAILS"
        
        
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
            getBrValveDataFromPLC()
            
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
    
    func getBrValveDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(BR_VALVE_DATAREGISTER.count), startingRegister: Int32(BR_VALVE_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.brValues.brEnabled = statusArrValues[0]
            self.brValues.brDosing = statusArrValues[1]
            self.brValues.valveStatus = statusArrValues[2]
            self.brValues.brTimeout = statusArrValues[3]
            self.brValues.inAuto = statusArrValues[4]
            self.brValues.inHand = statusArrValues[5]
            self.brValues.startCmdActive = statusArrValues[6]
            self.brValues.stopCmdActive = statusArrValues[7]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.brValues.cmd_HandStar = cmdArrValues[1]
            self.brValues.cmd_HandStop = cmdArrValues[2]
            
            self.brValues.status_orpScaledVal = Int(truncating: response![4] as! NSNumber)
            
            if self.readOnce == 0{
               self.readOnce = 1
               if self.brValues.cmd_HandStar == 1{
                 self.handBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
               }
               if self.brValues.cmd_HandStop == 1{
                 self.handBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
               }
               self.parseDumpData()
            }
            
        })
    }
    
    func parseDumpData(){
        let enabled = self.view.viewWithTag(2001) as? UIImageView
        let dosing = self.view.viewWithTag(2002) as? UILabel
        let valveState = self.view.viewWithTag(2003) as? UILabel
        let inAuto = self.view.viewWithTag(2004) as? UIImageView
        let inHand = self.view.viewWithTag(2005) as? UIImageView
        let startCmdActive = self.view.viewWithTag(2006) as? UIImageView
        let stopCmdActive = self.view.viewWithTag(2007) as? UIImageView
        let brTimeout = self.view.viewWithTag(2008) as? UIImageView
        let orpScaledVal = self.view.viewWithTag(2009) as? UILabel
        
        brValues.brEnabled == 1 ? ( enabled?.image = #imageLiteral(resourceName: "green")) : (enabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
        brValues.startCmdActive == 1 ? ( startCmdActive?.image = #imageLiteral(resourceName: "green")) : (startCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        brValues.stopCmdActive == 1 ? ( stopCmdActive?.image = #imageLiteral(resourceName: "green")) : (stopCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
        brValues.inAuto == 1 ? ( inAuto?.image = #imageLiteral(resourceName: "green")) : (inAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
        brValues.inHand == 1 ? ( inHand?.image = #imageLiteral(resourceName: "green")) : (inHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
        brValues.brTimeout == 1 ? ( brTimeout?.image = #imageLiteral(resourceName: "red")) : (brTimeout?.image = #imageLiteral(resourceName: "green"))
        
        if brValues.inAuto == 1{
            autoHandImg.image = #imageLiteral(resourceName: "autoMode")
            autoHandImg.rotate360Degrees(animate: true)
            handBtn.isHidden = true
        }
        if brValues.inHand == 1{
            autoHandImg.image = #imageLiteral(resourceName: "handMode")
            autoHandImg.rotate360Degrees(animate: false)
            handBtn.isHidden = false
        }
        
        orpScaledVal?.text = String(format: "%d", self.brValues.status_orpScaledVal)
        
        if brValues.brDosing == 1{
            dosing?.text = "ON"
        } else {
            dosing?.text = "OFF"
        }
        
        if brValues.valveStatus == 1{
            valveState?.text = "OPEN"
        } else {
            valveState?.text = "CLOSE"
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
        if brValues.inAuto == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandMode, value: 1)
        }
        if brValues.inHand == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandMode, value: 0)
        }
        self.readOnce = 0
    }
    @IBAction func sendStartStopCmd(_ sender: UIButton) {
        if self.brValues.cmd_HandStar == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandStopCmd, value: 1)
        }
        if self.brValues.cmd_HandStop == 1{
            CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.setHandStartCmd, value: 1)
        }
        self.readOnce = 0
    }
    @IBAction func sendCmdWarningReset(_ sender: UIButton) {
         CENTRAL_SYSTEM?.writeBit(bit: BR_VALVE_CMD_REG.cmdWarningReset, value: 1)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
       self.addAlertAction(button: sender)
    }
}
