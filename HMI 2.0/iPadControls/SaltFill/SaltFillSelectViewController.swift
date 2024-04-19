//
//  SaltFillSelectViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/14/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SaltFillSelectViewController: UIViewController {

    @IBOutlet weak var noConnectionView: UIView!
        @IBOutlet weak var noConnectionErrLbl: UILabel!
        private var httpComm = HTTPComm()
        private let logger = Logger()
        private var centralSystem = CentralSystem()
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            centralSystem.getNetworkParameters()
            centralSystem.connect()
            CENTRAL_SYSTEM = centralSystem
             NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
        }
        @objc func checkSystemStat(){
            
            let (plcConnection,_) = CENTRAL_SYSTEM!.getConnectivityStat()
            
            if plcConnection == CONNECTION_STATE_CONNECTED{
                
                //Change the connection stat indicator
                noConnectionView.alpha = 0
    //            getProjectorStatus()
                noConnectionView.isUserInteractionEnabled = false
                //Check if the pumps or on auto mode or hand mode
                
                logger.logData(data: "PUMP: CONNECTION SUCCESS")
                
            }  else {
                noConnectionView.alpha = 1
                if plcConnection == CONNECTION_STATE_FAILED {
                    noConnectionErrLbl.text = "PLC CONNECTION FAILED, SERVER GOOD"
                } else if plcConnection == CONNECTION_STATE_CONNECTING {
                    noConnectionErrLbl.text = "CONNECTING TO PLC, SERVER CONNECTED"
                } else if plcConnection == CONNECTION_STATE_POOR_CONNECTION {
                    noConnectionErrLbl.text = "PLC POOR CONNECTION, SERVER CONNECTED"
                }
            }
            
        }
        
        @IBAction func redirectToPrjStatus(_ sender: UIButton) {
           let storyBoard : UIStoryboard = UIStoryboard(name: "saltfill", bundle:nil)
            
            let prjDetail = storyBoard.instantiateViewController(withIdentifier: "saltfillStatus") as! SaltFillViewController
            prjDetail.saltFillNumber = sender.tag
            self.navigationController?.pushViewController(prjDetail, animated: true)
        }
    @IBAction func showAlerSettings(_ sender: UIButton) {
            self.addAlertAction(button: sender)
       }
    }

