//
//  SystemFaultViewController.swift
//  iPadControls
//
//  Created by Jan Manalo on 12/13/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit

class SystemFaultViewController: UIViewController {

    @IBOutlet weak var nameOfFaultLabel: UILabel!
    var faultIndex: [Int]?
    var strainerFaultIndex: [Int]?
    var faultTag = 0
    var faultLabel = UILabel()
    var strainerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if faultTag == 200{
            nameOfFaultLabel.text = "NETWORK FAULT"
            nameOfFaultLabel.textAlignment = .center 
            readNetworkFaults()
        } else {
            nameOfFaultLabel.text = "CLEAN STRAINER"
            nameOfFaultLabel.textAlignment = .center
            readStarinerFaults()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if faultTag == 100{
            faultLabel.removeFromSuperview()
            faultIndex?.removeAll()
        } else {
            strainerLabel.removeFromSuperview()
            strainerFaultIndex?.removeAll()
        }
       
    }
    
    private func readNetworkFaults() {
        let offset = 30
        
        for (index,value) in faultIndex!.enumerated() {
            
            switch index {
            case 0...5:
                customizeFaultLabel(x: 62, y: (95 + (index * offset)), index: value)
            default:
                print("Wrong index")
            }
            
        }
    }
    
    private func readStarinerFaults() {
        for (index,value) in strainerFaultIndex!.enumerated() {
            let offset = 30
            
            switch index {
                case 0...4:
                    customizeStrainerFaultLabel(x: 25, y: (95 + (index * offset)), index: value)
                default:
                    print("Wrong index")
                }
        }
    }
    
    private func customizeFaultLabel(x: Int, y: Int, index: Int) {
        faultLabel = UILabel(frame: CGRect(x: x, y: y, width: 130, height: 20))
        faultLabel.textAlignment = .center
        faultLabel.textColor = RED_COLOR
        switch index {
            case 0:   faultLabel.text = "VFD - 201"
            case 1:   faultLabel.text = "VFD - 202"
            case 2:   faultLabel.text = "VFD - 203"
            case 3:   faultLabel.text = "VFD - 204"
            case 4:   faultLabel.text = "VFD - 205"
            case 5:   faultLabel.text = "FS - 201"
            default:
                print("Wrong index")
        }
        self.view.addSubview(faultLabel)
    }
    
    private func customizeStrainerFaultLabel(x: Int, y: Int, index: Int) {
        if y > 505 {
           strainerLabel = UILabel(frame: CGRect(x: 200, y: y - 420, width: 150, height: 20))
        } else {
           strainerLabel = UILabel(frame: CGRect(x: x, y: y, width: 150, height: 20))
        }
        
        strainerLabel.textAlignment = .center
        strainerLabel.textColor = RED_COLOR
        switch index {
               case 0:   strainerLabel.text = "VFD - 201"
               case 1:   strainerLabel.text = "VFD - 202"
               case 2:   strainerLabel.text = "VFD - 203"
               case 3:   strainerLabel.text = "VFD - 204"
               case 4:   strainerLabel.text = "VFD - 205"
        default:
            print("Wrong index")
        }
       
        self.view.addSubview(strainerLabel)
    }

    
}
