//
//  ShowManager.swift
//  iPadControls
//
//  Created by Arpi Derm on 12/30/16.
//  Copyright © 2016 WET. All rights reserved.
//

import UIKit

public struct ShowPlayStat{
    
    var playMode = 0 //Options: 1 – manual , 0 – auto
    var playStatus = 0 //Options: 1 – is playing a show, 0- idle
    var currentShowNumber = 0 //Show number that is currently playing
    var deflate = "" //The moment the show started : Format :: HHMMSS
    var nextShowTime = 0 //Format :: HHMMSS
    var nextShowNumber = 0
    var showDuration = 0
    var nextShowName = ""
    var currentShowName = ""
    var showRemaining = 0
    var enableDeadMan = 0
    var servRequired = 0
    var cmdFlag = 0
    
}
public struct DeviceStat{
    
    var showStoppereStop = 0
    var showStopperwind = 0
    var showStopperwater = 0
    
    var wf1lights = 0
    var wf2lights = 0
    var wf3lights = 0
    var wf4lights = 0
    var wf5lights = 0
    var wf6lights = 0
    var lights101 = 0
    var lights102A = 0
    var lights102B = 0
    
    var pumpFault1101 = 0
    var pumpFault1102 = 0
    var pumpFault1301 = 0
    var pumpFault1302 = 0
    var pumpFault1303 = 0
    var pumpFault1401 = 0
    var pumpFault1402 = 0
    var pumpFault1501 = 0
    var pumpFault1502 = 0
    var pumpFault1503 = 0
    var pumpFault1601 = 0
    var pumpFault1602 = 0
    var pressFault1101 = 0
    var pressFault1102 = 0
    var pressFault1301 = 0
    var pressFault1302 = 0
    var pressFault1303 = 0
    var pressFault1401 = 0
    var pressFault1402 = 0
    var pressFault1501 = 0
    var pressFault1502 = 0
    var pressFault1503 = 0
    var pressFault1601 = 0
    var pressFault1602 = 0
    
    var ls1101belowLL = 0
    var ls1201belowLL = 0
    var ls1301belowLL = 0
    var ls1401belowLL = 0
    var ls1501belowLL = 0
    var ls1601belowLL = 0
    var ls1201makeupOn = 0
    var ls1201makeupTimeout = 0
    var lt1001makeupTimeout = 0
    var lt1001makeupOn = 0
    
    var ph1ChFault = 0
    var ph1AbvHi = 0
    var ph1belowL = 0
    var orp1ChFault = 0
    var orp1AbvHi = 0
    var orp1belowL = 0
    var tds1ChFault = 0
    var tds1AbvHi = 0
    var tds1belowL = 0
    var ph2ChFault = 0
    var ph2AbvHi = 0
    var ph2belowL = 0
    var orp2ChFault = 0
    var orp2AbvHi = 0
    var orp2belowL = 0
    var tds2ChFault = 0
    var tds2AbvHi = 0
    var tds2belowL = 0
    var bw1Running = 0
    var bw2Running = 0
    var pressFault1001 = 0
    var pressFault1201 = 0
    var pumpFault1001 = 0
    var pumpFault1201 = 0

    var windAbvHi = 0
    var windbelowL = 0
    var windspeedFault = 0
    var windDirectionFault = 0
    
    var fs101pumpOverload = 0
    var fs101pumpFault = 0
    var fs101pressFault = 0
    var fs102pumpOverload = 0
    var fs102pumpFault = 0
    var fs102pressFault = 0
    
    var sysWarning = 0
    var sysFault = 0
    var spmRatmode = 0
    var dayMode = 0
    var winterizeMode = 0
    var playMode = 0
    
}
public class ShowManager{
    
    private var shows: [Any]? = nil
    public var weplayData: [String] = []
    private var httpComm = HTTPComm()
    private var debug_mode = false
    private var showPlayStat = ShowPlayStat()
    private var deviceStat = DeviceStat()
    //MARK: - Get Shows From The Server
    
    public func getShowsFile(){
        
        httpComm.httpGetResponseFromPath(url: READ_SHOWS_PATH){ (response) in
            
            self.shows = response as? [Any]
            
            guard self.shows != nil else{ return }
            
            UserDefaults.standard.set(self.shows, forKey: "shows")
            
            //We want to delete all the shows from local storage before saving new ones
            self.deleteAllShowsFromLocalStorage()
            
            //Save Each Show To Local Storage
            self.saveShowsInLocalStorage()
         
        }
        
    }
    
    //MARK: - Delete All the Shows
    
