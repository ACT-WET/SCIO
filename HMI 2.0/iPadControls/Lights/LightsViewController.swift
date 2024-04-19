//
//  LightsViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 7/31/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit

class LightsViewController: UIViewController {
    
    @IBOutlet weak var noConnectionView: UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    @IBOutlet weak var lightIconButton: UIButton!
    @IBOutlet weak var schedulerContainerView: UIView!
    @IBOutlet weak var lightsHOAStatus: UILabel!
    @IBOutlet weak var lightFault: UIImageView!
    private var centralSystem = CentralSystem()
    private let showManager  = ShowManager()
    private let logger = Logger()
    private let httpComm = HTTPComm()
    private var numberOfLightsOn = 0
    private var inHandMode = false
    private var lightState = 0
    private var autoHandStats = 0
    private var schOnStatus = 0
    private var waterLevelBelowLLFault = [Int]()
    private var individualLightStatus = 0
    var lightType = 0
    
    override func viewWillAppear(_ animated: Bool) {
        //Add notification observer to get system stat
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        self.navigationItem.title = "LIGHTS"
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        numberOfLightsOn = 0
    }
    
    
    
    /***************************************************************************
     * Function :  checkSystemStat
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @objc func checkSystemStat(){
        let (plcConnection, serverConnection) = CENTRAL_SYSTEM!.getConnectivityStat()
        
        if plcConnection == CONNECTION_STATE_CONNECTED && serverConnection == CONNECTION_STATE_CONNECTED  {
            
            //Change the connection stat indicator
            noConnectionView.alpha = 0
            
            
            readLightsAutoHandMode()
            
        } else {
            noConnectionView.alpha = 1
            
            if plcConnection == CONNECTION_STATE_FAILED || serverConnection == CONNECTION_STATE_FAILED {
                if serverConnection == CONNECTION_STATE_CONNECTED {
                    noConnectionErrorLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
                } else if plcConnection == CONNECTION_STATE_CONNECTED{
                    noConnectionErrorLbl.text = "SERVER CONNECTION FAILED, PLC GOOD"
                } else {
                    noConnectionErrorLbl.text = "SERVER AND PLC CONNECTION FAILED"
                }
            }
            
            if plcConnection == CONNECTION_STATE_CONNECTING || serverConnection == CONNECTION_STATE_CONNECTING {
                if serverConnection == CONNECTION_STATE_CONNECTED {
                    noConnectionErrorLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
                } else if plcConnection == CONNECTION_STATE_CONNECTED{
                    noConnectionErrorLbl.text = "CONNECTING TO SERVER, PLC CONNECTED"
                } else {
                    noConnectionErrorLbl.text = "CONNECTING TO SERVER AND PLC.."
                }
            }
            
            if plcConnection == CONNECTION_STATE_POOR_CONNECTION && serverConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "SERVER AND PLC POOR CONNECTION"
            } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
            } else if serverConnection == CONNECTION_STATE_POOR_CONNECTION {
                noConnectionErrorLbl.text = "SERVER POOR CONNECTION, PLC CONNECTED"
            }
        }
    }
    
    
    private func readLightsAutoHandMode() {
        let dayModeStats = self.showManager.getStatusLogFromServer()
        if dayModeStats.dayMode == 1{
            self.lightsHOAStatus.text = "LIGHTS OFF"
        } else if dayModeStats.dayMode == 0{
            self.lightsHOAStatus.text = "LIGHTS ON"
        }
    }
    
}
