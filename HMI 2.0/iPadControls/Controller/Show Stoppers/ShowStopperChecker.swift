//
//  ShowStopperChecker.swift
//  iPadControls
//
//  Created by Jan Manalo on 12/26/18.
//  Copyright © 2018 WET. All rights reserved.
//

import UIKit



class ShowStopperChecker: UIViewController {
    
    @IBOutlet var showStopperView: UIView!
    
    
    var showStoppers   = ShowStoppers()
    var showStopperDictionary: [String : CGFloat] = [:]
    private let showManager  = ShowManager()
    
    private var timer:   Timer?             //Timer that handles the show stoppers every second
    private let logger = Logger()           //Helper class to log fotmatted data for debugging purposes
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getShowStoppers), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //We want to make sure to close the timer to prevent multiple instances of it
        timer?.invalidate()
        timer = nil
        self.logger.logData(data: "SHOW STOPPERS TIMER STOPPED")
    }
    
    /***************************************************************************
     * Function :  getShowStoppers
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    @objc private func getShowStoppers(){
        
        CENTRAL_SYSTEM?.readRegister(length: Int32(SHOW_STOPPERS_PLC_REGISTERS.count), startingRegister: Int32(SHOW_STOPPERS_PLC_REGISTERS.startAddress), completion: { (success, response) in
            
           guard success == true else { return }
            
           let statusArrValues = self.convertIntToBitArr(a: Int(truncating: response![0] as! NSNumber))

           //Estop Show Stopper
           let estopNot_ok                 = statusArrValues[0]
           let physStop                    = statusArrValues[4]
           let digStop                     = statusArrValues[5]
           //Water Level speed show stopper
           let water_level_below_ll        = statusArrValues[1]
           //Wind Show Stopper
           let wind_speed_1_abort_show     = statusArrValues[2]
           //Filtration Pump Not Running
           let filterNR                    = statusArrValues[3]
    
           /* DO NOT CHANGE THE (showStopper: "NAME"). ALREADY SET AND CORRESPONDS TO THE CORRECT IMAGE NAME */
           
           
           if water_level_below_ll == FAULT_DETECTED{
               self.createShowStoppers(showStopper: "showStopperWaterLevel")
           } else {
               self.removeShowStopper(showStopper: "showStopperWaterLevel")
           }
           
           if wind_speed_1_abort_show == FAULT_DETECTED {
               self.createShowStoppers(showStopper: "showStopperWind")
           } else {
               self.removeShowStopper(showStopper: "showStopperWind")
           }
           
           if estopNot_ok == FAULT_DETECTED{
               self.createShowStoppers(showStopper: "eStop")
           } else {
               self.removeShowStopper(showStopper: "eStop")
           }
            
           if physStop == FAULT_DETECTED || digStop == FAULT_DETECTED {
               self.createShowStoppers(showStopper: "showStopperClient")
           } else {
               self.removeShowStopper(showStopper: "showStopperClient")
           }
            
           if filterNR == FAULT_DETECTED{
               self.createShowStoppers(showStopper: "showStopperPumps")
           } else {
               self.removeShowStopper(showStopper: "showStopperPumps")
           }
        })
        
    }
    
    private func createShowStoppers(showStopper: String){
        let showStopperImageName = UIImage(named: showStopper)
        let showStopperImageView = UIImageView(image: showStopperImageName)
        var viewPositionX: [CGFloat] = []
        let offset = 60
        
        if !showStopperDictionary.keys.contains(showStopper) {
            if showStopperView.subviews.isEmpty {
                showStopperImageView.frame = CGRect(x: 480, y: 0, width: 50, height: 50)
                showStopperView.addSubview(showStopperImageView)
                showStopperDictionary[showStopper] = 480
            } else {
                for view in showStopperView.subviews {
                    viewPositionX.append(view.frame.origin.x)
                }
                
                if let minimumXPosition = viewPositionX.min() {
                    let xPosition = Int(minimumXPosition) - offset
                    showStopperImageView.frame = CGRect(x: xPosition, y: 0, width: 50, height: 50)
                    showStopperView.addSubview(showStopperImageView)
                    showStopperDictionary[showStopper] = CGFloat(xPosition)
                }
            }
            
        } else {
            return
        }
    }
    
    private func removeShowStopper(showStopper: String) {
        if showStopperDictionary.keys.contains(showStopper) {
            if let xPosition = showStopperDictionary[showStopper] {
                for view in showStopperView.subviews where view.frame.origin.x == xPosition {
                    view.removeFromSuperview()
                }
                showStopperDictionary.removeValue(forKey: showStopper)
                rearrangeShowStoppers()
            }
        } else {
            return
        }
    }
    
    
    private func rearrangeShowStoppers() {
        let availablePositions: [CGFloat] = [480.0, 420.0, 360.0, 300.0, 240.0, 180.0, 120.0, 60.0, 0.0]
        var newKey = ""
        var newValue = CGFloat(0.0)
        var newDictionary: [String: CGFloat] = [:]
       
        //NOTE: The keys and values in showStopperDictionary are constant, so we need to make a new dictionary with the nex x-positions (value) and set that as the new showStopperDictionary.
        
        //STEP 1: Sort the key by its value in descending order
        let sortedOldDictionary = showStopperDictionary.sorted { $0.1 > $1.1 }
        
        //STEP 2: Store the sorted key to the new key with a new value, then add to new dictionary
        for (index, sortedKey) in sortedOldDictionary.enumerated() {
            newKey = sortedKey.key
            newValue = availablePositions[index]
            newDictionary[newKey] = newValue
        }

        //STEP 3: Remove all key-value pair from showStopperDictionary, and set the newDictionary as showStopperDictionary
        showStopperDictionary.removeAll()
        showStopperDictionary = newDictionary
        
        //STEP 4: Remove all the image views from the showStopperView
        for view in showStopperView.subviews{
            view.removeFromSuperview()
        }
        
        //STEP 5: Add the new modified dictionary with the correct show stopper and x-position as a subview to showStopperView
        for (key, value) in showStopperDictionary {
            let showStopperImageName = UIImage(named: key)
            let showStopperImageView = UIImageView(image: showStopperImageName)
            showStopperImageView.frame = CGRect(x: value, y: 0, width: 50, height: 50)
            showStopperView.addSubview(showStopperImageView)
        }
    }
}