    private func deleteAllShowsFromLocalStorage(){
        
        Show.deleteAll()
        
    }
    
    //MARK: - Save Shows In Local Storage
    
    private func saveShowsInLocalStorage(){
        
        for show in self.shows!{
            
            let dictionary  = show as! NSDictionary
            let duration    = dictionary.object(forKey: "duration") as? Int
            let name        = dictionary.object(forKey: "name") as? String
            let number      = dictionary.object(forKey: "number") as? Int
            
            guard duration != nil && name != nil && number != nil else{
                return
            }
            
            let show        = Show.create() as! Show
            show.duration   = Int32(duration!)
            show.number     = Int16(number!)
            show.name       = name!
            
            _ = show.save()
            
            self.logData(str:"DURATION: \(duration!) NAME: \(name!) NUMBER: \(number!)")
            
        }
    }

    
    //MARK: - Get Current and Next Playing Show
    
    public func getCurrentAndNextShowInfo() -> ShowPlayStat {
        
        httpComm.httpGetResponseFromPath(url: READ_SHOW_PLAY_STAT){ (response) in
            
            guard response != nil else { return }
            guard let responseArray = response as? [Any] else { return }
            
            if responseArray.isEmpty == false {
                guard let responseDictionary = responseArray[0] as? [String : Any] else { return }
                
                
                if  let playMode         = responseDictionary["Play Mode"] as? Int,
                    let playStatus       = responseDictionary["play status"] as? Int,
                    let currentShow      = responseDictionary["Current Show"] as? Int,
                    let deflate          = responseDictionary["deflate"] as? String,
                    let showremaining    = responseDictionary["show time remaining"] as? Int,
                    let nextShowTime     = responseDictionary["next Show Time"] as? Int,
                    let servReq          = responseDictionary["Service Required"] as? Int,
                    let nextShowNumber   = responseDictionary["next Show Num"] as? Int{
                    
                    
                    self.showPlayStat.currentShowNumber = currentShow
                    self.showPlayStat.deflate           = deflate
                    self.showPlayStat.nextShowTime      = nextShowTime
                    self.showPlayStat.nextShowNumber    = nextShowNumber
                    self.showPlayStat.playMode          = playMode
                    self.showPlayStat.playStatus        = playStatus
                    self.showPlayStat.servRequired      = servReq
                    self.showPlayStat.showRemaining = showremaining
                    
                    if let shows = Show.query(["number":self.showPlayStat.currentShowNumber]) as? [Show] {
                        if !shows.isEmpty {
                            self.showPlayStat.showDuration = Int((shows[0].duration))
                            self.showPlayStat.currentShowName = (shows[0].name!)
                        }
                    }
                    
                    
                    if let nextShows = Show.query(["number":self.showPlayStat.nextShowNumber]) as? [Show] {
                        if !nextShows.isEmpty{
                            self.showPlayStat.nextShowName = (nextShows[0].name!)
                        }
                    }
                    
                    
                    
                }
            }
        }
        
        return self.showPlayStat
        
    }
    /***************************************************************************
     * Function :  geStatusLogFromServer
     * Input    :  none
     * Output   :  none
     * Comment  :
     ***************************************************************************/
    
