//
//  WQDetailViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 5/3/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class WQDetailViewController: UIViewController {
    
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    var sensorNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var dcNum = 0
    var dcStartingRegister = 0
    private var centralSystem = CentralSystem()
    private let logger =  Logger()
    var wqValues  = AI_VALUES()
    
    override func viewWillAppear(_ animated: Bool){
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        
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
            getWQDataFromPLC()
            
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
    
    func getWQDataFromPLC(){
        CENTRAL_SYSTEM?.readRegister(length:Int32(pH_SENSOR_DATAREGISTER.count), startingRegister: Int32(pH_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:1)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(ORP_SENSOR_DATAREGISTER.count), startingRegister: Int32(ORP_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:2)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(CONDUCTIVITY_SENSOR_DATAREGISTER.count), startingRegister: Int32(CONDUCTIVITY_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:3)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(BR_SENSOR_DATAREGISTER.count), startingRegister: Int32(BR_SENSOR_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:4)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(AT1001_TEMP_DATAREGISTER.count), startingRegister: Int32(AT1001_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:5)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(TT1002_TEMP_DATAREGISTER.count), startingRegister: Int32(TT1002_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:6)
        })
        CENTRAL_SYSTEM?.readRegister(length:Int32(TT1003_TEMP_DATAREGISTER.count), startingRegister: Int32(TT1003_TEMP_DATAREGISTER.startAddr), completion: { (sucess, response) in
            
            //Check points to make sure the PLC Call was successful
            
            guard sucess == true else{
                self.logger.logData(data: "WATER LEVEL FAILED TO GET RESPONSE FROM PLC")
                return
            }
            let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![2] as! NSNumber))
            //print(statusArrValues)
            self.wqValues.status_abvHH = statusArrValues[0]
            self.wqValues.status_abvH = statusArrValues[1]
            self.wqValues.status_blwL = statusArrValues[2]
            self.wqValues.status_blwLL = statusArrValues[3]
            self.wqValues.status_blwLLL = statusArrValues[4]
            self.wqValues.status_faulted = statusArrValues[5]
            self.wqValues.status_channelFault = statusArrValues[6]
            self.wqValues.status_scalingFault = statusArrValues[7]
            self.wqValues.status_outOFRangeFault = statusArrValues[8]
            
            self.wqValues.status_ScaledVal = Int(truncating: response![4] as! NSNumber)
            self.wqValues.status_precision = Int(truncating: response![6] as! NSNumber)
            
            self.parseWQSystemData(data:self.wqValues, tag:7)
        })
    }
    
    func parseWQSystemData(data:AI_VALUES, tag:Int){
        
        let tagNum = 2000 + (tag - 1) * 10
        
        let scaledVal = self.view.viewWithTag(tagNum) as? UILabel
        let abvHH = self.view.viewWithTag(tagNum+1) as? UIImageView
        let abvH = self.view.viewWithTag(tagNum+2) as? UIImageView
        let blwL = self.view.viewWithTag(tagNum+3) as? UIImageView
        let blwLL = self.view.viewWithTag(tagNum+4) as? UIImageView
        let blwLLL = self.view.viewWithTag(tagNum+5) as? UIImageView
        let faulted = self.view.viewWithTag(tagNum+6) as? UIImageView
        let chFault = self.view.viewWithTag(tagNum+7) as? UIImageView
        let scaling = self.view.viewWithTag(tagNum+8) as? UIImageView
        let outOfRange = self.view.viewWithTag(tagNum+9) as? UIImageView

         
        data.status_abvHH == 1 ? ( abvHH?.image = #imageLiteral(resourceName: "red")) : (abvHH?.image = #imageLiteral(resourceName: "green"))
        data.status_abvH == 1 ? ( abvH?.image = #imageLiteral(resourceName: "red")) : (abvH?.image = #imageLiteral(resourceName: "green"))
        data.status_blwL == 1 ? ( blwL?.image = #imageLiteral(resourceName: "red")) : (blwL?.image = #imageLiteral(resourceName: "green"))
        data.status_blwLL == 1 ? ( blwLL?.image = #imageLiteral(resourceName: "red")) : (blwLL?.image = #imageLiteral(resourceName: "green"))
        data.status_blwLLL == 1 ? ( blwLLL?.image = #imageLiteral(resourceName: "red")) : (blwLLL?.image = #imageLiteral(resourceName: "green"))
        data.status_faulted == 1 ? ( faulted?.image = #imageLiteral(resourceName: "red")) : (faulted?.image = #imageLiteral(resourceName: "green"))
        data.status_channelFault == 1 ? ( chFault?.image = #imageLiteral(resourceName: "red")) : (chFault?.image = #imageLiteral(resourceName: "green"))
        data.status_scalingFault == 1 ? ( scaling?.image = #imageLiteral(resourceName: "red")) : (scaling?.image = #imageLiteral(resourceName: "green"))
        data.status_outOFRangeFault == 1 ? ( outOfRange?.image = #imageLiteral(resourceName: "red")) : (outOfRange?.image = #imageLiteral(resourceName: "green"))
        
        let divisor = pow(10,data.status_precision)
        let scaledValue = Float(data.status_ScaledVal) / Float(truncating: divisor as NSNumber)
        scaledVal?.text = String(format: "%.2f", scaledValue)
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
