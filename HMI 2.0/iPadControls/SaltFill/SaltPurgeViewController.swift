//
//  SaltPurgeViewController.swift
//  iPadControls
//
//  Created by Rakesh Raveendra on 10/7/21.
//  Copyright © 2021 WET. All rights reserved.
//

import UIKit

class SaltPurgeViewController: UIViewController {
    
    @IBOutlet weak var bodRunStatus: UILabel!
    
    @IBOutlet weak var eodRunStatus: UILabel!
    @IBOutlet weak var bodManPurge: UIButton!
    @IBOutlet weak var eodManPurge: UIButton!
    @IBOutlet weak var cannotRunBLbl: UILabel!
    @IBOutlet weak var cannotRunELbl: UILabel!
    private var centralSystem = CentralSystem()
    override func viewWillAppear(_ animated: Bool) {
        centralSystem.getNetworkParameters()
        centralSystem.connect()
        CENTRAL_SYSTEM = centralSystem
        NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func checkSystemStat(){
        readRunStatus()
    }
    
    func readRunStatus(){
        CENTRAL_SYSTEM!.readRegister(length: 6, startingRegister: Int32(ZS401_VLV_STATUS), completion:{ (success, response) in
            
            guard success == true else { return }
                
            let zs401 = Int(truncating: response![0] as! NSNumber)
            let zs402 = Int(truncating: response![1] as! NSNumber)
            let zs403 = Int(truncating: response![2] as! NSNumber)
            let zs404 = Int(truncating: response![3] as! NSNumber)
            let zs405 = Int(truncating: response![4] as! NSNumber)
            let zs406 = Int(truncating: response![5] as! NSNumber)
            
            let zs1Img = self.view.viewWithTag(11) as? UIImageView
            let zs2Img = self.view.viewWithTag(12) as? UIImageView
            let zs3Img = self.view.viewWithTag(13) as? UIImageView
            let zs4Img = self.view.viewWithTag(14) as? UIImageView
            let zs5Img = self.view.viewWithTag(15) as? UIImageView
            let zs6Img = self.view.viewWithTag(16) as? UIImageView
            
            zs401 == 1 ? ( zs1Img?.image = #imageLiteral(resourceName: "green")) : (zs1Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs402 == 1 ? ( zs2Img?.image = #imageLiteral(resourceName: "green")) : (zs2Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs403 == 1 ? ( zs3Img?.image = #imageLiteral(resourceName: "green")) : (zs3Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs404 == 1 ? ( zs4Img?.image = #imageLiteral(resourceName: "green")) : (zs4Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs405 == 1 ? ( zs5Img?.image = #imageLiteral(resourceName: "green")) : (zs5Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs406 == 1 ? ( zs6Img?.image = #imageLiteral(resourceName: "green")) : (zs6Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
        })
        CENTRAL_SYSTEM!.readBits(length: 6, startingRegister: Int32(ZS401_SALTVLV_STATUS), completion:{ (success, response) in
            
            guard success == true else { return }
                
            let zs401 = Int(truncating: response![0] as! NSNumber)
            let zs402 = Int(truncating: response![1] as! NSNumber)
            let zs403 = Int(truncating: response![2] as! NSNumber)
            let zs404 = Int(truncating: response![3] as! NSNumber)
            let zs405 = Int(truncating: response![4] as! NSNumber)
            let zs406 = Int(truncating: response![5] as! NSNumber)
            
            let zs1Img = self.view.viewWithTag(31) as? UIImageView
            let zs2Img = self.view.viewWithTag(32) as? UIImageView
            let zs3Img = self.view.viewWithTag(33) as? UIImageView
            let zs4Img = self.view.viewWithTag(34) as? UIImageView
            let zs5Img = self.view.viewWithTag(35) as? UIImageView
            let zs6Img = self.view.viewWithTag(36) as? UIImageView
            
            zs401 == 1 ? ( zs1Img?.image = #imageLiteral(resourceName: "green")) : (zs1Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs402 == 1 ? ( zs2Img?.image = #imageLiteral(resourceName: "green")) : (zs2Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs403 == 1 ? ( zs3Img?.image = #imageLiteral(resourceName: "green")) : (zs3Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs404 == 1 ? ( zs4Img?.image = #imageLiteral(resourceName: "green")) : (zs4Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs405 == 1 ? ( zs5Img?.image = #imageLiteral(resourceName: "green")) : (zs5Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
            zs406 == 1 ? ( zs6Img?.image = #imageLiteral(resourceName: "green")) : (zs6Img?.image = #imageLiteral(resourceName: "blank_icon_on"))
        })
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(EOD_RUNSTATUS), completion: { (success, response) in
            
            guard success == true else { return }
            let eodrunning = Int(truncating: response![0] as! NSNumber)
            
            if eodrunning == 1{
                self.eodRunStatus.text = "PURGE SEQUENCE ON"
                self.eodRunStatus.textColor = GREEN_COLOR
            } else {
               self.eodRunStatus.text = "PURGE SEQUENCE OFF"
               self.eodRunStatus.textColor = DEFAULT_GRAY
            }
        })
        CENTRAL_SYSTEM?.readBits(length: 1, startingRegister: Int32(BOD_RUNSTATUS), completion: { (success, response) in
            
            guard success == true else { return }
            let bodrunning = Int(truncating: response![0] as! NSNumber)
            
            if bodrunning == 1{
                self.bodRunStatus.text = "PURGE SEQUENCE ON"
                self.bodRunStatus.textColor = GREEN_COLOR
            } else {
                self.bodRunStatus.text = "PURGE SEQUENCE OFF"
                self.bodRunStatus.textColor = DEFAULT_GRAY
            }
        })
    }
    
    @IBAction func sendCmdEod(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: EOD_TOGGLE_PURGE_BIT, value: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            CENTRAL_SYSTEM?.writeBit(bit: EOD_TOGGLE_PURGE_BIT, value: 0)
        }
    }
    @IBAction func sendCmdBod(_ sender: UIButton) {
        CENTRAL_SYSTEM?.writeBit(bit: BOD_TOGGLE_PURGE_BIT, value: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            CENTRAL_SYSTEM?.writeBit(bit: BOD_TOGGLE_PURGE_BIT, value: 0)
        }
    }
    
    @IBAction func sendCmdValveOpen(_ sender: UIButton) {
        switch sender.tag {
        case 1...6: CENTRAL_SYSTEM?.writeBit(bit: ZS401_VLV_OPENCMD + sender.tag - 1, value: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                       CENTRAL_SYSTEM?.writeBit(bit: ZS401_VLV_OPENCMD + sender.tag - 1, value: 0)
                    }
        case 21...26: CENTRAL_SYSTEM?.writeBit(bit: ZS401_SALTVLV_OPENCMD + sender.tag - 21, value: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                       CENTRAL_SYSTEM?.writeBit(bit: ZS401_SALTVLV_OPENCMD + sender.tag - 21, value: 0)
                    }
        default:
            print("Wrong Tag: FireStat")
        }
       
    }
    
}
