//
//  FogViewController.swift
//  iPadControls
//
//  Created by Jan Manalo on 7/31/18.
//  Copyright © 2018 WET. All rights reserved.
//


import UIKit


class FogViewController: UIViewController{
    
    private let logger =  Logger()
    
    //No Connection View
    
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var ringAautoHandImg: UIImageView!
    @IBOutlet weak var ringLautoHandImg: UIImageView!
    @IBOutlet weak var ringBautoHandImg: UIImageView!
    @IBOutlet weak var plumeAautoHandImg: UIImageView!
    @IBOutlet weak var plumeLautoHandImg: UIImageView!
    @IBOutlet weak var plumeBautoHandImg: UIImageView!
    
    @IBOutlet weak var ringAPlayStopBtn: UIButton!
    @IBOutlet weak var ringLPlayStopBtn: UIButton!
    @IBOutlet weak var ringBPlayStopBtn: UIButton!
    @IBOutlet weak var plumeAPlayStopBtn: UIButton!
    @IBOutlet weak var plumeLPlayStopBtn: UIButton!
    @IBOutlet weak var plumeBPlayStopBtn: UIButton!

    private var centralSystem = CentralSystem()
    var fogRingAValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogRingLValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogRingBValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeAValues = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeLValues = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeBValues = FOG_MOTOR_SENSOR_VALUES()
    
    var fogSystemValues  = FOG_SYSTEM_SENSOR_VALUES()
    
