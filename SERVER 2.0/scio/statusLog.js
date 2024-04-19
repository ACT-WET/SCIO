
function statusLogWrapper(){

    //console.log("StatusLog script triggered");

    var totalStatus;
    var data = [];
    var status_filter = [];
    var status_windSensor = [];
    var status_pressTransmitter = [];
    var fault_PUMPS = [];
    var status_WaterLevel = [];
    var status_WaterQuality = [];
    var status_LIGHTS = [];
    var fault_ESTOP = [];
    var fault_INTRUSION = [];
    var fault_FOG = [];
    var status_AirPressure = [];
    var status_Ethernet = [];
    var fault_ShowStoppers = [];
    var status_GasPressure = [];

    
if (PLCConnected){

     plc_client.readHoldingRegister(1006,57,function(resp){
      if (resp != undefined && resp != null){
        
        //P201
        if(checkUpdatedValue(vfd1_faultCode[0],resp.register[0],201)){
           vfd1_faultCode[0] = resp.register[0];
        }

        //P202
        if(checkUpdatedValue(vfd1_faultCode[1],resp.register[14],202)){
           vfd1_faultCode[1] = resp.register[14];
        }

        //P203
        if(checkUpdatedValue(vfd1_faultCode[2],resp.register[28],203)){
           vfd1_faultCode[2] = resp.register[28];
        }

        //P204
        if(checkUpdatedValue(vfd1_faultCode[3],resp.register[42],204)){
           vfd1_faultCode[3] = resp.register[42];
        }

        //P205
        if(checkUpdatedValue(vfd1_faultCode[4],resp.register[56],205)){
           vfd1_faultCode[4] = resp.register[56];
        }
      }      
    });

    plc_client.readCoils(3520,1,function(resp){

        if (resp != undefined && resp != null){
            //Disable Lights Group - scio - 1
            status_LIGHTS.push(resp.coils[0] ? resp.coils[0] : 0); //Reflecting Pool Lights
            
        }
    });//end of first PLC modbus call

    plc_client.readCoils(0,9,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
            // Show Stoppers - atho
            fault_ShowStoppers.push(resp1.coils[5] ? resp1.coils[5] : 0); // System Estop
            fault_ShowStoppers.push(resp1.coils[6] ? resp1.coils[6] : 0); // ST2001 Abort
            fault_ShowStoppers.push(resp1.coils[7] ? resp1.coils[7] : 0); // LT2001 Below LL 
            fault_ShowStoppers.push(resp1.coils[8] ? resp1.coils[8] : 0); // LS2201 Overflow Abort
            fault_ShowStoppers.push(resp1.coils[8] ? resp1.coils[8] : 0); // LS2301 Overflow Abort
        }
    });//end of first PLC modbus call  

    plc_client.readHoldingRegister(70,6,function(resp){
      if (resp != undefined && resp != null){
        
        //Estop
        fault_ESTOP.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0); // ACP201 Estop
        fault_ESTOP.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0); // MCC201 Estop

        fault_ESTOP.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0); // One/More System Warning Alarm 
        fault_ESTOP.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0); // One/More System Fault Alarm 

        fault_ESTOP.push(nthBit(resp.register[0],8) ? nthBit(resp.register[0],8) : 0); //RAT Mode
        fault_ESTOP.push(nthBit(resp.register[0],9) ? nthBit(resp.register[0],9) : 0); //Show Playing

        //WaterQuality
        status_WaterQuality.push(nthBit(resp.register[1],0) ? nthBit(resp.register[1],0) : 0);   // PH Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],1) ? nthBit(resp.register[1],1) : 0);   // PH Below Low
        status_WaterQuality.push(nthBit(resp.register[1],2) ? nthBit(resp.register[1],2) : 0);   // ORP Above Hi 
        status_WaterQuality.push(nthBit(resp.register[1],3) ? nthBit(resp.register[1],3) : 0);   // ORP Below Low
        status_WaterQuality.push(nthBit(resp.register[1],4) ? nthBit(resp.register[1],4) : 0);   // TDS Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],5) ? nthBit(resp.register[1],5) : 0);   // pH Channel Fault
        status_WaterQuality.push(nthBit(resp.register[1],6) ? nthBit(resp.register[1],6) : 0);   // ORP Channel Fault
        status_WaterQuality.push(nthBit(resp.register[1],7) ? nthBit(resp.register[1],7) : 0);   // TDS Channel Fault
        status_WaterQuality.push(nthBit(resp.register[1],8) ? nthBit(resp.register[1],8) : 0);   // Br Dosing Active
        status_WaterQuality.push(nthBit(resp.register[1],9) ? nthBit(resp.register[1],9) : 0);   // Br Dosing Timeout

        //Wind
        status_windSensor.push(nthBit(resp.register[2],0) ? nthBit(resp.register[2],0) : 0); // ST2001_Abort Show
        status_windSensor.push(nthBit(resp.register[2],1) ? nthBit(resp.register[2],1) : 0); // ST2001_Above_Hi
        status_windSensor.push(nthBit(resp.register[2],2) ? nthBit(resp.register[2],2) : 0); // ST2001_Above_Medium
        status_windSensor.push(nthBit(resp.register[2],3) ? nthBit(resp.register[2],3) : 0); // ST2001_Above_Low
        status_windSensor.push(nthBit(resp.register[2],4) ? nthBit(resp.register[2],4) : 0); // ST2001_No_Wind
        status_windSensor.push(nthBit(resp.register[2],6) ? nthBit(resp.register[2],6) : 0); // ST2001_Speed_Channel_Fault
        status_windSensor.push(nthBit(resp.register[2],7) ? nthBit(resp.register[2],7) : 0); // ST2001_Drctn_Channel_Fault 

        windHi = status_windSensor[1];
        windMed = status_windSensor[2];
        windLo = status_windSensor[3];
        windNo = status_windSensor[4];

        //Pumps
        fault_PUMPS.push(nthBit(resp.register[2],10) ? nthBit(resp.register[2],10) : 0); // VFD 201 StrainerWarning (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[2],11) ? nthBit(resp.register[2],11) : 0); // VFD 202 StrainerWarning (Refelcting Pool Pump)
        fault_PUMPS.push(nthBit(resp.register[2],12) ? nthBit(resp.register[2],12) : 0); // VFD 203 StrainerWarning (Level 2 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[2],13) ? nthBit(resp.register[2],13) : 0); // VFD 204 StrainerWarning (Level 3 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[2],14) ? nthBit(resp.register[2],14) : 0); // VFD 205 StrainerWarning (Level 4 Pendant Dropper Pump)

        fault_PUMPS.push(nthBit(resp.register[3],0) ? nthBit(resp.register[3],0) : 0); // VFD 201 PressureFault (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[3],1) ? nthBit(resp.register[3],1) : 0); // VFD 202 PressureFault (Refelcting Pool Pump)
        fault_PUMPS.push(nthBit(resp.register[3],2) ? nthBit(resp.register[3],2) : 0); // VFD 203 PressureFault (Level 2 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],3) ? nthBit(resp.register[3],3) : 0); // VFD 204 PressureFault (Level 3 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],4) ? nthBit(resp.register[3],4) : 0); // VFD 205 PressureFault (Level 4 Pendant Dropper Pump)

        fault_PUMPS.push(nthBit(resp.register[3],6) ? nthBit(resp.register[3],6) : 0);      // VFD 201 PumpFault (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[3],7) ? nthBit(resp.register[3],7) : 0);      // VFD 202 PumpFault (Refelcting Pool Pump)
        fault_PUMPS.push(nthBit(resp.register[3],8) ? nthBit(resp.register[3],8) : 0);      // VFD 203 PumpFault (Level 2 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],9) ? nthBit(resp.register[3],9) : 0);      // VFD 204 PumpFault (Level 3 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],10) ? nthBit(resp.register[3],10) : 0);    // VFD 205 PumpFault (Level 4 Pendant Dropper Pump)

        //WaterLevel 
        status_WaterLevel.push(nthBit(resp.register[4],0) ? nthBit(resp.register[4],0) : 0);   // Refelcting Pool Below LL
        status_WaterLevel.push(nthBit(resp.register[4],1) ? nthBit(resp.register[4],1) : 0);   // Level 2 Water OverFlow
        status_WaterLevel.push(nthBit(resp.register[4],2) ? nthBit(resp.register[4],2) : 0);   // Level 2 Water OverFlow Alarm
        status_WaterLevel.push(nthBit(resp.register[4],3) ? nthBit(resp.register[4],3) : 0);   // Level 3 Water OverFlow
        status_WaterLevel.push(nthBit(resp.register[4],4) ? nthBit(resp.register[4],4) : 0);   // Level 3 Water OverFlow Alarm
        status_WaterLevel.push(nthBit(resp.register[4],6) ? nthBit(resp.register[4],6) : 0);   // LT2001 Above Hi Hi
        status_WaterLevel.push(nthBit(resp.register[4],7) ? nthBit(resp.register[4],7) : 0);   // LT2001 Above Hi
        status_WaterLevel.push(nthBit(resp.register[4],8) ? nthBit(resp.register[4],8) : 0);   // LT2001 Below L
        status_WaterLevel.push(nthBit(resp.register[4],9) ? nthBit(resp.register[4],9) : 0);   // LT2001 Below LL
        status_WaterLevel.push(nthBit(resp.register[4],10) ? nthBit(resp.register[4],10) : 0);   // LT2001 Sensor Fault
        status_WaterLevel.push(nthBit(resp.register[4],12) ? nthBit(resp.register[4],12) : 0);   // LT2001 WaterMakeup Active
        status_WaterLevel.push(nthBit(resp.register[4],13) ? nthBit(resp.register[4],13) : 0);   // LT2001 WaterMakeup Timeout

        //filtration
        status_filter.push(nthBit(resp.register[5],0) ? nthBit(resp.register[5],0) : 0);   // Scheduled Backwash Trigger
        status_filter.push(nthBit(resp.register[5],1) ? nthBit(resp.register[5],1) : 0);   // Backwash Running
        status_filter.push(nthBit(resp.register[5],2) ? nthBit(resp.register[5],2) : 0);   // PDSH Trigger
        status_filter.push(nthBit(resp.register[5],4) ? nthBit(resp.register[5],4) : 0);   // PT1001 Channel Fault 
        status_filter.push(nthBit(resp.register[5],5) ? nthBit(resp.register[5],5) : 0);   // PT1002 Channel Fault 
        status_filter.push(nthBit(resp.register[5],6) ? nthBit(resp.register[5],6) : 0);   // PT1003 Channel Fault 
        
        
        showStopper = 0;
            for (var i=0; i <= (fault_ShowStoppers.length-1); i++){
                showStopper = showStopper + fault_ShowStoppers[i];
                // if(serviceRequired === 1){
                //    showStopper = 1; 
                //    watchDog.eventLog("ShowStopper:: Service Required 1");
                // }
            }   

            totalStatus = [ 
                            fault_ShowStoppers,
                            fault_ESTOP,
                            status_WaterQuality,
                            status_windSensor,
                            fault_PUMPS,
                            status_WaterLevel,
                            status_filter,
                            status_LIGHTS];

            totalStatus = bool2int(totalStatus);

            if (devStatus.length > 1) {
                logChanges(totalStatus); // detects change of total status
            }

            devStatus = totalStatus; // makes the total status equal to the current error state

            // creates the status array that is sent to the iPad (via errorLog) AND logged to file
            sysStatus = [{
                            "***************************ESTOP STATUS**************************" : "1",
                            "ACP-201 ESTOP": fault_ESTOP[0],
                            "MCC-201 ESTOP": fault_ESTOP[1],
                            "One/More System Warnings": fault_ESTOP[2],
                            "One/More System Alarms": fault_ESTOP[3],
                            "SPM RAT MODE : PLC": fault_ESTOP[4],
                            "Show Playing : PLC": fault_ESTOP[5],
                            "ShowStopper :Estop": fault_ShowStoppers[0],
                            "ShowStopper :Wind_Abort": fault_ShowStoppers[1],
                            "ShowStopper :LT2001 Below LL": fault_ShowStoppers[2],
                            "ShowStopper :LS2201 OverFlow": fault_ShowStoppers[3],
                            "ShowStopper :LS2301 OverFlow": fault_ShowStoppers[4],
                            "***************************SHOW STATUS***************************" : "2",
                            "Show PlayMode": autoMan,
                            "Show PlayStatus":playing,
                            "CurrentShow Number":show,
                            "deflate":deflate,
                            "NextShowTime": nxtTime,
                            "NextShowNumber": nxtShow,
                            "timeLastCmnd": timeLastCmnd,
                            "SPM_RAT_Mode":Boolean(spmRATMode),
                            "JumpToStepAuto": jumpToStep_auto,
                            "JumpToStepManual": jumpToStep_manual,
                            "DayMode Status":dayModeStatus,
                            "****************************WATER QUALITY STATUS*****************" : "3",
                            "PH Above Hi": status_WaterQuality[0],
                            "PH Below Low": status_WaterQuality[1],
                            "ORP Above Hi": status_WaterQuality[2],
                            "ORP Below Low": status_WaterQuality[3],
                            "TDS Above Hi": status_WaterQuality[4],
                            "PH ChannelFault": status_WaterQuality[5],
                            "ORP ChannelFault": status_WaterQuality[6],
                            "TDS ChannelFault": status_WaterQuality[7],
                            "Bromine Dosing Active": status_WaterQuality[8],
                            "Bromine Dosing Timeout": status_WaterQuality[9],
                            "****************************WIND STATUS********************" : "4",   
                            "ST2001 Abort_Show": status_windSensor[0],
                            "ST2001 Above_Hi": status_windSensor[1],
                            "ST2001 Above_Med": status_windSensor[2],
                            "ST2001 Above_Low": status_windSensor[3],
                            "ST2001 No_Wind": status_windSensor[4],
                            "ST2001 Speed_Channel_Fault": status_windSensor[5],
                            "ST2001 Direction_Channel_Fault": status_windSensor[6],
                            "***************************PUMPS STATUS**************************" : "5",
                            "VFD 201 Fault Code":vfd1_faultCode[0],
                            "VFD 202 Fault Code":vfd1_faultCode[1],
                            "VFD 203 Fault Code":vfd1_faultCode[2],
                            "VFD 204 Fault Code":vfd1_faultCode[3],
                            "VFD 205 Fault Code":vfd1_faultCode[4],
                            "VFD 201 Strainer Warning":fault_PUMPS[0],
                            "VFD 202 Strainer Warning":fault_PUMPS[1],
                            "VFD 203 Strainer Warning":fault_PUMPS[2],
                            "VFD 204 Strainer Warning":fault_PUMPS[3],
                            "VFD 205 Strainer Warning":fault_PUMPS[4],
                            "VFD 201 Pressure Fault":fault_PUMPS[5],
                            "VFD 202 Pressure Fault":fault_PUMPS[6],
                            "VFD 203 Pressure Fault":fault_PUMPS[7],
                            "VFD 204 Pressure Fault":fault_PUMPS[8],
                            "VFD 205 Pressure Fault":fault_PUMPS[9],
                            "VFD 201 Pump Fault":fault_PUMPS[10],
                            "VFD 202 Pump Fault":fault_PUMPS[11],
                            "VFD 203 Pump Fault":fault_PUMPS[12],
                            "VFD 204 Pump Fault":fault_PUMPS[13],
                            "VFD 205 Pump Fault":fault_PUMPS[14],
                            "****************************WATERLEVEL STATUS********************" : "6",
                            "Reflecting Pool Below LL":status_WaterLevel[0],
                            "Level 2 Water OverFlow":status_WaterLevel[1],
                            "Level 2 Water OverFlow Alarm":status_WaterLevel[2],
                            "Level 3 Water OverFlow":status_WaterLevel[3],
                            "Level 3 Water OverFlow Alarm":status_WaterLevel[4],
                            "LT2001 Above_Hi":status_WaterLevel[5],
                            "LT2001 Below_Low":status_WaterLevel[6],
                            "LT2001 Below_LowLow":status_WaterLevel[7],
                            "LT2001 Below_LowLowLow":status_WaterLevel[8],
                            "LT2001 ChannelFault":status_WaterLevel[9],
                            "LT2001 WaterMakeup On":status_WaterLevel[10],
                            "LT2001 WaterMakeup Timeout":status_WaterLevel[11],
                            "Refelcting Pool Disable Lights": status_LIGHTS[0],
                            "***************************FILLTRATION STATUS**************************" : "7",
                            "Scheduled Backwash Trigger":status_filter[0],
                            "Backwash Running":status_filter[1],
                            "PDSH Trigger":status_filter[2],
                            "PT1001 Channel Fault":status_filter[3],
                            "PT1002 Channel Fault":status_filter[4],
                            "PT1003 Channel Fault":status_filter[5],
                            "****************************DEVICE CONNECTION STATUS*************" : "8",
                            "SPM_Heartbeat": SPM_Heartbeat,
                            "SPM_Modbus_Connection": SPMConnected,
                            "PLC_Heartbeat": PLC_Heartbeat,
                            "PLC_Modbus _Connection": PLCConnected,
                            }];

            playStatus = [{
                            "Play Mode": autoMan,
                            "play status":playing,
                            "Current Show":show,
                            "Current Show Name": shows[show].name,
                            "Current Show Duration":shows[show].duration,
                            "Show Type":showType,
                            "deflate":deflate,
                            "show time remaining": showTime_remaining,
                            "Service Required": serviceRequired,
                            "next Show Time": nxtTime,
                            "next Show Num": nxtShow,
                            "canSendCmd": cmdFlag
                            }];
                            
            playMode_init = {"autoMan":autoMan};

            fs.writeFileSync(homeD+'/UserFiles/playMode.txt',JSON.stringify(playMode_init),'utf-8');
            fs.writeFileSync(homeD+'/UserFiles/playModeBkp.txt',JSON.stringify(playMode_init),'utf-8');
      }      
    });
}
var date = new Date();
// if(((date.getMonth() > 5) && (date.getDate() > 21)) || (date.getMonth() > 6)){
//     serviceRequired = 1;
//     plc_client.writeSingleCoil(2,1,function(resp){});
// } else {
//     serviceRequired = 0;
//     plc_client.writeSingleCoil(2,0,function(resp){});
// }

