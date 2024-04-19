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
    
    @IBOutlet weak var handMode101Img: UIImageView!
    @IBOutlet weak var autoMode101IImg: UIImageView!
    @IBOutlet weak var autoHandBtn: UIButton!
    @IBOutlet weak var pumpFault: UILabel!
    @IBOutlet weak var motorOverload:        UILabel!
    @IBOutlet weak var pumpShutdown:            UILabel!
    @IBOutlet weak var fogOnOffLbl:          UILabel!
    @IBOutlet weak var playStopBtn:          UIButton!
    private var centralSystem = CentralSystem()
    var fogMotorLiveValues = FOG_MOTOR_LIVE_VALUES()
    
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
            checkAutoHandMode()
            getFogDataFromPLC()
            
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
     * Function :  checkAutoHandMode
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func checkAutoHandMode(){
        
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(FOG_AUTO_HAND_BIT_ADDR), completion: { (success, response) in
            
            if response != nil{
                
                let autoHandMode = Int(truncating: response![0] as! NSNumber)
                
                if autoHandMode == 1{
                    //If is in manual mode on the ipad
                    self.changeAutManModeIndicatorRotation(autoMode: false, tag: 1)
                    self.playStopBtn.alpha = 1
                }else{
                    //If is in auto mode on the ipad
                    self.playStopBtn.alpha = 0
                    self.changeAutManModeIndicatorRotation(autoMode: true, tag: 1)
                    self.readFogPlayStopData()
                }
            }
            
        })
    }
    
    
    /***************************************************************************
     * Function :  readFogPlayStopData
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func readFogPlayStopData(){
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(FOG_PLAY_STOP_BIT_ADDR), completion: { (success, response) in
            
            guard success == true else { return }
            
            let playStopValue = Int(truncating: response![0] as! NSNumber)
            
            if playStopValue == 1 {
                self.playStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
            } else {
                self.playStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            }
            
        })
        
    }
    
    
    /***************************************************************************
     * Function :  getFogDataFromPLC
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func getFogDataFromPLC(){
        
        CENTRAL_SYSTEM?.readBits(length: Int32(FOG_FAULTS.count), startingRegister: Int32(FOG_FAULTS.startAddr), completion: { (sucess, response) in
            
            if response != nil{
                
                
                self.fogMotorLiveValues.pumpRunning   = Int(truncating: response![0] as! NSNumber)
                self.fogMotorLiveValues.pumpShutdown  = Int(truncating: response![1] as! NSNumber)
                self.fogMotorLiveValues.pumpOverLoad  = Int(truncating: response![2] as! NSNumber)
                self.fogMotorLiveValues.pumpFault      = Int(truncating: response![3] as! NSNumber)
                self.fogMotorLiveValues.pumpMode      = Int(truncating: response![5] as! NSNumber)
            }
            
        })
         self.parseFogPumpData()
        
    }
    
    /***************************************************************************
     * Function :  parseFogPumpData
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func parseFogPumpData(){
        
            if fogMotorLiveValues.pumpOverLoad == 1{
                motorOverload.alpha = 1
            } else {
                motorOverload.alpha = 0
            }
            
            if fogMotorLiveValues.pumpFault == 1{
                pumpFault.alpha = 1
            } else {
                pumpFault.alpha = 0
            }
        
            if fogMotorLiveValues.pumpShutdown == 1{
                pumpShutdown.alpha = 1
            } else {
                pumpShutdown.alpha = 0
            }
            
            if fogMotorLiveValues.pumpRunning == 1{
                   
                   fogOnOffLbl.text = "FOG CURRENTLY ON"
                   fogOnOffLbl.textColor = GREEN_COLOR
                   playStopBtn.setBackgroundImage(#imageLiteral(resourceName: "stopButton"), for: .normal)
                  
                   
            } else if fogMotorLiveValues.pumpRunning == 0{
                   
                   fogOnOffLbl.text = "FOG CURRENTLY OFF"
                   fogOnOffLbl.textColor = DEFAULT_GRAY
                   playStopBtn.setBackgroundImage(#imageLiteral(resourceName: "playButton"), for: .normal)
            
            }
                
        }
    
    /***************************************************************************
     * Function :  changeAutManModeIndicatorRotation
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    func changeAutManModeIndicatorRotation(autoMode:Bool, tag:Int){
        
        /*
         NOTE: 2 Possible Options
         Option 1: Automode (animate) = True => Will result in any view object to rotate 360 degrees infinitly
         Option 2: Automode (animate) = False => Will result in any view object to stand still
         */
        autoMode101IImg.rotate360Degrees(animate: true)
        if autoMode == true {
            
            self.autoMode101IImg.alpha = 1
            self.handMode101Img.alpha = 0
            
        }else{
            
            self.handMode101Img.alpha = 1
            self.autoMode101IImg.alpha = 0
            
        }
        
    }
    
    /***************************************************************************
     * Function :  toggleAutoHandMode
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @IBAction func toggleAutoHandMode(_ sender: UIButton){
        
        //NOTE: The auto/hand mode value on PLC is opposite to autoModeValue
        //On PLC Auto Mode: 0 , Hand Mode: 1
        if self.fogMotorLiveValues.pumpMode == 1{
            //In manual mode, change to auto mode
            CENTRAL_SYSTEM?.writeBit(bit: FOG_AUTO_HAND_BIT_ADDR, value: 0)
            
        }else{
            //In auto mode, change it to manual mode
            CENTRAL_SYSTEM?.writeBit(bit: FOG_AUTO_HAND_BIT_ADDR, value: 1)
            
        }
        
        
    }
    

    
    
    /***************************************************************************
     * Function :  playStopFog
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @IBAction func playStopFog(_ sender: UIButton){
        
        if self.fogMotorLiveValues.pumpRunning == 1{
            
            CENTRAL_SYSTEM?.writeBit(bit: FOG_PLAY_STOP_BIT_ADDR, value: 0)
            
        }else{
            
            CENTRAL_SYSTEM?.writeBit(bit: FOG_PLAY_STOP_BIT_ADDR, value: 1)
            
        }
    }
    
    @IBAction func showSettingsButton(_ sender: UIButton) {
         self.addAlertAction(button: sender)
    }
}
