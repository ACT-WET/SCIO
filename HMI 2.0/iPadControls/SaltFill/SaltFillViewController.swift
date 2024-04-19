//
//  SaltFillViewController.swift
//  iPadControls
//
//  Created by Jan Manalo on 7/31/18.
//  Copyright © 2018 WET. All rights reserved.
//


import UIKit


class SaltFillViewController: UIViewController{
    
  
    @IBOutlet weak var fireSpire1Name: UILabel!
    @IBOutlet weak var fireSpire2Name: UILabel!
    @IBOutlet weak var scaledVal: UILabel!
    @IBOutlet weak var fillTimeoutImg: UIImageView!
    @IBOutlet weak var pumpName: UILabel!
    @IBOutlet weak var fillStatusImg: UIImageView!
    @IBOutlet weak var ptscaledVal: UILabel!
    
    @IBOutlet weak var scaled2Val: UILabel!
    @IBOutlet weak var fill2TimeoutImg: UIImageView!
    @IBOutlet weak var fill2StatusImg: UIImageView!
    @IBOutlet weak var ptscaled2Val: UILabel!
    
    @IBOutlet weak var valve1Name: UILabel!
    @IBOutlet weak var valve2Name: UILabel!
    @IBOutlet weak var valve3Name: UILabel!
    @IBOutlet weak var valve4Name: UILabel!
    @IBOutlet weak var tank2Name: UILabel!
    @IBOutlet weak var tank1Name: UILabel!
    @IBOutlet weak var valve1Status: UIImageView!
    @IBOutlet weak var valve2Status: UIImageView!
    @IBOutlet weak var valve3Status: UIImageView!
    @IBOutlet weak var valve4Status: UIImageView!
    @IBOutlet weak var pumpStatus: UIImageView!
     private var centralSystem = CentralSystem()
        var tank1Stats = SALTFILL_STATS()
        var tank2Stats = SALTFILL_STATS()
        var tank3Stats = SALTFILL_STATS()
        var tank4Stats = SALTFILL_STATS()
        var tank5Stats = SALTFILL_STATS()
        var tank6Stats = SALTFILL_STATS()
    
        var tempStats = SALTFILL_STATS()
        
        var saltFillNumber = 0
        override func viewDidLoad() {
            super.viewDidLoad()
            readSaltFillStats()
            // Do any additional setup after loading the view.
        }
            