if (SPMConnected){

     // plc_client.readCoils(3,1,function(resp){
     //    var m3Bit = resp.coils[0];
     //    watchDog.eventLog('Read PLC M3 value: '+m3Bit);
     // });

     // spm_client.readHoldingRegister(3052,5,function(resp){

     // //     // Fire Spire data
     // //     watchDog.eventLog("Fire 401: Value: "  +intByte_HiLo(resp.register[0])[0]);    // Fire Spire - 401
     // //     watchDog.eventLog("Fire 402: Value: "  +intByte_HiLo(resp.register[0])[1]);    // Fire Spire - 402
     // //     watchDog.eventLog("Fire 403: Value: "  +intByte_HiLo(resp.register[1])[0]);    // Fire Spire - 403
     // //     watchDog.eventLog("Fire 404: Value: "  +intByte_HiLo(resp.register[1])[1]);    // Fire Spire - 404
     // //     watchDog.eventLog("Fire 405: Value: "  +intByte_HiLo(resp.register[2])[0]);    // Fire Spire - 405
     // //     watchDog.eventLog("Fire 406: Value: "  +intByte_HiLo(resp.register[2])[1]);    // Fire Spire - 406
     // //     watchDog.eventLog("P:107 Value: "  +intByte_HiLo(resp.register[0])[0]);        // P-107
     // //     watchDog.eventLog("P:207 Value: "  +intByte_HiLo(resp.register[0])[1]);        // P-207
     // //     watchDog.eventLog("P:307 Value: "  +intByte_HiLo(resp.register[1])[0]);        // P-307

     // });

    if(autoMan===1){
       plc_client.writeSingleCoil(4,1,function(resp){});
    }
    else{
      plc_client.writeSingleCoil(4,0,function(resp){});
    }

}

    // compares current state to previous state to log differences
    function logChanges(currentState){
        // {"yes":"n/a","no":"n/a"} object template for detection but no logging... "n/a" disables log
        // {"yes":"positive edge message","no":"negative edge message"} object template for detection and logging
        // pattern of statements must match devStatus and totalStatus format
        var statements=[

            [   // Show Stopper - scio
                {"yes":"Show Stopper: Estop","no":"Show Stopper Resolved: Estop"},
                {"yes":"Show Stopper: ST2001 Wind_Speed_Abort_Show","no":"Show Stopper Resolved: Wind_Speed_Abort_Show"},
                {"yes":"Show Stopper: LT2001 Water Level Below LL","no":"Show Stopper Resolved: Water Level"},
                {"yes":"Show Stopper: LS2201 Water Level Below LL","no":"Show Stopper Resolved: Water Level"},
                {"yes":"Show Stopper: LS2301 Water Level Below LL","no":"Show Stopper Resolved: Water Level"},  
            ],

            [   // estop - scio 
                {"yes":"ACP201 Estop Triggered","no":"Resolved: ACP201 Estop"}, 
                {"yes":"MCC201 Estop Triggered","no":"Resolved: MCC201 Estop"}, 
                {"yes":"One/More System Warnings","no":"Resolved: No System Warnings"}, 
                {"yes":"One/More System Faults","no":"Resolved: No System Faults"}, 
                {"yes":"SPM: In RAT Mode","no":"SPM: Not in RAT Mode"}, 
                {"yes":"Show Playing Bit ON","no":"Show Playing Bit OFF"}, 
            ],

            [   //Water Quality Status - scio
                
                
                {"yes":"PH AboveHi","no":"Resolved: PH Above Hi Alarm "},
                {"yes":"PH Below_Low","no":"Resolved: PH Below Low Alarm "},
                {"yes":"ORP AboveHi","no":"Resolved: ORP Above Hi Alarm "},
                {"yes":"ORP Below_Low","no":"Resolved: ORP Below Low Alarm "},
                {"yes":"TDS AboveHi","no":"Resolved: TDS Above Hi Alarm "},
                {"yes":"PH Channel Fault","no":"Resolved: PH Channel Fault"},
                {"yes":"ORP Channel Fault","no":"Resolved: ORP Channel Fault"},
                {"yes":"TDS Channel Fault","no":"Resolved: TDS Channel Fault"},
                {"yes":"Broming Dosing Active","no":"Broming Dosing Inactive"},
                {"yes":"Broming Dosing Timeout","no":"Resolved : Broming Dosing Timeout"},
                
            ],

            [   // anemometer - scio

                {"yes":"ST2001 AbortShow","no":"ST2001 AbortShow Resolved"},
                {"yes":"ST2001 Wind Speed Above Hi","no":"ST2001 Wind Above Hi Resolved"},
                {"yes":"ST2001 Wind Speed Above Med","no":"ST2001 Wind Above Med Resolved"},
                {"yes":"ST2001 Wind Speed Above Low","no":"ST2001 Wind Above Low Resolved"},
                {"yes":"ST2001 Wind Speed NoWind","no":"ST2001 Wind Speed Not in NoWind"},
                {"yes":"ST2001 Speed_Channel_Fault","no":"ST2001 Speed_Channel_Fault Resolved"},
                {"yes":"ST2001 Direction_Channel_Fault","no":"ST2001 Direction_Channel_Fault Resolved"},
                
            ],

            [   // pumps - scio
                
                {"yes":"P201 Strainer Warning","no":"Resolved: P201 Strainer Warning"},
                {"yes":"P202 Strainer Warning","no":"Resolved: P202 Strainer Warning"}, 
                {"yes":"P203 Strainer Warning","no":"Resolved: P203 Strainer Warning"}, 
                {"yes":"P204 Strainer Warning","no":"Resolved: P204 Strainer Warning"},  
                {"yes":"P205 Strainer Warning","no":"Resolved: P205 Strainer Warning"},
                {"yes":"P201 Pressure Fault","no":"Resolved: P201 Pressure Fault"},
                {"yes":"P202 Pressure Fault","no":"Resolved: P202 Pressure Fault"}, 
                {"yes":"P203 Pressure Fault","no":"Resolved: P203 Pressure Fault"}, 
                {"yes":"P204 Pressure Fault","no":"Resolved: P204 Pressure Fault"},  
                {"yes":"P205 Pressure Fault","no":"Resolved: P205 Pressure Fault"}, 
                {"yes":"P201 Pump Fault","no":"Resolved: P201 Pump Fault"},
                {"yes":"P202 Pump Fault","no":"Resolved: P202 Pump Fault"}, 
                {"yes":"P203 Pump Fault","no":"Resolved: P203 Pump Fault"}, 
                {"yes":"P204 Pump Fault","no":"Resolved: P204 Pump Fault"},  
                {"yes":"P205 Pump Fault","no":"Resolved: P205 Pump Fault"},   
                    
            ],

            [   // water level - scio
                
                {"yes":"Reflecting Pool Below LL","no":"Resolved: Reflecting Pool Below LL"},
                {"yes":"Level 2 WaterOverFlow","no":"Resolved: Level 2 WaterOverFlow"},
                {"yes":"Level 2 WaterOverFlow Alarm","no":"Reset Level 2 WaterOverFlow"},
                {"yes":"Level 3 WaterOverFlow","no":"Resolved: Level 3 WaterOverFlow"},
                {"yes":"Level 3 WaterOverFlow Alarm","no":"Reset Level 3 WaterOverFlow"},
                {"yes":"LT2001 AboveHiHi","no":"Resolved: LT2001 WaterLevel Resolved"},
                {"yes":"LT2001 AboveHi","no":"Resolved: LT2001 WaterLevel Resolved"},
                {"yes":"LT2001 Below_Low","no":"Resolved: LT2001 WaterLevel Resolved"},
                {"yes":"LT2001 Below_LowLow","no":"Resolved: LT2001 WaterLevel Resolved"},
                {"yes":"LT2001 Channel Fault","no":"Resolved: LT2001 Channel Fault Resolved"},
                {"yes":"WaterMakeup On","no":"WaterMakeup Off"},
                {"yes":"WaterMakeup Timeout","no":"Resolved: WaterMakeup Timeout"},
                
            ],

            [   // filtration - scio
                
                {"yes":"Scheduled Backwash Trigger ON","no":"Scheduled Backwash Trigger OFF"},
                {"yes":"Backwash Running","no":"Backwash Not Running"},
                {"yes":"PDSH Trigger ON","no":"PDSH Trigger OFF"},
                {"yes":"PT1001 Channel Fault","no":"Resolved: PT1001 Channel Fault"},
                {"yes":"PT1002 Channel Fault","no":"Resolved: PT1002 Channel Fault"},
                {"yes":"PT1003 Channel Fault","no":"Resolved: PT1003 Channel Fault"},
            ],

            [   // lights - scio
                {"yes":"Reflecting Pool Disable Lights","no":"Resolved:Reflecting Pool Disable Lights"},
            ]
        ];
        
        if (devStatus.length > 0) {
            for(var each in currentState){
                // find all indeces with values different from previous examination
                var suspects = kompare(currentState[each],devStatus[each]);
                for(var each2 in suspects){
                    var text = (currentState[each][suspects[each2]]) ? statements[each][suspects[each2]].yes:statements[each][suspects[each2]].no;
                    var description = "";
                    var message = "";
                    var category = "";
                    if(text !== "n/a"){
                        //watchDog.eventLog('each: ' +each +' and each2: ' +each2+' and suspcts: ' +suspects);
                        watchDog.eventLog(text);
                        watchLog.eventLog(text);
                    }

                    if (text == "Reflecting Pool Disable Lights"){
                        spmReq.sendPacketstoSPM(1,3);//id(3) = AddMsg
                        setTimeout(function(){
                            spmReq.sendPacketstoSPM(1,3);//id(3) = AddMsg
                        },1000);
                    } else if (text == "Resolved:Reflecting Pool Disable Lights") {
                        spmReq.sendPacketstoSPM(1,5);//id(5) = DisableMsg
                        setTimeout(function(){
                            spmReq.sendPacketstoSPM(1,5);//id(5) = DisableMsg
                        },1000);
                    }
                }
            }
        }

    }

    // returns the value of the bth bit of n
    function nthBit(n,b){
        var here = 1 << b;
        if (here & n){
            return 1;
        }
        return 0;
    }

    function intByte_HiLo(query){
        var loByte = 0;
        for(var i = 0; i < 8; i++){
            loByte = loByte + (nthBit(query,i)* Math.pow(2, i));
        }
        var hiByte = 0;
        for(var i = 8; i < 16; i++){
            hiByte = hiByte + (nthBit(query,i)* Math.pow(2, i-8));
        }
        var byte_arr = [];
        byte_arr[0] = loByte;
        byte_arr[1] = hiByte;
        return byte_arr;
    }

    //check and execute only once
    function checkUpdatedValue(oldValue,newValue,pumpNumber){
        // watchDog.eventLog("oldValue  :::   "+oldValue);
        // watchDog.eventLog("newValue  :::   "+newValue);
        if(newValue==oldValue){
            return 0;
        } else {
            vfdCode.vfdFaultCodeAnalyzer(pumpNumber,newValue);
            return 1;
        }
    }

    //check and execute only once
    function printForUpdatedValue(oldValue,newValue){
        // watchDog.eventLog("oldValue  :::   "+oldValue);
        // watchDog.eventLog("newValue  :::   "+newValue);
        if(newValue==oldValue){
            return 0;
        } else {
            return 1;
        }
    }

    function checkUpdatedMirrPosValue(oldValue,newValue){
        // watchDog.eventLog("oldValue  :::   "+oldValue);
        // watchDog.eventLog("newValue  :::   "+newValue);
        if(newValue==oldValue){
            return 0;
        } else {
            return 1;
        }
    }

    // converts up to 11-bit binary (including 0 bit) to decimal
    function oddByte(fruit){
        var min=0;
        for (k=0;k<11;k++){
            if(nthBit(fruit,k)){min+=Math.pow(2,k);}
        }
        return min;
    }

    // general function that will help DEEP compare arrays
    function kompare (array1,array2) {
        var collisions = [];

        for (var i = 0, l=array1.length; i < l; i++) {
            // Check if we have nested arrays
            if (array1[i] instanceof Array && array2[i] instanceof Array) {
                // recurse into the nested arrays
                if (!kompare(array1[i],array2[i])){
                    return [false];
                }
            }
            else if (array1[i] !== array2[i]) {
                // Warning - two different object instances will never be equal: {x:20} != {x:20}
                collisions.push(i);
            }
        }

        return collisions;
    }

    // convert boolean to int
    function bool2int(array){
        for (var each in array) {
            // Check if we have nested arrays
            if (array[each] instanceof Array) {
                // recurse into the nested arrays
                array[each] = bool2int(array[each]);
            }
            else {
                // Warning - two different object instances will never be equal: {x:20} != {x:20}
                array[each] = (array[each]) ? 1 : 0;
            }
        }
        return array;
    }
}

module.exports=statusLogWrapper;
