//
//  FogDetailsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/29/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class FogDetailsViewController: UIViewController {
    
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var ringLbl: UILabel!
    @IBOutlet weak var plumeLbl: UILabel!
    
    var fogSysNumber = 0
    var fogRingStartRegister = 0
    var fogPlumeStartRegister = 0
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var fogRingValues  = FOG_MOTOR_SENSOR_VALUES()
    var fogPlumeValues = FOG_MOTOR_SENSOR_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
        if fogSysNumber == 5{
            self.ringLbl.text = "YV-1580"
            self.plumeLbl.text = "YV-1582"
            self.navigationItem.title = "FOG SYSTEM A DETAILS"
        }
        if fogSysNumber == 15{
            self.ringLbl.text = "YV-1583"
            self.plumeLbl.text = "YV-1585"
            self.navigationItem.title = "FOG SYSTEM L DETAILS"
        }
        if fogSysNumber == 25{
            self.ringLbl.text = "YV-1587"
            self.plumeLbl.text = "YV-1589"
            self.navigationItem.title = "FOG SYSTEM B DETAILS"
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
            getFogSystemDataFromPLC()
            
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
    
    func getFogSystemDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length: 3 , startingRegister: Int32(self.fogRingStartRegister), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.fogRingValues.valveEnabled = statusArrValues[0]
            self.fogRingValues.valveOpen = statusArrValues[1]
            self.fogRingValues.valveClose = statusArrValues[2]
            self.fogRingValues.valveTransition = statusArrValues[3]
            self.fogRingValues.faulted = statusArrValues[4]
            self.fogRingValues.inAuto = statusArrValues[5]
            self.fogRingValues.inHand = statusArrValues[6]
            self.fogRingValues.autoCmdActive = statusArrValues[7]
            self.fogRingValues.handCmdActive = statusArrValues[8]
            self.fogRingValues.failToOpen = statusArrValues[9]
            self.fogRingValues.failToClose = statusArrValues[10]
            self.fogRingValues.eStop = statusArrValues[11]
            
            CENTRAL_SYSTEM?.readRegister(length: 3 , startingRegister: Int32(self.fogPlumeStartRegister), completion: { (sucess, response) in
                
                //Check points to make sure the PLC Call was successful
                
                guard sucess == true else{
                    self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                    return
                }
                let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
                //print(statusArrValues)
                self.fogPlumeValues.valveEnabled = statusArrValues[0]
                self.fogPlumeValues.valveOpen = statusArrValues[1]
                self.fogPlumeValues.valveClose = statusArrValues[2]
                self.fogPlumeValues.valveTransition = statusArrValues[3]
                self.fogPlumeValues.faulted = statusArrValues[4]
                self.fogPlumeValues.inAuto = statusArrValues[5]
                self.fogPlumeValues.inHand = statusArrValues[6]
                self.fogPlumeValues.autoCmdActive = statusArrValues[7]
                self.fogPlumeValues.handCmdActive = statusArrValues[8]
                self.fogPlumeValues.failToOpen = statusArrValues[9]
                self.fogPlumeValues.failToClose = statusArrValues[10]
                self.fogPlumeValues.eStop = statusArrValues[11]
                
                self.parseFogSystemData()
            })
        })
    }
    
    func parseFogSystemData(){
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
        
       fogRingValues.valveEnabled == 1 ? ( enabled?.image = #imageLiteral(resourceName: "green")) : (enabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.valveOpen == 1 ? ( vlvopen?.image = #imageLiteral(resourceName: "green")) : (vlvopen?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.valveClose == 1 ? ( vlvclose?.image = #imageLiteral(resourceName: "green")) : (vlvclose?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.valveTransition == 1 ? ( vlvtrans?.image = #imageLiteral(resourceName: "green")) : (vlvtrans?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.inAuto == 1 ? ( inAuto?.image = #imageLiteral(resourceName: "green")) : (inAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.inHand == 1 ? ( inHand?.image = #imageLiteral(resourceName: "green")) : (inHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.faulted == 1 ? ( faulted?.image = #imageLiteral(resourceName: "red")) : (faulted?.image = #imageLiteral(resourceName: "green"))
       fogRingValues.autoCmdActive == 1 ? ( autoCmdActive?.image = #imageLiteral(resourceName: "green")) : (autoCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.handCmdActive == 1 ? ( handCmdActive?.image = #imageLiteral(resourceName: "green")) : (handCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogRingValues.failToOpen == 1 ? ( fToOpen?.image = #imageLiteral(resourceName: "red")) : (fToOpen?.image = #imageLiteral(resourceName: "green"))
       fogRingValues.failToClose == 1 ? ( fToClose?.image = #imageLiteral(resourceName: "red")) : (fToClose?.image = #imageLiteral(resourceName: "green"))
       fogRingValues.eStop == 1 ? ( eStop?.image = #imageLiteral(resourceName: "red")) : (eStop?.image = #imageLiteral(resourceName: "green"))
        
       let penabled = self.view.viewWithTag(2021) as? UIImageView
       let pvlvopen = self.view.viewWithTag(2022) as? UIImageView
       let pvlvclose = self.view.viewWithTag(2023) as? UIImageView
       let pvlvtrans = self.view.viewWithTag(2024) as? UIImageView
       let pinAuto = self.view.viewWithTag(2025) as? UIImageView
       let pinHand = self.view.viewWithTag(2026) as? UIImageView
       let pautoCmdActive = self.view.viewWithTag(2027) as? UIImageView
       let phandCmdActive = self.view.viewWithTag(2028) as? UIImageView
       let pfaulted = self.view.viewWithTag(2029) as? UIImageView
       let pfToOpen = self.view.viewWithTag(2030) as? UIImageView
       let pfToClose = self.view.viewWithTag(2031) as? UIImageView
       let peStop = self.view.viewWithTag(2032) as? UIImageView
        
       fogPlumeValues.valveEnabled == 1 ? ( penabled?.image = #imageLiteral(resourceName: "green")) : (penabled?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.valveOpen == 1 ? ( pvlvopen?.image = #imageLiteral(resourceName: "green")) : (pvlvopen?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.valveClose == 1 ? ( pvlvclose?.image = #imageLiteral(resourceName: "green")) : (pvlvclose?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.valveTransition == 1 ? ( pvlvtrans?.image = #imageLiteral(resourceName: "green")) : (pvlvtrans?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.inAuto == 1 ? ( pinAuto?.image = #imageLiteral(resourceName: "green")) : (pinAuto?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.inHand == 1 ? ( pinHand?.image = #imageLiteral(resourceName: "green")) : (pinHand?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.faulted == 1 ? ( pfaulted?.image = #imageLiteral(resourceName: "red")) : (pfaulted?.image = #imageLiteral(resourceName: "green"))
       fogPlumeValues.autoCmdActive == 1 ? ( pautoCmdActive?.image = #imageLiteral(resourceName: "green")) : (pautoCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.handCmdActive == 1 ? ( phandCmdActive?.image = #imageLiteral(resourceName: "green")) : (phandCmdActive?.image = #imageLiteral(resourceName: "blank_icon_on"))
       fogPlumeValues.failToOpen == 1 ? ( pfToOpen?.image = #imageLiteral(resourceName: "red")) : (pfToOpen?.image = #imageLiteral(resourceName: "green"))
       fogPlumeValues.failToClose == 1 ? ( pfToClose?.image = #imageLiteral(resourceName: "red")) : (pfToClose?.image = #imageLiteral(resourceName: "green"))
       fogPlumeValues.eStop == 1 ? ( peStop?.image = #imageLiteral(resourceName: "red")) : (peStop?.image = #imageLiteral(resourceName: "green"))
                
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendCmdFaultReset(_ sender: UIButton) {
        if sender.tag == 2013{
           CENTRAL_SYSTEM?.writeBit(bit: fogRingStartRegister+4, value: 1)
        }
        if sender.tag == 2033{
           CENTRAL_SYSTEM?.writeBit(bit: fogPlumeStartRegister+4, value: 1)
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
