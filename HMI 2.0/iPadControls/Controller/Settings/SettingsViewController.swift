//
//  SettingsViewController.swift
//  iPadControls
//
//  Created by Jan Manalo on 1/08/19.
//  Copyright © 2019 WET. All rights reserved.
//

import UIKit
import NMSSH

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var ipadDateLbl:          UILabel!
    @IBOutlet weak var syncTimeStateLbl:     UILabel!
    @IBOutlet weak var autobtn: UIButton!
    
    let helper      = Helper()
    private let logger =  Logger()
    var langData    = Dictionary<String, String>()
    var httpManager = HTTPComm()
    var centralsys  = CentralSystem()
    var plcValues  = CS_DATA_VALUES()
    var session: NMSSHSession!
    var cameraViewLoaded = false
    
    /***************************************************************************
     * Function :  viewDidLoad
     * Input    :  none
     * Output   :  none
     * Comment  :  This function gets executed only when controller resources
     *             get loaded
     ***************************************************************************/
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
    }
    
    /***************************************************************************
     * Function :  viewDidAppear
     * Input    :  none
     * Output   :  none
     * Comment  :  This function gets executed every time view appears
     ***************************************************************************/
    
    override func viewWillAppear(_ animated: Bool){
        
        
        //Get Current iPad Number That Was Previously Selected
        
        //Add notification observer to get system stat
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
    }
    
    
    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :  Checks the network connection for all system components
     ***************************************************************************/
    
    @objc func checkSystemStat(){
      getDateTime()
      getPLCValues()
    }
    
    func getPLCValues(){
       CENTRAL_SYSTEM?.readRegister(length:Int32(PLC_DATA.count) , startingRegister: Int32(PLC_DATA.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.plcValues.status_progRunning = statusArrValues[0]
            self.plcValues.status_coldStart = statusArrValues[1]
            self.plcValues.status_warmStart = statusArrValues[2]
            self.plcValues.status_IOError = statusArrValues[3]
            self.plcValues.status_cycleTimeWarning = statusArrValues[4]
            
            let cmdArrValues = self.convertIntToBitArr(a: Int(truncating: response![3] as! NSNumber))
            self.plcValues.cmd_WarningLatch = cmdArrValues[0]
            self.plcValues.cmd_WarningReset = cmdArrValues[1]
            
            self.plcValues.status_CurrentCycleTime = Int(truncating: response![4] as! NSNumber)
            self.plcValues.status_MaxCycleTime = Int(truncating: response![5] as! NSNumber)
            self.plcValues.status_ProgramUpTimeDays = Int(truncating: response![6] as! NSNumber)
            self.plcValues.status_ProgramUpTime = Int(truncating: response![7] as! NSNumber)
            self.plcValues.status_ProjectVersion = Int(truncating: response![8] as! NSNumber)
            self.plcValues.status_ProjectBuildNumber = Int(truncating: response![9] as! NSNumber)
            self.plcValues.status_ProjectLibraryVersion = Int(truncating: response![10] as! NSNumber)
            self.plcValues.status_ProjectBuildYear = Int(truncating: response![11] as! NSNumber)
            self.plcValues.status_ProjectBuildDay = Int(truncating: response![12] as! NSNumber)
            self.plcValues.status_ProjectBuildTime = Int(truncating: response![13] as! NSNumber)
            self.plcValues.cfg_cycleWarningTimeDelayTimer = Int(truncating: response![14] as! NSNumber)
        
            
            let plcTimeHr =  self.plcValues.status_ProgramUpTime / 100
            let plcTimeMin = self.plcValues.status_ProgramUpTime % 100
            let prjVersion =  self.plcValues.status_ProjectVersion / 100
            let prjVersion2 = self.plcValues.status_ProjectVersion % 100
            let prjBuildMon = self.plcValues.status_ProjectBuildDay / 100
            let prjBuildDay = self.plcValues.status_ProjectBuildDay % 100
            
            let projectVersionBuild = self.view.viewWithTag(20) as? UILabel
            projectVersionBuild?.text = String(format: "%d", prjVersion) + "." + String(format: "%02d", prjVersion2) + "." + String(format: "%d", self.plcValues.status_ProjectBuildNumber)
        
            let projectUpDaysTime = self.view.viewWithTag(21) as? UILabel
            projectUpDaysTime?.text = "DAYS: " + String(format: "%d", self.plcValues.status_ProgramUpTimeDays) + "  HR: " + String(format: "%02d", plcTimeHr) + "  MIN: " + String(format: "%02d", plcTimeMin)
        
            let projectBuildDate = self.view.viewWithTag(22) as? UILabel
            projectBuildDate?.text = String(format: "%02d", prjBuildMon) + "." + String(format: "%02d", prjBuildDay) + "." + String(format: "%d", self.plcValues.status_ProjectBuildYear)
            
            let progRun = self.view.viewWithTag(23) as? UILabel
            let progErr = self.view.viewWithTag(24) as? UILabel
            let progWar = self.view.viewWithTag(25) as? UILabel
        
            self.plcValues.status_progRunning == 1 ? (progRun?.isHidden = false) : (progRun?.isHidden = true)
            self.plcValues.status_IOError == 1 ? (progErr?.isHidden = false) : (progErr?.isHidden = true)
            self.plcValues.status_cycleTimeWarning == 1 ? (progWar?.isHidden = false) : (progWar?.isHidden = true)
        })
    }
    
    /***************************************************************************
     * Function :  viewWillDisappear
     * Input    :  none
     * Output   :  none
     * Comment  :  This function gets executed every time view disappears
     ***************************************************************************/
    
    override func viewWillDisappear(_ animated: Bool){
        NotificationCenter.default.removeObserver(self)
        langData.removeAll(keepingCapacity: false)
        
    }
    
    /***************************************************************************
     * Function :  chooseNumber1
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    /***************************************************************************
     * Function :  chooseNumber2
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/

    
    /***************************************************************************
     * Function :  highlighIpadNumber
     * Input    :  none
     * Output   :  none
     * Comment  :  Helper Function To Highlight The Selected iPad Button and
     *             Change the Selected Device Number In The Device non volatile
     *             memeory
     ***************************************************************************/
    
    private func highlighIpadNumber(button:UIButton, number:Int){
        
        button.layer.cornerRadius = 60
        button.layer.borderWidth  = 3.0
        button.layer.borderColor  = HELP_SCREEN_GRAY.cgColor
        
        //We want to save the highlighted iPad number to iPad's Defaults Storage
        UserDefaults.standard.set(number, forKey: IPAD_NUMBER_USER_DEFAULTS_NAME)
        
    }
    
    /***************************************************************************
     * Function :  dehilightIpadNumber
     * Input    :  targeted UI button
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func dehilightIpadNumber(button:UIButton){
        
        button.layer.borderWidth = 0.0
        
    }
    
    /***************************************************************************
     * Function :  configureScreenTextContent
     * Input    :  none
     * Output   :  none
     * Comment  :  Configure Screen Text Content Based On Device Language
     ***************************************************************************/
    /***************************************************************************
     * Function :  getCurrentIpadNumber
     * Input    :  none
     * Output   :  none
     * Comment  :  Get The Current iPad Number
     ***************************************************************************/
    
    /***************************************************************************
     * Function :  syncServerTimer
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @IBAction func syncServerTimer(_ sender: Any){
      syncTimeToServer()

        
        self.httpManager.httpGetResponseFromPath(url:RESET_TIME_LAST_COMMAND){ (response) in
            
            print("SUCCESSS : \(String(describing: response))")
            
        }
        centralsys.reinitialize()
    }
    
    func syncTimeToServer(){
    
     self.syncTimeStateLbl.text = "SYNCING SERVER TIME..."
           self.syncTimeStateLbl.textColor = DEFAULT_GRAY
           
           //On the background global thread, execute the sync time process
           DispatchQueue.global(qos: .background).async{
               
               self.session = NMSSHSession.connect(toHost: "\(SERVER_IP_ADDRESS):22", withUsername: "root")
            
               if self.session.isConnected{
                   
                   self.session.authenticate(byPassword: "A3139gg1121")
                   
                   if self.session.isAuthorized{
                       
                       
                       let currentDate          = NSDate()
                       let dateFormatter        = DateFormatter()
                       dateFormatter.dateFormat = "dd MMM YYYY HH:mm:ss"
                       let localDateTimeString  = dateFormatter.string(from: currentDate as Date)
                       
                       
                       self.session.channel.execute("date --set \"\(localDateTimeString)\"", error: nil)
                     //self.session.channel.execute("exit", error: nil)
                       self.self.session.disconnect()
                       
                       
                       //Check if SSH Session is established. If it is, disconnect.
                       
                       if self.session.isConnected{
                           self.session.disconnect()
                       }
                       
                       DispatchQueue.main.async{
                           
                           self.syncTimeStateLbl.text = "SERVER TIME SYNCED"
                           self.syncTimeStateLbl.textColor = GREEN_COLOR
                           
                       }
                   }
               }
           }
       }
    
    /***************************************************************************
     * Function :  setTimeSyncFailure
     * Input    :  none
     * Output   :  none
     * Comment  :  Shows time sync failure indicator and stops the timer
     *
     *
     *
     ***************************************************************************/
    
    private func setTimeSyncFailure(){
        syncTimeStateLbl.isHidden = false
        syncTimeStateLbl.text = "SERVER TIME SYNCHED FAILED"
        syncTimeStateLbl.textColor = RED_COLOR
        
    }
    
    
    /***************************************************************************
     * Function :  getDateTime
     * Input    :  none
     * Output   :  none
     * Comment  :  Gets the system date and time and formats it to our desired
     *             timestamp
     ***************************************************************************/
    
    @objc func getDateTime(){
        
        ipadDateLbl.text = SERVER_TIME
        
    }
    
    @IBAction func setAllAutoBtnPushed(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: SET_ALL_AUTO_REGISTER, value: 1)
        self.autobtn.isUserInteractionEnabled = false
        self.autobtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
            self.autobtn.isUserInteractionEnabled = true
            self.autobtn.isEnabled = true
        })
    }
}