        override func viewWillAppear(_ animated: Bool) {
             centralSystem.getNetworkParameters()
             centralSystem.connect()
             CENTRAL_SYSTEM = centralSystem
             NotificationCenter.default.addObserver(self, selector: #selector(checkSystemStat), name: NSNotification.Name(rawValue: "updateSystemStat"), object: nil)
            
            switch saltFillNumber {
                case 1:self.fireSpire1Name.text = "FIRE SPIRE 401"
                       self.fireSpire2Name.text = "FIRE SPIRE 404"
                       self.valve1Name.text = "1103"
                       self.valve2Name.text = "1106"
                       self.valve3Name.text = "4103"
                       self.valve4Name.text = "4106"
                       self.tank1Name.text = "TANK 1101"
                       self.tank2Name.text = "TANK 4101"
                       self.pumpName.text = "P111"
                       self.navigationItem.title = "SALT FILL T-1101 / T-4101"
                case 2:self.fireSpire1Name.text = "FIRE SPIRE 402"
                       self.fireSpire2Name.text = "FIRE SPIRE 405"
                       self.valve1Name.text = "2103"
                       self.valve2Name.text = "2106"
                       self.valve3Name.text = "5103"
                       self.valve4Name.text = "5106"
                       self.tank1Name.text = "TANK 2101"
                       self.tank2Name.text = "TANK 5101"
                       self.pumpName.text = "P112"
                       self.navigationItem.title = "SALT FILL T-2101 / T-5101"
                case 3:self.fireSpire1Name.text = "FIRE SPIRE 403"
                       self.fireSpire2Name.text = "FIRE SPIRE 406"
                       self.valve1Name.text = "3103"
                       self.valve2Name.text = "3106"
                       self.valve3Name.text = "6103"
                       self.valve4Name.text = "6106"
                       self.tank1Name.text = "TANK 3101"
                       self.tank2Name.text = "TANK 6101"
                       self.pumpName.text = "P113"
                       self.navigationItem.title = "SALT FILL T-3101 / T-6101"
            default:
                print("Wrong Tag: SaltFill")
            }
        }
        
        
        @objc func checkSystemStat(){
            readSaltFillStats()
            parseSaltFillStats()
        }
        
        func readSaltFillStats (){
            
            CENTRAL_SYSTEM?.readBits(length: 102, startingRegister: Int32(TANK1_SALT_STATUS), completion: { (success, response) in
                
                guard success == true else { return }
                
                self.tank1Stats.fillStatus = Int(truncating: response![0] as! NSNumber)
                self.tank1Stats.fillTimeout = Int(truncating: response![1] as! NSNumber)
                
                self.tank2Stats.fillStatus = Int(truncating: response![20] as! NSNumber)
                self.tank2Stats.fillTimeout = Int(truncating: response![21] as! NSNumber)
                
                self.tank3Stats.fillStatus = Int(truncating: response![40] as! NSNumber)
                self.tank3Stats.fillTimeout = Int(truncating: response![41] as! NSNumber)
                
                self.tank1Stats.fill2Status = Int(truncating: response![60] as! NSNumber)
                self.tank1Stats.fill2Timeout = Int(truncating: response![61] as! NSNumber)
                
                self.tank2Stats.fill2Status = Int(truncating: response![80] as! NSNumber)
                self.tank2Stats.fill2Timeout = Int(truncating: response![81] as! NSNumber)
                
                self.tank3Stats.fill2Status = Int(truncating: response![100] as! NSNumber)
                self.tank3Stats.fill2Timeout = Int(truncating: response![101] as! NSNumber)
            })
            
            if saltFillNumber == 1{
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK1_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                    guard success == true else { return }
                    self.tank1Stats.ltScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK4_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank1Stats.lt2ScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK1_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank1Stats.ptScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK4_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank1Stats.pt2ScaledValue = Double(response)!
                })
            }
            