    /***************************************************************************
     * Function :  viewDidLoad
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
    }

    
    /***************************************************************************
     * Function :  viewWillAppear
     * Input    :  none
     * Output   :  none
     * Comment  :  This function gets executed every time view appears
     ***************************************************************************/
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        //This line of code is an extension added to the view controller by showStoppers module
        //This is the only line needed to add show stopper
        
        
        
    }
    
    /***************************************************************************
     * Function :  viewWillDisappear
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    override func viewWillDisappear(_ animated: Bool){
        
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        
        NotificationCenter.default.removeObserver(self)
        self.logger.logData(data:"View Is Disappearing")
        
    }
    
    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :  Checks the network connection for all system components
     ***************************************************************************/
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            noConnectionView.isUserInteractionEnabled = false
            
            //Now that the connection is established, run functions
            getFogSystemADataFromPLC()
            getFogSystemBDataFromPLC()
            getFogSystemLDataFromPLC()
            getFogSystemData()
            
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
    
    /***************************************************************************
     * Function :  getFogDataFromPLC
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    func getFogSystemADataFromPLC(){
        //Fog System A
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1580_A.count) , startingRegister: Int32(FOGRING_YV1580_A.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.fogRingAValues.inAuto = statusArrValues[5]
            self.fogRingAValues.inHand = statusArrValues[6]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingAValues.cmd_HandMode = cmdArrValues[0]
            self.fogRingAValues.cmd_HandStartStop = cmdArrValues[1]
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1582_A.count) , startingRegister: Int32(FOGPLUME_YV1582_A.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                //print(statusArrValues)
                
                self.fogPlumeAValues.inAuto = statusArrValues[5]
                self.fogPlumeAValues.inHand = statusArrValues[6]
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeAValues.cmd_HandMode = cmdArrValues[0]
                self.fogPlumeAValues.cmd_HandStartStop = cmdArrValues[1]
                
                self.parseFogSystemAData()
            })
        })
    }
    
    func getFogSystemLDataFromPLC(){
        //Fog System L
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1583_L.count) , startingRegister: Int32(FOGRING_YV1583_L.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            
            self.fogRingLValues.inAuto = statusArrValues[5]
            self.fogRingLValues.inHand = statusArrValues[6]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingLValues.cmd_HandMode = cmdArrValues[0]
            self.fogRingLValues.cmd_HandStartStop = cmdArrValues[1]
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1585_L.count) , startingRegister: Int32(FOGPLUME_YV1585_L.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                //print(statusArrValues)
                self.fogPlumeLValues.inAuto = statusArrValues[5]
                self.fogPlumeLValues.inHand = statusArrValues[6]
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeLValues.cmd_HandMode = cmdArrValues[0]
                self.fogPlumeLValues.cmd_HandStartStop = cmdArrValues[1]
                
                self.parseFogSystemLData()
            })
        })
    }
        
        
    func getFogSystemBDataFromPLC(){
        //Fog System B
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGRING_YV1587_B.count) , startingRegister: Int32(FOGRING_YV1587_B.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.fogRingBValues.inAuto = statusArrValues[5]
            self.fogRingBValues.inHand = statusArrValues[6]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.fogRingBValues.cmd_HandMode = cmdArrValues[0]
            self.fogRingBValues.cmd_HandStartStop = cmdArrValues[1]
            
            
            CENTRAL_SYSTEM?.readRegister(length: Int32(FOGPLUME_YV1589_B.count) , startingRegister: Int32(FOGPLUME_YV1589_B.startAddr), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                //print(statusArrValues)
                self.fogPlumeBValues.inAuto = statusArrValues[5]
                self.fogPlumeBValues.inHand = statusArrValues[6]
                
                let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
                self.fogPlumeBValues.cmd_HandMode = cmdArrValues[0]
                self.fogPlumeBValues.cmd_HandStartStop = cmdArrValues[1]
                
                self.parseFogSystemBData()
            })
        })
    }
    
    func getFogSystemData(){
        CENTRAL_SYSTEM?.readRegister(length: Int32(FOGSYSTEM_DATA.count) , startingRegister: Int32(FOGSYSTEM_DATA.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![0] as! NSNumber))
            //print(statusArrValues)
            self.fogSystemValues.systemARunning = statusArrValues[0]
            self.fogSystemValues.systemAFaulted = statusArrValues[1]
            self.fogSystemValues.systemARingOpen = statusArrValues[2]
            self.fogSystemValues.systemAPlumeOpen = statusArrValues[3]
            self.fogSystemValues.systemLRunning = statusArrValues[4]
            self.fogSystemValues.systemLFaulted = statusArrValues[5]
            self.fogSystemValues.systemLRingOpen = statusArrValues[6]
            self.fogSystemValues.systemLPlumeOpen = statusArrValues[7]
            self.fogSystemValues.systemBRunning = statusArrValues[8]
            self.fogSystemValues.systemBFaulted = statusArrValues[9]
            self.fogSystemValues.systemBRingOpen = statusArrValues[10]
            self.fogSystemValues.systemBPlumeOpen = statusArrValues[11]
            self.parseFogSystemData()
        })
    }
    /***************************************************************************
     * Function :  parseFogSystemData
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func parseFogSystemAData(){
       if self.fogRingAValues.inAuto == 1{
            ringAautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            ringAautoHandImg.rotate360Degrees(animate: true)
            ringAPlayStopBtn.isHidden = true
        }
        if self.fogRingAValues.inHand == 1{
            ringAautoHandImg.image = #imageLiteral(resourceName: "handMode")
            ringAautoHandImg.rotate360Degrees(animate: false)
            ringAPlayStopBtn.isHidden = false
        }
        
        if self.fogRingAValues.cmd_HandStartStop == 1{
            ringAPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogRingAValues.cmd_HandStartStop == 0{
            ringAPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        
        if self.fogPlumeAValues.inAuto == 1{
            plumeAautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            plumeAautoHandImg.rotate360Degrees(animate: true)
            plumeAPlayStopBtn.isHidden = true
        }
        if self.fogPlumeAValues.inHand == 1{
            plumeAautoHandImg.image = #imageLiteral(resourceName: "handMode")
            plumeAautoHandImg.rotate360Degrees(animate: false)
            plumeAPlayStopBtn.isHidden = false
        }
        
        if self.fogPlumeAValues.cmd_HandStartStop == 1{
            plumeAPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogPlumeAValues.cmd_HandStartStop == 0{
            plumeAPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
                
    }
    func parseFogSystemLData(){
        if self.fogRingLValues.inAuto == 1{
            ringLautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            ringLautoHandImg.rotate360Degrees(animate: true)
            ringLPlayStopBtn.isHidden = true
        }
        if self.fogRingLValues.inHand == 1{
            ringLautoHandImg.image = #imageLiteral(resourceName: "handMode")
            ringLautoHandImg.rotate360Degrees(animate: false)
            ringLPlayStopBtn.isHidden = false
        }
        
        if self.fogRingLValues.cmd_HandStartStop == 1{
            ringLPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogRingLValues.cmd_HandStartStop == 0{
            ringLPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        
        if self.fogPlumeLValues.inAuto == 1{
            plumeLautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            plumeLautoHandImg.rotate360Degrees(animate: true)
            plumeLPlayStopBtn.isHidden = true
        }
        if self.fogPlumeLValues.inHand == 1{
            plumeLautoHandImg.image = #imageLiteral(resourceName: "handMode")
            plumeLautoHandImg.rotate360Degrees(animate: false)
            plumeLPlayStopBtn.isHidden = false
        }
        
        if self.fogPlumeLValues.cmd_HandStartStop == 1{
            plumeLPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogPlumeLValues.cmd_HandStartStop == 0{
            plumeLPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
                
    }
    func parseFogSystemBData(){
        if self.fogRingBValues.inAuto == 1{
            ringBautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            ringBautoHandImg.rotate360Degrees(animate: true)
            ringBPlayStopBtn.isHidden = true
        }
        if self.fogRingBValues.inHand == 1{
            ringBautoHandImg.image = #imageLiteral(resourceName: "handMode")
            ringBautoHandImg.rotate360Degrees(animate: false)
            ringBPlayStopBtn.isHidden = false
        }
        
        if self.fogRingBValues.cmd_HandStartStop == 1{
            ringBPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogRingBValues.cmd_HandStartStop == 0{
            ringBPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
        
        if self.fogPlumeBValues.inAuto == 1{
            plumeBautoHandImg.image = #imageLiteral(resourceName: "autoMode")
            plumeBautoHandImg.rotate360Degrees(animate: true)
            plumeBPlayStopBtn.isHidden = true
        }
        if self.fogPlumeBValues.inHand == 1{
            plumeBautoHandImg.image = #imageLiteral(resourceName: "handMode")
            plumeBautoHandImg.rotate360Degrees(animate: false)
            plumeBPlayStopBtn.isHidden = false
        }
        
        if self.fogPlumeBValues.cmd_HandStartStop == 1{
            plumeBPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
        }
        if self.fogPlumeBValues.cmd_HandStartStop == 0{
            plumeBPlayStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        }
                
    }
    func parseFogSystemData(){
        let ringAOpen   = self.view.viewWithTag(1) as? UILabel
        let plumeAOpen  = self.view.viewWithTag(2) as? UILabel
        let sysAFaulted = self.view.viewWithTag(3) as? UILabel
        let sysARunning = self.view.viewWithTag(4) as? UILabel
        
        if self.fogSystemValues.systemARingOpen == 1{
            ringAOpen!.alpha = 1
        } else {
            ringAOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemAPlumeOpen == 1{
            plumeAOpen!.alpha = 1
        } else {
            plumeAOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemAFaulted == 1{
            sysAFaulted!.alpha = 1
        } else {
            sysAFaulted!.alpha = 0
        }
        
        if self.fogSystemValues.systemARunning == 1{
            sysARunning!.alpha = 1
        } else {
            sysARunning!.alpha = 0
        }
        
        let ringLOpen   = self.view.viewWithTag(11) as? UILabel
        let plumeLOpen  = self.view.viewWithTag(12) as? UILabel
        let sysLFaulted = self.view.viewWithTag(13) as? UILabel
        let sysLRunning = self.view.viewWithTag(14) as? UILabel
        
        if self.fogSystemValues.systemLRingOpen == 1{
            ringLOpen!.alpha = 1
        } else {
            ringLOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemLPlumeOpen == 1{
            plumeLOpen!.alpha = 1
        } else {
            plumeLOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemLFaulted == 1{
            sysLFaulted!.alpha = 1
        } else {
            sysLFaulted!.alpha = 0
        }
        
        if self.fogSystemValues.systemLRunning == 1{
            sysLRunning!.alpha = 1
        } else {
            sysLRunning!.alpha = 0
        }
        
        let ringBOpen   = self.view.viewWithTag(21) as? UILabel
        let plumeBOpen  = self.view.viewWithTag(22) as? UILabel
        let sysBFaulted = self.view.viewWithTag(23) as? UILabel
        let sysBRunning = self.view.viewWithTag(24) as? UILabel
        
        if self.fogSystemValues.systemBRingOpen == 1{
            ringBOpen!.alpha = 1
        } else {
            ringBOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemBPlumeOpen == 1{
            plumeBOpen!.alpha = 1
        } else {
            plumeBOpen!.alpha = 0
        }
        
        if self.fogSystemValues.systemBFaulted == 1{
            sysBFaulted!.alpha = 1
        } else {
            sysBFaulted!.alpha = 0
        }
        
        if self.fogSystemValues.systemBRunning == 1{
            sysBRunning!.alpha = 1
        } else {
            sysBRunning!.alpha = 0
        }
                
    }
    /***************************************************************************
     * Function :  Fog Outlets
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @IBAction func redirectToFogDetails(_ sender: UIButton){
        let fogDetVC = UIStoryboard.init(name: "fog", bundle: nil).instantiateViewController(withIdentifier: "fogDetail") as! FogDetailsViewController
        if sender.tag == 5{
            fogDetVC.fogRingStartRegister = FOGRING_YV1580_A.startAddr
            fogDetVC.fogPlumeStartRegister = FOGPLUME_YV1582_A.startAddr
            fogDetVC.fogSysNumber = sender.tag
        }
        if sender.tag == 15{
            fogDetVC.fogRingStartRegister = FOGRING_YV1583_L.startAddr
            fogDetVC.fogPlumeStartRegister = FOGPLUME_YV1585_L.startAddr
            fogDetVC.fogSysNumber = sender.tag
        }
        if sender.tag == 25{
            fogDetVC.fogRingStartRegister = FOGRING_YV1587_B.startAddr
            fogDetVC.fogPlumeStartRegister = FOGPLUME_YV1589_B.startAddr
            fogDetVC.fogSysNumber = sender.tag
        }

        navigationController?.pushViewController(fogDetVC, animated: true)
    }
    @IBAction func sendAutoHandCmd(_ sender: UIButton){
        if sender.tag == 6{
            if fogRingAValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_HANDMODE, value: 1)
            }
            if fogRingAValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_HANDMODE, value: 0)
            }
        }
        if sender.tag == 16{
            if fogRingLValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_HANDMODE, value: 1)
            }
            if fogRingLValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_HANDMODE, value: 0)
            }
        }
        if sender.tag == 26{
            if fogRingBValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_HANDMODE, value: 1)
            }
            if fogRingBValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_HANDMODE, value: 0)
            }
        }
        if sender.tag == 8{
            if fogPlumeAValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_HANDMODE, value: 1)
            }
            if fogPlumeAValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_HANDMODE, value: 0)
            }
        }
        if sender.tag == 18{
            if fogPlumeLValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_HANDMODE, value: 1)
            }
            if fogPlumeLValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_HANDMODE, value: 0)
            }
        }
        if sender.tag == 28{
            if fogPlumeBValues.inAuto == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_HANDMODE, value: 1)
            }
            if fogPlumeBValues.inHand == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_HANDMODE, value: 0)
            }
        }
    }
    @IBAction func sendStartStopCmd(_ sender: UIButton){
       if sender.tag == 7{
            if fogRingAValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1580_A_CMD_HANDCMD, value: 1)
            }
       }
       if sender.tag == 17{
            if fogRingLValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1583_L_CMD_HANDCMD, value: 1)
            }
       }
       if sender.tag == 27{
            if fogRingBValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGRING_YV1587_B_CMD_HANDCMD, value: 1)
            }
       }
       if sender.tag == 9{
            if fogPlumeAValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1582_A_CMD_HANDCMD, value: 1)
            }
       }
       if sender.tag == 19{
            if fogPlumeLValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1585_L_CMD_HANDCMD, value: 1)
            }
       }
       if sender.tag == 29{
            if fogPlumeBValues.cmd_HandStartStop == 1{
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_HANDCMD, value: 0)
            } else {
                CENTRAL_SYSTEM?.writeBit(bit: FOGPLUME_YV1589_B_CMD_HANDCMD, value: 1)
            }
       }
        
    }
    
    @IBAction func showSettingsButton(_ sender: UIButton) {
         self.addAlertAction(button: sender)
    }
}
