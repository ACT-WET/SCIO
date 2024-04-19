//
//  HomeSettingsViewController.swift
//  iPadControls
//
//  Created by Jan Manalo 02/20/19.
//  Copyright © 2019 WET. All rights reserved.
//

import UIKit

var newIPAddress = ""

class HomeSettingsViewController: UIViewController{
    
    @IBOutlet weak var serverIpAddress: UITextField!
    @IBOutlet weak var plcIpAddress: UITextField!
    @IBOutlet weak var spmIpAddress: UITextField!
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    
    @IBOutlet weak var warningBtn: UIButton!
    @IBOutlet weak var faultBtn: UIButton!
    
    var networkSettings: Network?
    var addressType = ""
    var modbusAddress = 0
    var userWantsToWriteToModbus = false
    var editingAddressTextField = false
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
    }
    
    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/

    @objc func checkSystemStat(){
        let (plcConnection,_) = (CENTRAL_SYSTEM?.getConnectivityStat())!
        
        if plcConnection == CONNECTION_STATE_CONNECTED {
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            noConnectionView.isUserInteractionEnabled = false
            
            //Now that the connection is established, run functions
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        IPAddressIsChanged = false
    }
    
    /***************************************************************************
     * Function :  viewDidAppear
     * Input    :  none
     * Output   :  none
     * Comment  :  This function gets executed every time view appears
     ***************************************************************************/
    
    override func viewDidAppear(_ animated: Bool){
        loadCurrentSettings()
        
    }
    
    
    /***************************************************************************
     * Function :  loadCurrentSettings
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    private func loadCurrentSettings(){
        
        guard let networks = Network.all() as? [Network] else { return }
        
        guard networks.count != 0 else { return }
        
        networkSettings = networks[0]
        
        guard let networkSettings = networkSettings else { return }
        
        serverIpAddress.text = "\(networkSettings.serverIpAddress!)"
        plcIpAddress.text = "\(networkSettings.plcIpAddress!)"
        spmIpAddress.text = "\(networkSettings.spmIpAddress!)"
        
    }
    
    /***************************************************************************
     * Function :  saveSettings
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @IBAction func saveSettings(_ sender: UIButton){
        guard let networkSettings = networkSettings else { return }
        
        if serverIpAddress.text == ""{
            networkSettings.serverIpAddress = SERVER_IP_ADDRESS
        }else{
            networkSettings.serverIpAddress = serverIpAddress.text
        }
        
        if plcIpAddress.text == ""{
            networkSettings.plcIpAddress = PLC_IP_ADDRESS
        }else{
            networkSettings.plcIpAddress = plcIpAddress.text
        }
        
        if spmIpAddress.text == ""{
            networkSettings.spmIpAddress = SPM_IP_ADDRESS
        }else{
            networkSettings.spmIpAddress = spmIpAddress.text
        }
        
        _ = networkSettings.save()
        
        UserDefaults.standard.set("\(String(describing: networkSettings.serverIpAddress))", forKey: "serverIpAddress")
        UserDefaults.standard.set("\(String(describing: networkSettings.plcIpAddress))"   , forKey: "plcIpAddress")
        UserDefaults.standard.set("\(String(describing: networkSettings.spmIpAddress))"   , forKey: "spmIpAddress")
        
    }
    
    @IBAction func faultResetBtnPushed(_ sender: Any) {
        
        CENTRAL_SYSTEM?.writeBit(bit: FAULT_RESET_REGISTER, value: 1)
        self.faultBtn.isUserInteractionEnabled = false
        self.faultBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:{
            CENTRAL_SYSTEM?.writeBit(bit: FAULT_RESET_REGISTER, value: 0)
            self.faultBtn.isUserInteractionEnabled = true
            self.faultBtn.isEnabled = true
        })
    }
    
    @IBAction func warningResetBtnPushed(_ sender: Any) {
        CENTRAL_SYSTEM?.writeBit(bit: WARNING_RESET_REGISTER, value: 1)
        self.warningBtn.isUserInteractionEnabled = false
        self.warningBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute:{
            CENTRAL_SYSTEM?.writeBit(bit: WARNING_RESET_REGISTER, value: 0)
            self.warningBtn.isUserInteractionEnabled = true
            self.warningBtn.isEnabled = true
        })
    }
}