            if saltFillNumber == 2{
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK2_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank2Stats.ltScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK5_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank2Stats.lt2ScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK2_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank2Stats.ptScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK5_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank2Stats.pt2ScaledValue = Double(response)!
                })
            }
            
            if saltFillNumber == 3{
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK3_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank3Stats.ltScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK6_SCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank3Stats.lt2ScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK3_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank3Stats.ptScaledValue = Double(response)!
                })
                CENTRAL_SYSTEM?.readRealRegister(register: Int(TANK6_PTSCALEDVALUE_STATUS), length: 2, completion: { (success, response) in
                     guard success == true else { return }
                    self.tank3Stats.pt2ScaledValue = Double(response)!
                })
            }
        }
        
        func parseSaltFillStats (){
            
            if saltFillNumber == 1{
                tank1Stats.fillStatus == 1 ? ( fillStatusImg?.image = #imageLiteral(resourceName: "green")) : (fillStatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank1Stats.fillTimeout == 1 ? ( fillTimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fillTimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                tank1Stats.fill2Status == 1 ? ( fill2StatusImg?.image = #imageLiteral(resourceName: "green")) : (fill2StatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank1Stats.fill2Timeout == 1 ? ( fill2TimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fill2TimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                self.scaledVal.text = String(format: "%.0f", self.tank1Stats.ltScaledValue)
                self.ptscaledVal.text = String(format: "%.0f", self.tank1Stats.ptScaledValue)
                
                self.scaled2Val.text = String(format: "%.0f", self.tank1Stats.lt2ScaledValue)
                self.ptscaled2Val.text = String(format: "%.0f", self.tank1Stats.pt2ScaledValue)
                
                if self.tank1Stats.fillStatus == 1 || self.tank1Stats.fill2Status == 1 {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpRunning")
                } else {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpsNoFault")
                }
                
                if self.tank1Stats.fillTimeout == 1{
                  self.valve1Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve2Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank1Stats.fillStatus == 1{
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
                
                if self.tank1Stats.fill2Timeout == 1{
                  self.valve3Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve4Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank1Stats.fill2Status == 1{
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
            }
            
            if saltFillNumber == 2{
                tank2Stats.fillStatus == 1 ? ( fillStatusImg?.image = #imageLiteral(resourceName: "green")) : (fillStatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank2Stats.fillTimeout == 1 ? ( fillTimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fillTimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                tank2Stats.fill2Status == 1 ? ( fill2StatusImg?.image = #imageLiteral(resourceName: "green")) : (fill2StatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank2Stats.fill2Timeout == 1 ? ( fill2TimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fill2TimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                self.scaledVal.text = String(format: "%.0f", self.tank2Stats.ltScaledValue)
                self.ptscaledVal.text = String(format: "%.0f", self.tank2Stats.ptScaledValue)
                
                self.scaled2Val.text = String(format: "%.0f", self.tank2Stats.lt2ScaledValue)
                self.ptscaled2Val.text = String(format: "%.0f", self.tank2Stats.pt2ScaledValue)
                
                if self.tank2Stats.fillStatus == 1 || self.tank2Stats.fill2Status == 1 {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpRunning")
                } else {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpsNoFault")
                }
                
                if self.tank2Stats.fillTimeout == 1{
                  self.valve1Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve2Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank2Stats.fillStatus == 1{
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
                
                if self.tank2Stats.fill2Timeout == 1{
                  self.valve3Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve4Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank2Stats.fill2Status == 1{
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
            }
            
            if saltFillNumber == 3{
                tank3Stats.fillStatus == 1 ? ( fillStatusImg?.image = #imageLiteral(resourceName: "green")) : (fillStatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank3Stats.fillTimeout == 1 ? ( fillTimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fillTimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                tank3Stats.fill2Status == 1 ? ( fill2StatusImg?.image = #imageLiteral(resourceName: "green")) : (fill2StatusImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                tank3Stats.fill2Timeout == 1 ? ( fill2TimeoutImg?.image = #imageLiteral(resourceName: "red")) : (fill2TimeoutImg?.image = #imageLiteral(resourceName: "blank_icon_on"))
                
                self.scaledVal.text = String(format: "%.0f", self.tank3Stats.ltScaledValue)
                self.ptscaledVal.text = String(format: "%.0f", self.tank3Stats.ptScaledValue)
                
                self.scaled2Val.text = String(format: "%.0f", self.tank3Stats.lt2ScaledValue)
                self.ptscaled2Val.text = String(format: "%.0f", self.tank3Stats.pt2ScaledValue)
                
                if self.tank3Stats.fillStatus == 1 || self.tank3Stats.fill2Status == 1 {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpRunning")
                } else {
                    self.pumpStatus.image = #imageLiteral(resourceName: "pumpsNoFault")
                }
                
                if self.tank3Stats.fillTimeout == 1{
                  self.valve1Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve2Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank3Stats.fillStatus == 1{
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve1Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve2Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
                
                if self.tank3Stats.fill2Timeout == 1{
                  self.valve3Status.image = #imageLiteral(resourceName: "valve-red")
                  self.valve4Status.image = #imageLiteral(resourceName: "valve-red")
                } else {
                    if self.tank3Stats.fill2Status == 1{
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-green")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-green")
                    } else {
                        self.valve3Status.image = #imageLiteral(resourceName: "valve-white")
                        self.valve4Status.image = #imageLiteral(resourceName: "valve-white")
                    }
                }
            }
        }
    }
