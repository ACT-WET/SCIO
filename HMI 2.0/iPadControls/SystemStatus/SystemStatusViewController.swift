//
//  SystemStatusViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 12/12/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit

class SystemStatusViewController: UIViewController {
    
    private var ethernetFaultIndex = [Int]()
    private var cleanStrainerFaultIndex = [Int]()
    
    @IBOutlet weak var faultsViewContainer: UIView!
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var faultBtn: UIButton!
    @IBOutlet weak var warningbtn: UIButton!
    @IBOutlet weak var shwStpBtn: UIButton!
    
    var yellowStateResp = 0
    var redStateResp    = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        acquireDataFromPLC()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool){
        //NOTE: We need to remove the notification observer so the PUMP stat check point will stop to avoid extra bandwith usage
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            noConnectionView.isUserInteractionEnabled = false
            
            //Now that the connection is established, run functions
            acquireDataFromPLC()
            
        }  else {
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
    
    private func acquireDataFromPLC(){
        
        CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(SYSTEM_FAULT_YELLOW), completion:{ (success, response) in
            
            guard success == true else{
                return
            }
            let wstatusArrValues = self.convertIntToBitArr(a: Int(truncating: response![0] as! NSNumber))
            self.yellowStateResp = Int(truncating: response![0] as! NSNumber)
            self.parseYellowStates(bits:wstatusArrValues)
        })
        
        CENTRAL_SYSTEM?.readRegister(length: 1, startingRegister: Int32(SYSTEM_FAULT_RED), completion:{ (success, response1) in
                       
           guard success == true else{
               return
           }
           let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response1![0] as! NSNumber))
            self.redStateResp = Int(truncating: response1![0] as! NSNumber)
           self.parseRedStates(bits:statusArrValues)
        })
        
        let value = self.yellowStateResp + self.redStateResp
        if value > 0{
            self.faultsViewContainer.isHidden = false
        } else {
            self.faultsViewContainer.isHidden = true
        }
    }
    
    private func parseYellowStates(bits:[Int]){
        var yPosition = 190
        let offset    = 35
        for fault in SYSTEM_YELLOW_STATUS{
            
            let faultTag = fault.tag
            let state = bits[fault.bitwiseLocation]
            let indicator = view.viewWithTag(faultTag) as? UILabel
            switch faultTag {
            case 1...6:
                
            if state == 0 {
                indicator?.isHidden = true
            } else {
                indicator?.isHidden = false
                indicator?.frame = CGRect(x: 31, y: yPosition, width: 252, height: 21)
                yPosition += offset
            }
            default:
                print(" WARNING FAULT TAG NOT FOUND ", faultTag)
            }
        }
    }
    
    private func parseRedStates(bits:[Int]){
        var yPosition = 190
        let offset    = 35
        for fault in SYSTEM_RED_STATUS{
            
            let faultTag = fault.tag
            let state = bits[fault.bitwiseLocation]
            let indicator = view.viewWithTag(faultTag) as? UILabel
            switch faultTag {
            case 10...20:
                
            if state == 0 {
                indicator?.isHidden = true
            } else {
                indicator?.isHidden = false
                indicator?.frame = CGRect(x: 434, y: yPosition, width: 252, height: 21)
                yPosition += offset
            }
            default:
                print(" FAULT FAULT TAG NOT FOUND ", faultTag)
            }
        }
    }
    
    @IBAction func faultResetBtnPushed(_ sender: UIButton) {
        
        CENTRAL_SYSTEM?.writeBit(bit: FAULT_RESET_REGISTER, value: 1)
        self.faultBtn.isUserInteractionEnabled = false
        self.faultBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
            self.faultBtn.isUserInteractionEnabled = true
            self.faultBtn.isEnabled = true
        })
    }
    
    @IBAction func warningResetBtnPushed(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: WARNING_RESET_REGISTER, value: 1)
        self.warningbtn.isUserInteractionEnabled = false
        self.warningbtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
            self.warningbtn.isUserInteractionEnabled = true
            self.warningbtn.isEnabled = true
        })
    }
    
    @IBAction func digShwStopBtnPushed(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: DIG_SHOW_STOP_REGISTER, value: 1)
        self.shwStpBtn.isUserInteractionEnabled = false
        self.shwStpBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute:{
            self.shwStpBtn.isUserInteractionEnabled = true
            self.shwStpBtn.isEnabled = true
        })
    }
}
