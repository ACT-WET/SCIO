//
//  Extensions.swift
//  iPadControls
//
//  Created by Jan Manalo on 8/6/18.
//  Copyright © 2018 WET. All rights reserved.
//


import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreTelephony

extension UIView {
    
    /***************************************************************************
     * Function :  rotate360Degrees
     * Input    :  animate object : True / False
     * Output   :  none
     * Comment  :  Extension to ratate any view object 360 Degress
     ***************************************************************************/
    
    func rotate360Degrees(animate: Bool){
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = Float.infinity
        
        if(animate == true){
        
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(Double.pi * 2)
            
        }else{
        
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = 0.0
            
        }
        
        self.layer.add(rotateAnimation, forKey: nil)
        
    }
    
}

extension UIViewController {

    /***************************************************************************
     * Function :  getSSID
     * Input    :  none
     * Output   :  SSID as String
     * Comment  :
     ***************************************************************************/
    
    func getSSID() -> String? {
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            //print("Not interfaces")
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        return interfaceData["SSID"] as? String
    }

    func convertIntToBitArr (a: Int) -> [Int] {
        let bitArrStr = padding(string: String(a, radix:2), toSize: 16).map { String($0) }
        var bitArrInt = [Int]()
        for index in 0..<bitArrStr.count{
            bitArrInt.insert(Int(bitArrStr[index])!, at: index)
        }
        return bitArrInt.reversed()
    }
    
    func padding(string : String, toSize: Int) -> String {
      var padded = string
      for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
      }
        return padded
    }
    
    func convertToJSON(object: Any, completion:@escaping (_ response: String?) -> ()) {
        let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        let escapedDataString = jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        completion(escapedDataString)
    }
    
 
    
    func getSpecificCharacters(time: String, completion:@escaping (_ minutes: String?, _ seconds: String?) -> ()) {
        
        //Format the minute
        let startServerMinuteIndex = time.startIndex
        let endServerMinuteIndex = time.index(startServerMinuteIndex, offsetBy: 1)
        let serverShowMinute = time[startServerMinuteIndex...endServerMinuteIndex]
        
        
        //Format the seconds
        let startServerSecondsIndex = time.index(endServerMinuteIndex, offsetBy: 2)
        let endServerSecondsIndex = time.index(startServerSecondsIndex, offsetBy: 1)
        let serverShowSeconds = time[startServerSecondsIndex...endServerSecondsIndex]
        
        let minute = String(serverShowMinute)
        let seconds = String(serverShowSeconds)
        
        completion(minute, seconds)
    }
    @objc public func checkScanStatus(){
           let httpComm = HTTPComm()
           httpComm.httpGetResponseFromPath(url: READ_SHOWSCAN_STATUS){ (response) in
               
               guard response != nil else { return }
               let responseArray = response as? NSArray
               let responseDictionary = responseArray![0] as? NSDictionary
               
               let state  = responseDictionary?["done"] as? Int
               let scanData = responseDictionary?["progress"] as? NSDictionary
               let totalNumOfShows = scanData?["numShows"] as? Int
               let currentShow = scanData?["currentShow"] as? Int
               
               if (state == 1){
                   UserDefaults.standard.set("0", forKey: "scanningShows")
               } else {
                   UserDefaults.standard.set(totalNumOfShows, forKey: "numberOfSPMShows")
                   UserDefaults.standard.set(currentShow, forKey: "showScanned")
               }
           }
       }
    
    @objc public func checkCurrentSchedule(){
        let httpComm = HTTPComm()
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.month, .day], from: currentDate)
        let day = components.day!
        let month = components.month!
        var currentDateInSpecialSchedule1 = false
        var currentDateInSpecialSchedule2 = false
        var currentDateInSpecialSchedule3 = false
        var currentSchedule = 1
        
        httpComm.httpGetResponseFromPath(url: READ_TIME_TABLE){ (response) in
            
            guard response != nil else { return }
            guard let responseArray = response as? [Any] else { return }
            
            if let specialSchedule1 = responseArray[0] as? [String : Int] {
                self.checkSpecialSchedule(response: specialSchedule1, month: month, day: day, currentDateInSchedule: &currentDateInSpecialSchedule1)
            }
            
            if let specialSchedule2 = responseArray[1] as? [String : Int] {
                self.checkSpecialSchedule(response: specialSchedule2, month: month, day: day, currentDateInSchedule: &currentDateInSpecialSchedule2)
            }
            
            if let specialSchedule3 = responseArray[2] as? [String : Int] {
                self.checkSpecialSchedule(response: specialSchedule3, month: month, day: day, currentDateInSchedule: &currentDateInSpecialSchedule3)
            }
            
            if currentDateInSpecialSchedule1 {
               currentSchedule = 2
            } else if currentDateInSpecialSchedule2 {
              currentSchedule = 3
            } else if currentDateInSpecialSchedule3 {
              currentSchedule = 4
            } else {
              currentSchedule = 1
            }
            UserDefaults.standard.set(currentSchedule, forKey: "CurrentSchedule")
            UserDefaults.standard.synchronize()

            httpComm.httpGet(url: "\(HTTP_PASS)\(SERVER_IP_ADDRESS):8080/readScheduler\(currentSchedule)?") { (response, success) in
                if success == true {
                    UserDefaults.standard.set(currentSchedule, forKey: "CurrentSchedule")
                }
            }
        }
    }
    
    @objc func animateBorder(button: UIButton) {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        button.layer.add(flash, forKey: nil)
    }
    
    func convertMonthsToDays(month: Int, day: Int) -> Int{
        var convertedToDays = 0
        
        switch month {
        case 1:
            convertedToDays = day
        case 2:
            convertedToDays =  31 + day
        case 3:
            convertedToDays =  59 + day
        case 4:
            convertedToDays =  90 + day
        case 5:
            convertedToDays =  120 + day
        case 6:
            convertedToDays =  151 + day
        case 7:
            convertedToDays =  181 + day
        case 8:
            convertedToDays =  212 + day
        case 9:
            convertedToDays =  243 + day
        case 10:
            convertedToDays =  273 + day
        case 11:
            convertedToDays =  304 + day
        case 12:
            convertedToDays =  334 + day
        default:
            print("Error, cannot convert to total days")
        }
        
        return convertedToDays
    }
    
    func checkSpecialSchedule(response: [String : Int], month: Int, day: Int, currentDateInSchedule: inout Bool) {
        if let state = response["state"], state == 1 {
            if let startMonth = response["startMonth"],
                let startDay = response["startDate"],
                let endMonth = response["endMonth"],
                let endDay = response["endDate"]{
                let schedStartDate = self.convertMonthsToDays(month: startMonth, day: startDay)
                let schedEndDate = self.convertMonthsToDays(month: endMonth, day: endDay)
                let currentDay = self.convertMonthsToDays(month: month, day: day)
                
                if currentDay >= schedStartDate && currentDay <= schedEndDate {
                    currentDateInSchedule = true
                } else {
                    currentDateInSchedule = false
                }
                
            }
        }
    }
}
