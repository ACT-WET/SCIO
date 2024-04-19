//
//  SaltFillSetSelectViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 9/14/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SaltFillSetSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func redirectToPrjStatus(_ sender: UIButton) {
          let storyBoard : UIStoryboard = UIStoryboard(name: "saltfill", bundle:nil)
           
           let prjDetail = storyBoard.instantiateViewController(withIdentifier: "saltSettings") as! SaltFillSettingsViewController
           prjDetail.saltFillNumber = sender.tag
           self.navigationController?.pushViewController(prjDetail, animated: true)
    }

    @IBAction func redirectToSettings(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "saltfill", bundle:nil)
        
        let prjDetail = storyBoard.instantiateViewController(withIdentifier: "purgeSettings") as! SaltPurgeSettingsViewController
        self.navigationController?.pushViewController(prjDetail, animated: true)
    }
    

}