    public func getStatusLogFromServer() -> DeviceStat{
        
            self.httpComm.httpGetResponseFromPath(url: STATUS_LOG_FTP_PATH){ (response) in
                
                guard response != nil else { return }
                
                guard let responseArray = response as? [Any] else { return }
                if !responseArray.isEmpty{
                    let responseDictionary = responseArray[0] as? NSDictionary
                        
                        if responseDictionary != nil{
                            if  let showStoppereStop = responseDictionary!["ShowStopper :Estop"] as? Int,
                            let showStopperwind = responseDictionary!["ShowStopper :Wind_Abort"] as? Int,
                            let showStopperwater = responseDictionary!["ShowStopper :LT2001 Below LL"] as? Int,
                            
                            let pumpFault1101 = responseDictionary!["VFD 201 Pump Fault"] as? Int,
                            let pumpFault1102 = responseDictionary!["VFD 202 Pump Fault"] as? Int,
                            let pumpFault1301 = responseDictionary!["VFD 203 Pump Fault"] as? Int,
                            let pumpFault1302 = responseDictionary!["VFD 204 Pump Fault"] as? Int,
                            let pumpFault1303 = responseDictionary!["VFD 205 Pump Fault"] as? Int,
                            
                            let pressFault1101 = responseDictionary!["VFD 201 Pressure Fault"] as? Int,
                            let pressFault1102 = responseDictionary!["VFD 202 Pressure Fault"] as? Int,
                            let pressFault1301 = responseDictionary!["VFD 203 Pressure Fault"] as? Int,
                            let pressFault1302 = responseDictionary!["VFD 204 Pressure Fault"] as? Int,
                            let pressFault1303 = responseDictionary!["VFD 205 Pressure Fault"] as? Int,
                            
                            let ls1201makeupOn = responseDictionary!["LT2001 WaterMakeup On"] as? Int,
                            let ls1201makeupTimeout = responseDictionary!["LT2001 WaterMakeup Timeout"] as? Int,
                            
                            let ph1ChFault = responseDictionary!["PH ChannelFault"] as? Int,
                            let ph1AbvHi = responseDictionary!["PH Above Hi"] as? Int,
                            let ph1belowL = responseDictionary!["PH Below Low"] as? Int,
                            let orp1ChFault = responseDictionary!["ORP ChannelFault"] as? Int,
                            let orp1AbvHi = responseDictionary!["ORP Above Hi"] as? Int,
                            let orp1belowL = responseDictionary!["ORP Below Low"] as? Int,
                            let tds1ChFault = responseDictionary!["TDS ChannelFault"] as? Int,
                            let tds1AbvHi = responseDictionary!["TDS Above Hi"] as? Int,
                            let bw1Running = responseDictionary!["Backwash Running"] as? Int,
                            
                            let windAbvHi = responseDictionary!["ST2001 Above_Hi"] as? Int,
                            let windbelowL = responseDictionary!["ST2001 Above_Low"] as? Int,
                            let windspeedFault = responseDictionary!["ST2001 Speed_Channel_Fault"] as? Int,
                            let windDirectionFault = responseDictionary!["ST2001 Direction_Channel_Fault"] as? Int,
                            
                            let sysWarning = responseDictionary!["One/More System Warnings"] as? Int,
                            let sysFault = responseDictionary!["One/More System Alarms"] as? Int,
                            let spmRatmode = responseDictionary!["SPM_RAT_Mode"] as? Int,
                            let dayMode = responseDictionary!["DayMode Status"] as? Int,
                            let playMode = responseDictionary!["Show PlayMode"] as? Int{
                                
                                self.deviceStat.showStoppereStop = showStoppereStop
                                self.deviceStat.showStopperwater = showStopperwater
                                self.deviceStat.showStopperwind = showStopperwind
                                
                                
                                
                                self.deviceStat.pumpFault1101 = pumpFault1101
                                self.deviceStat.pumpFault1102 = pumpFault1102
                                self.deviceStat.pumpFault1301 = pumpFault1301
                                self.deviceStat.pumpFault1302 = pumpFault1302
                                self.deviceStat.pumpFault1303 = pumpFault1303
                               
                                self.deviceStat.pressFault1101 = pressFault1101
                                self.deviceStat.pressFault1102 = pressFault1102
                                self.deviceStat.pressFault1301 = pressFault1301
                                self.deviceStat.pressFault1302 = pressFault1302
                                self.deviceStat.pressFault1303 = pressFault1303
                                
                                self.deviceStat.ls1201makeupOn = ls1201makeupOn
                                self.deviceStat.ls1201makeupTimeout = ls1201makeupTimeout
                                
                                
                                self.deviceStat.ph1ChFault = ph1ChFault
                                self.deviceStat.ph1AbvHi = ph1AbvHi
                                self.deviceStat.ph1belowL = ph1belowL
                                self.deviceStat.orp1ChFault = orp1ChFault
                                self.deviceStat.orp1AbvHi = orp1AbvHi
                                self.deviceStat.orp1belowL = orp1belowL
                                self.deviceStat.tds1ChFault = tds1ChFault
                                self.deviceStat.tds1AbvHi = tds1AbvHi
                                
                                self.deviceStat.bw1Running = bw1Running
                                
                                
                                self.deviceStat.windAbvHi = windAbvHi
                                self.deviceStat.windbelowL = windbelowL
                                self.deviceStat.windspeedFault = windspeedFault
                                self.deviceStat.windDirectionFault = windDirectionFault

                             
                                
                                self.deviceStat.sysFault = sysFault
                                self.deviceStat.sysWarning = sysWarning
                                self.deviceStat.spmRatmode = spmRatmode
                                self.deviceStat.dayMode = dayMode
                                self.deviceStat.playMode = playMode
                              
                                
                                
                            }
                            
                        }
                        
                       
                    }
                }
                
        return self.deviceStat
    }
    //Data Logger
    
    private func logData(str:String){
        
        if debug_mode == true{
            
            print(str)
            
        }
        
    }
    
}

