//
//  DCSettingsSelectViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 4/30/24.
//  Copyright © 2024 WET. All rights reserved.
//

import UIKit

class DCSettingsSelectViewController: UIViewController {
    @IBOutlet weak var noConnectionView:     UIView!
    @IBOutlet weak var noConnectionErrorLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func redirectToDCPowerSettingsDetails(_ sender: UIButton) {
        let dcPowDetVC = UIStoryboard.init(name: "DCPower", bundle: nil).instantiateViewController(withIdentifier: "dcSetting") as! DCSettingsViewController
        dcPowDetVC.dcNum = sender.tag
        navigationController?.pushViewController(dcPowDetVC, animated: true)
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
