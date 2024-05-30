
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
    var fault_ESTOP = [];
    var fault_INTRUSION = [];
    var fault_FOG = [];
    var status_AirPressure = [];
    var status_Ethernet = [];
    var status_WarningFaults = [];
    var fault_ShowStoppers = [];
    var status_DcPower = [];

    
if (PLCConnected){

    plc_client.readHoldingRegister(50,1,function(resp){
        
        if (resp != undefined && resp != null){  
            // Show Stoppers - atho
            fault_ESTOP.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0); // CP-101 Estop
            fault_ESTOP.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0); // DCP-101 Estop
            fault_ESTOP.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0); // DCP-102 Estop
            fault_ESTOP.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0); // DCP-103 Estop
            fault_ESTOP.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0); // DCP-104 Estop
            fault_ESTOP.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0); // DCP-105 Estop
            fault_ESTOP.push(nthBit(resp.register[0],6) ? nthBit(resp.register[0],6) : 0); // MCC-101 Estop
            fault_ESTOP.push(nthBit(resp.register[0],7) ? nthBit(resp.register[0],7) : 0); // MCC-102 Estop
        }
    });//end of first PLC modbus call  

    plc_client.readHoldingRegister(55,1,function(resp){
        
        if (resp != undefined && resp != null){  
            // Show Stoppers - atho
            fault_ShowStoppers.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0); // ShowStopper Estop Active
            fault_ShowStoppers.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0); // ShowStopper Basin WaterLevel LL
            fault_ShowStoppers.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0); // ShowStopper High Wind Abort
            fault_ShowStoppers.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0); // ShowStopper VFD101 Not Running
        }
    });//end of first PLC modbus call  

    plc_client.readHoldingRegister(60,1,function(resp){
        
        if (resp != undefined && resp != null){  
            // Show Stoppers - atho
            status_Ethernet.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0);   // VFD-101 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0);   // VFD-103 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0);   // VFD-104 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0);   // VFD-105 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0);   // VFD-106 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],6) ? nthBit(resp.register[0],6) : 0);   // VFD-107 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],7) ? nthBit(resp.register[0],7) : 0);   // VFD-108 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],8) ? nthBit(resp.register[0],8) : 0);   // VFD-109 Communication OK
            status_Ethernet.push(nthBit(resp.register[0],9) ? nthBit(resp.register[0],9) : 0);   // MCC-102 REMIO Communication OK
            status_Ethernet.push(nthBit(resp.register[0],10) ? nthBit(resp.register[0],10) : 0); // MCC-102 GFCI Communication OK
            status_Ethernet.push(nthBit(resp.register[0],11) ? nthBit(resp.register[0],11) : 0); // Water Quality Communication OK
            status_Ethernet.push(nthBit(resp.register[0],12) ? nthBit(resp.register[0],12) : 0); // Weather Station Communication OK
        }
    });//end of first PLC modbus call 

    plc_client.readHoldingRegister(65,1,function(resp){
        
        if (resp != undefined && resp != null){  
            // Show Stoppers - atho
            status_WarningFaults.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0);   // WaterQuality Warning
            status_WarningFaults.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0);   // Basin LL WaterLevel Warning
            status_WarningFaults.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0);   // Weather Station Warning
            status_WarningFaults.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0);   // CleanStrainer Warning
            status_WarningFaults.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0);   // VFD/Pump Warning
            status_WarningFaults.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0);   // DC Power Warning
        }
    });//end of first PLC modbus call 

    plc_client.readHoldingRegister(70,1,function(resp){
        
        if (resp != undefined && resp != null){  
            // Show Stoppers - atho
            status_WarningFaults.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0);   // Estop Fault
            status_WarningFaults.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0);   // Network Fault 
            status_WarningFaults.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0);   // Water Qulaity Fault
            status_WarningFaults.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0);   // Water Level Fault
            status_WarningFaults.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0);   // Basin Below LLL Fault
            status_WarningFaults.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0);   // Weather Station Fault
            status_WarningFaults.push(nthBit(resp.register[0],6) ? nthBit(resp.register[0],6) : 0);   // Low Pressure Fault
            status_WarningFaults.push(nthBit(resp.register[0],7) ? nthBit(resp.register[0],7) : 0);   // Pump Fault
            status_WarningFaults.push(nthBit(resp.register[0],8) ? nthBit(resp.register[0],8) : 0);   // Fog Fault
            status_WarningFaults.push(nthBit(resp.register[0],9) ? nthBit(resp.register[0],9) : 0);   // DC Power Fault
        }
    });//end of first PLC modbus call 

    plc_client.readHoldingRegister(75,12,function(resp){
      if (resp != undefined && resp != null){
        
        //System Status
        fault_ESTOP.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0);   // Show Stop Active
        fault_ESTOP.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0);   // System Normal State
        fault_ESTOP.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0);   // System Warning State
        fault_ESTOP.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0);   // System Fault State
        fault_ESTOP.push(nthBit(resp.register[0],12) ? nthBit(resp.register[0],12) : 0); // BMS Warning Output
        fault_ESTOP.push(nthBit(resp.register[0],13) ? nthBit(resp.register[0],13) : 0); // BMS Fault Output

        //WaterQuality
        status_WaterQuality.push(nthBit(resp.register[1],0) ? nthBit(resp.register[1],0) : 0);     // PH Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],1) ? nthBit(resp.register[1],1) : 0);     // PH Below Low
        status_WaterQuality.push(nthBit(resp.register[1],2) ? nthBit(resp.register[1],2) : 0);     // ORP Above Hi 
        status_WaterQuality.push(nthBit(resp.register[1],3) ? nthBit(resp.register[1],3) : 0);     // ORP Below Low
        status_WaterQuality.push(nthBit(resp.register[1],4) ? nthBit(resp.register[1],4) : 0);     // Conductivity Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],5) ? nthBit(resp.register[1],5) : 0);     // Conductivity Below Low
        status_WaterQuality.push(nthBit(resp.register[1],6) ? nthBit(resp.register[1],6) : 0);     // Bromine Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],7) ? nthBit(resp.register[1],7) : 0);     // Bromine Below Low
        status_WaterQuality.push(nthBit(resp.register[1],8) ? nthBit(resp.register[1],8) : 0);     // Filtration Temp Above Hi
        status_WaterQuality.push(nthBit(resp.register[1],9) ? nthBit(resp.register[1],9) : 0);     // Filtration Temp Below Low
        status_WaterQuality.push(nthBit(resp.register[1],10) ? nthBit(resp.register[1],10) : 0);   // Basin Return Temp Below Low
        status_WaterQuality.push(nthBit(resp.register[1],11) ? nthBit(resp.register[1],11) : 0);   // Basin Temp Below Low
        status_WaterQuality.push(nthBit(resp.register[1],12) ? nthBit(resp.register[1],12) : 0);   // Bromine Timeout

        status_WaterQuality.push(nthBit(resp.register[2],0) ? nthBit(resp.register[2],0) : 0);     // MW104 DCM512 Communication Fault
        status_WaterQuality.push(nthBit(resp.register[2],1) ? nthBit(resp.register[2],1) : 0);     // PH Sensor Fault
        status_WaterQuality.push(nthBit(resp.register[2],2) ? nthBit(resp.register[2],2) : 0);     // ORP Sensor Fault 
        status_WaterQuality.push(nthBit(resp.register[2],3) ? nthBit(resp.register[2],3) : 0);     // Conductivity Sensor Fault
        status_WaterQuality.push(nthBit(resp.register[2],4) ? nthBit(resp.register[2],4) : 0);     // Bromine Sensor Fault 
        status_WaterQuality.push(nthBit(resp.register[2],5) ? nthBit(resp.register[2],5) : 0);     // Filtration Temp Sensor Fault
        status_WaterQuality.push(nthBit(resp.register[2],6) ? nthBit(resp.register[2],6) : 0);     // Basin Return Temp Sensor Fault
        status_WaterQuality.push(nthBit(resp.register[2],7) ? nthBit(resp.register[2],7) : 0);     // Basin Temp Sensor Fault
        status_WaterQuality.push(nthBit(resp.register[2],8) ? nthBit(resp.register[2],8) : 0);     // Basin Return Temp Below LL 
        status_WaterQuality.push(nthBit(resp.register[2],9) ? nthBit(resp.register[2],9) : 0);     // Basin Temp Below LL
        status_WaterQuality.push(nthBit(resp.register[2],12) ? nthBit(resp.register[2],12) : 0);   // Bromine Dosing ON
        status_WaterQuality.push(nthBit(resp.register[2],13) ? nthBit(resp.register[2],13) : 0);   // Freeze Dump Valves Open

        //WaterLevel 
        status_WaterLevel.push(nthBit(resp.register[3],0) ? nthBit(resp.register[3],0) : 0);   // WaterLevel Above Hi
        status_WaterLevel.push(nthBit(resp.register[3],1) ? nthBit(resp.register[3],1) : 0);   // WaterLevel Below L
        status_WaterLevel.push(nthBit(resp.register[3],2) ? nthBit(resp.register[3],2) : 0);   // WaterLevel Below LL
        status_WaterLevel.push(nthBit(resp.register[3],3) ? nthBit(resp.register[3],3) : 0);   // WaterLevel Below LLL
        status_WaterLevel.push(nthBit(resp.register[3],4) ? nthBit(resp.register[3],4) : 0);   // WaterLevel Fault
        status_WaterLevel.push(nthBit(resp.register[3],5) ? nthBit(resp.register[3],5) : 0);   // WaterMakeup Active

        //System Pressure 
        status_AirPressure.push(nthBit(resp.register[4],0) ? nthBit(resp.register[4],0) : 0);     // PSL-1001 Clean Strainer Warning
        status_AirPressure.push(nthBit(resp.register[4],1) ? nthBit(resp.register[4],1) : 0);     // PSL-1003 Clean Strainer Warning
        status_AirPressure.push(nthBit(resp.register[4],2) ? nthBit(resp.register[4],2) : 0);     // PSL-1005 Clean Strainer Warning
        status_AirPressure.push(nthBit(resp.register[4],7) ? nthBit(resp.register[4],7) : 0);     // PSLL-1001 Pressure Fault
        status_AirPressure.push(nthBit(resp.register[4],8) ? nthBit(resp.register[4],8) : 0);     // PSLL-1003 Pressure Fault
        status_AirPressure.push(nthBit(resp.register[4],9) ? nthBit(resp.register[4],9) : 0);     // PSLL-1004 Pressure Fault
        status_AirPressure.push(nthBit(resp.register[4],10) ? nthBit(resp.register[4],10) : 0);   // PSLL-1005 Pressure Fault
        status_AirPressure.push(nthBit(resp.register[4],11) ? nthBit(resp.register[4],11) : 0);   // PSLL-1006 Pressure Fault

        //Pumps
        fault_PUMPS.push(nthBit(resp.register[5],0) ? nthBit(resp.register[5],0) : 0); // VFD 101 Hand Mode (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],1) ? nthBit(resp.register[5],1) : 0); // VFD 101 Off Mode  (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],2) ? nthBit(resp.register[5],2) : 0); // VFD 101 Auto Mode (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],3) ? nthBit(resp.register[5],3) : 0); // VFD 101 Pump Running (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],4) ? nthBit(resp.register[5],4) : 0); // VFD 101 Pump Warning (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],5) ? nthBit(resp.register[5],5) : 0); // VFD 101 Pump Fault (Filter Pump)

        fault_PUMPS.push(nthBit(resp.register[5],8) ? nthBit(resp.register[5],8) : 0);   // Ozone Hand Mode 
        fault_PUMPS.push(nthBit(resp.register[5],9) ? nthBit(resp.register[5],9) : 0);   // Ozone Auto Mode  
        fault_PUMPS.push(nthBit(resp.register[5],10) ? nthBit(resp.register[5],10) : 0);   // Ozone Enabled 
        fault_PUMPS.push(nthBit(resp.register[5],11) ? nthBit(resp.register[5],11) : 0);   // Ozone Pump Running 
        fault_PUMPS.push(nthBit(resp.register[5],12) ? nthBit(resp.register[5],12) : 0); // Ozone Pump Fault 
        fault_PUMPS.push(nthBit(resp.register[5],13) ? nthBit(resp.register[5],13) : 0); // Ozone Generator Active 
        fault_PUMPS.push(nthBit(resp.register[5],14) ? nthBit(resp.register[5],14) : 0); // Ozone Destruct Active 

        fault_PUMPS.push(nthBit(resp.register[6],0) ? nthBit(resp.register[6],0) : 0); // VFD 103 Hand Mode (Blossom Pump1)
        fault_PUMPS.push(nthBit(resp.register[6],1) ? nthBit(resp.register[6],1) : 0); // VFD 103 Off Mode  (Blossom Pump1)
        fault_PUMPS.push(nthBit(resp.register[6],2) ? nthBit(resp.register[6],2) : 0); // VFD 103 Auto Mode (Blossom Pump1)
        fault_PUMPS.push(nthBit(resp.register[6],3) ? nthBit(resp.register[6],3) : 0); // VFD 103 Pump Running (Blossom Pump1)
        fault_PUMPS.push(nthBit(resp.register[6],4) ? nthBit(resp.register[6],4) : 0); // VFD 103 Pump Warning (Blossom Pump1)
        fault_PUMPS.push(nthBit(resp.register[6],5) ? nthBit(resp.register[6],5) : 0); // VFD 103 Pump Fault (Blossom Pump1)

        fault_PUMPS.push(nthBit(resp.register[6],8) ? nthBit(resp.register[6],8) : 0);   // VFD 104 Hand Mode (Blossom Pump2)
        fault_PUMPS.push(nthBit(resp.register[6],9) ? nthBit(resp.register[6],9) : 0);   // VFD 104 Off Mode  (Blossom Pump2)
        fault_PUMPS.push(nthBit(resp.register[6],10) ? nthBit(resp.register[6],10) : 0); // VFD 104 Auto Mode (Blossom Pump2)
        fault_PUMPS.push(nthBit(resp.register[6],11) ? nthBit(resp.register[6],11) : 0); // VFD 104 Pump Running (Blossom Pump2)
        fault_PUMPS.push(nthBit(resp.register[6],12) ? nthBit(resp.register[6],12) : 0); // VFD 104 Pump Warning (Blossom Pump2)
        fault_PUMPS.push(nthBit(resp.register[6],13) ? nthBit(resp.register[6],13) : 0); // VFD 104 Pump Fault (Blossom Pump2)

        fault_PUMPS.push(nthBit(resp.register[7],0) ? nthBit(resp.register[7],0) : 0); // VFD 105 Hand Mode (Blossom Pump3)
        fault_PUMPS.push(nthBit(resp.register[7],1) ? nthBit(resp.register[7],1) : 0); // VFD 105 Off Mode  (Blossom Pump3)
        fault_PUMPS.push(nthBit(resp.register[7],2) ? nthBit(resp.register[7],2) : 0); // VFD 105 Auto Mode (Blossom Pump3)
        fault_PUMPS.push(nthBit(resp.register[7],3) ? nthBit(resp.register[7],3) : 0); // VFD 105 Pump Running (Blossom Pump3)
        fault_PUMPS.push(nthBit(resp.register[7],4) ? nthBit(resp.register[7],4) : 0); // VFD 105 Pump Warning (Blossom Pump3)
        fault_PUMPS.push(nthBit(resp.register[7],5) ? nthBit(resp.register[7],5) : 0); // VFD 105 Pump Fault (Blossom Pump3)

        fault_PUMPS.push(nthBit(resp.register[7],8) ? nthBit(resp.register[7],8) : 0);   // VFD 106 Hand Mode (Blossom Pump4)
        fault_PUMPS.push(nthBit(resp.register[7],9) ? nthBit(resp.register[7],9) : 0);   // VFD 106 Off Mode  (Blossom Pump4)
        fault_PUMPS.push(nthBit(resp.register[7],10) ? nthBit(resp.register[7],10) : 0); // VFD 106 Auto Mode (Blossom Pump4)
        fault_PUMPS.push(nthBit(resp.register[7],11) ? nthBit(resp.register[7],11) : 0); // VFD 106 Pump Running (Blossom Pump4)
        fault_PUMPS.push(nthBit(resp.register[7],12) ? nthBit(resp.register[7],12) : 0); // VFD 106 Pump Warning (Blossom Pump4)
        fault_PUMPS.push(nthBit(resp.register[7],13) ? nthBit(resp.register[7],13) : 0); // VFD 106 Pump Fault (Blossom Pump4)

        fault_PUMPS.push(nthBit(resp.register[8],0) ? nthBit(resp.register[8],0) : 0); // VFD 107 Hand Mode (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],1) ? nthBit(resp.register[8],1) : 0); // VFD 107 Off Mode  (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],2) ? nthBit(resp.register[8],2) : 0); // VFD 107 Auto Mode (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],3) ? nthBit(resp.register[8],3) : 0); // VFD 107 Pump Running (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],4) ? nthBit(resp.register[8],4) : 0); // VFD 107 Pump Warning (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],5) ? nthBit(resp.register[8],5) : 0); // VFD 107 Pump Fault (Fog Plume1)
        fault_PUMPS.push(nthBit(resp.register[8],6) ? nthBit(resp.register[8],6) : 0); // VFD 107 GFCI Tripped (Fog Plume1)

        fault_PUMPS.push(nthBit(resp.register[8],8) ? nthBit(resp.register[8],8) : 0);   // VFD 108 Hand Mode (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],9) ? nthBit(resp.register[8],9) : 0);   // VFD 108 Off Mode  (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],10) ? nthBit(resp.register[8],10) : 0); // VFD 108 Auto Mode (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],11) ? nthBit(resp.register[8],11) : 0); // VFD 108 Pump Running (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],12) ? nthBit(resp.register[8],12) : 0); // VFD 108 Pump Warning (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],13) ? nthBit(resp.register[8],13) : 0); // VFD 108 Pump Fault (Fog Plume2)
        fault_PUMPS.push(nthBit(resp.register[8],14) ? nthBit(resp.register[8],14) : 0); // VFD 108 GFCI Tripped (Fog Plume2)

        fault_PUMPS.push(nthBit(resp.register[9],0) ? nthBit(resp.register[9],0) : 0); // VFD 109 Hand Mode (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],1) ? nthBit(resp.register[9],1) : 0); // VFD 109 Off Mode  (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],2) ? nthBit(resp.register[9],2) : 0); // VFD 109 Auto Mode (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],3) ? nthBit(resp.register[9],3) : 0); // VFD 109 Pump Running (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],4) ? nthBit(resp.register[9],4) : 0); // VFD 109 Pump Warning (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],5) ? nthBit(resp.register[9],5) : 0); // VFD 109 Pump Fault (Fog Plume3)
        fault_PUMPS.push(nthBit(resp.register[9],6) ? nthBit(resp.register[9],6) : 0); // VFD 109 GFCI Tripped (Fog Plume3)

        fault_PUMPS.push(nthBit(resp.register[5],6) ? nthBit(resp.register[5],6) : 0); // Filter 101A Running(Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[5],7) ? nthBit(resp.register[5],7) : 0); // Filter 101B Running(Filter Pump)

        //Fog
        fault_FOG.push(nthBit(resp.register[10],0) ? nthBit(resp.register[10],0) : 0);     // Fog System1 Running
        fault_FOG.push(nthBit(resp.register[10],1) ? nthBit(resp.register[10],1) : 0);     // Fog System1 Fault
        fault_FOG.push(nthBit(resp.register[10],2) ? nthBit(resp.register[10],2) : 0);     // Fog System1 Ring Open
        fault_FOG.push(nthBit(resp.register[10],3) ? nthBit(resp.register[10],3) : 0);     // Fog System1 Plume Open
        fault_FOG.push(nthBit(resp.register[10],4) ? nthBit(resp.register[10],4) : 0);     // Fog System2 Running
        fault_FOG.push(nthBit(resp.register[10],5) ? nthBit(resp.register[10],5) : 0);     // Fog System2 Fault
        fault_FOG.push(nthBit(resp.register[10],6) ? nthBit(resp.register[10],6) : 0);     // Fog System2 Ring Open
        fault_FOG.push(nthBit(resp.register[10],7) ? nthBit(resp.register[10],7) : 0);     // Fog System2 Plume Open
        fault_FOG.push(nthBit(resp.register[10],8) ? nthBit(resp.register[10],8) : 0);     // Fog System3 Running
        fault_FOG.push(nthBit(resp.register[10],9) ? nthBit(resp.register[10],9) : 0);     // Fog System3 Fault
        fault_FOG.push(nthBit(resp.register[10],10) ? nthBit(resp.register[10],10) : 0);   // Fog System3 Ring Open
        fault_FOG.push(nthBit(resp.register[10],11) ? nthBit(resp.register[10],11) : 0);   // Fog System3 Plume Open

        //DC Power
        status_DcPower.push(nthBit(resp.register[11],0) ? nthBit(resp.register[11],0) : 0);     // DCP-101 Power Enabled
        status_DcPower.push(nthBit(resp.register[11],1) ? nthBit(resp.register[11],1) : 0);     // DCP-102 Power Enabled
        status_DcPower.push(nthBit(resp.register[11],2) ? nthBit(resp.register[11],2) : 0);     // DCP-103 Power Enabled
        status_DcPower.push(nthBit(resp.register[11],3) ? nthBit(resp.register[11],3) : 0);     // DCP-104 Power Enabled
        status_DcPower.push(nthBit(resp.register[11],4) ? nthBit(resp.register[11],4) : 0);     // DCP-105 Power Enabled
        status_DcPower.push(nthBit(resp.register[11],5) ? nthBit(resp.register[11],5) : 0);     // DCP-101 Warning
        status_DcPower.push(nthBit(resp.register[11],6) ? nthBit(resp.register[11],6) : 0);     // DCP-102 Warning
        status_DcPower.push(nthBit(resp.register[11],7) ? nthBit(resp.register[11],7) : 0);     // DCP-103 Warning
        status_DcPower.push(nthBit(resp.register[11],8) ? nthBit(resp.register[11],8) : 0);     // DCP-104 Warning
        status_DcPower.push(nthBit(resp.register[11],9) ? nthBit(resp.register[11],9) : 0);     // DCP-105 Warning
        status_DcPower.push(nthBit(resp.register[11],10) ? nthBit(resp.register[11],10) : 0);   // DCP-101 Fault
        status_DcPower.push(nthBit(resp.register[11],11) ? nthBit(resp.register[11],11) : 0);   // DCP-102 Fault
        status_DcPower.push(nthBit(resp.register[11],12) ? nthBit(resp.register[11],12) : 0);   // DCP-103 Fault
        status_DcPower.push(nthBit(resp.register[11],13) ? nthBit(resp.register[11],13) : 0);   // DCP-104 Fault
        status_DcPower.push(nthBit(resp.register[11],14) ? nthBit(resp.register[11],14) : 0);   // DCP-105 Fault
        
        
        showStopper = 0;
            for (var i=0; i <= (fault_ShowStoppers.length-1); i++){
                showStopper = showStopper + fault_ShowStoppers[i];
                // if(serviceRequired === 1){
                //    showStopper = 1; 
                //    watchDog.eventLog("ShowStopper:: Service Required 1");
                // }
            }   

            totalStatus = [ 
                            fault_ShowStoppers,      //4
                            fault_ESTOP,             //14
                            status_Ethernet,         //12
                            status_WarningFaults,    //16
                            status_WaterQuality,     //25
                            status_WaterLevel,       //6
                            status_AirPressure,      //8
                            fault_PUMPS,             //60
                            fault_FOG,               //12
                            status_DcPower];         //15

            totalStatus = bool2int(totalStatus);

            if (devStatus.length > 1) {
                logChanges(totalStatus); // detects change of total status
            }

            devStatus = totalStatus; // makes the total status equal to the current error state

            // creates the status array that is sent to the iPad (via errorLog) AND logged to file
            sysStatus = [{
                            "***************************ESTOP STATUS**************************" : "1",
                            "CP-101 ESTOP": fault_ESTOP[0],
                            "DCP-101 ESTOP": fault_ESTOP[1],
                            "DCP-102 ESTOP": fault_ESTOP[2],
                            "DCP-103 ESTOP": fault_ESTOP[3],
                            "DCP-104 ESTOP": fault_ESTOP[4],
                            "DCP-105 ESTOP": fault_ESTOP[5],
                            "MCC-101 ESTOP": fault_ESTOP[6],
                            "MCC-102 ESTOP": fault_ESTOP[7],
                            "Show Stop Active": fault_ESTOP[8],
                            "System Normal State": fault_ESTOP[9],
                            "System Warning Active": fault_ESTOP[10],
                            "System Fault Active": fault_ESTOP[11],
                            "BMS Warning Output": fault_ESTOP[12],
                            "BMS Fault Output": fault_ESTOP[13],
                            "ShowStopper :Estop": fault_ShowStoppers[0],
                            "ShowStopper :WaterLevel LL": fault_ShowStoppers[1],
                            "ShowStopper :High Wind": fault_ShowStoppers[2],
                            "ShowStopper :VFD101 NotRunning": fault_ShowStoppers[3],
                            "***************************SYSTEM NETOWRK STATUS***************************" : "2",
                            "VFD-101 Communication OK": status_Ethernet[0],
                            "VFD-103 Communication OK": status_Ethernet[1],
                            "VFD-104 Communication OK": status_Ethernet[2],
                            "VFD-105 Communication OK": status_Ethernet[3],
                            "VFD-106 Communication OK": status_Ethernet[4],
                            "VFD-107 Communication OK": status_Ethernet[5],
                            "VFD-108 Communication OK": status_Ethernet[6],
                            "VFD-109 Communication OK": status_Ethernet[7],
                            "MCC-102 REMIO Communication OK": status_Ethernet[8],
                            "MCC-102 GFCI Communication OK": status_Ethernet[9],
                            "Water Quality Communication OK": status_Ethernet[10],
                            "Weather Station Communication OK": status_Ethernet[11],
                            "***************************SYSTEM WARNING FAULT STATUS**************************" : "3",
                            "Warning: Water Quality": status_WarningFaults[0],
                            "Warning: Basin WaterLevel LL": status_WarningFaults[1],
                            "Warning: Weather Station": status_WarningFaults[2],
                            "Warning: CleanStrainer": status_WarningFaults[3],
                            "Warning: Pump/VFD": status_WarningFaults[4],
                            "Warning: DC Power": status_WarningFaults[5],
                            "Fault: Estop": status_WarningFaults[6],
                            "Fault: Network": status_WarningFaults[7],
                            "Fault: WaterQuality": status_WarningFaults[8],
                            "Fault: WaterLevel": status_WarningFaults[9],
                            "Fault: Basin WaterLevel Below LLL": status_WarningFaults[10],
                            "Fault: Weather Station": status_WarningFaults[11],
                            "Fault: Low Pressure": status_WarningFaults[12],
                            "Fault: VFD/Pump": status_WarningFaults[13],
                            "Fault: Fog": status_WarningFaults[14],
                            "Fault: DC Power": status_WarningFaults[15],
                            "****************************WATER QUALITY STATUS*****************" : "4",
                            "PH Above Hi": status_WaterQuality[0],
                            "PH Below Low": status_WaterQuality[1],
                            "ORP Above Hi": status_WaterQuality[2],
                            "ORP Below Low": status_WaterQuality[3],
                            "Conductivity Above Hi": status_WaterQuality[4],
                            "Conductivity Below Low": status_WaterQuality[5],
                            "Bromine Above Hi": status_WaterQuality[6],
                            "Bromine Below Low": status_WaterQuality[7],
                            "Filtration Temperature Above Hi": status_WaterQuality[8],
                            "Filtration Temperature Below Low": status_WaterQuality[9],
                            "Basin Return Temperature Below Low": status_WaterQuality[10],
                            "Basin Temperature Below Low": status_WaterQuality[11],
                            "Bromine Dosing Timeout": status_WaterQuality[12],
                            "MW104 DCM512  Communication Fault": status_WaterQuality[13],
                            "pH Sensor Fault": status_WaterQuality[14],
                            "ORP Sensor Fault": status_WaterQuality[15],
                            "Conductivity Sensor Fault": status_WaterQuality[16],
                            "Bromine Sensor Fault": status_WaterQuality[17],
                            "Filtration Temperature Sensor Fault": status_WaterQuality[18],
                            "Basin Return Temperature Sensor Fault": status_WaterQuality[19],
                            "Basin Temperature Sensor Fault": status_WaterQuality[20],
                            "Basin Return Temperature Below LL": status_WaterQuality[21],
                            "Basin Temperature Below LL": status_WaterQuality[22],
                            "Bromine Dosing ON": status_WaterQuality[23],
                            "Freeze Dump Valves Open": status_WaterQuality[24],
                            "****************************WATERLEVEL STATUS********************" : "5",
                            "WaterLevel Above_Hi":status_WaterLevel[0],
                            "WaterLevel Below_Low":status_WaterLevel[1],
                            "WaterLevel Below_LowLow":status_WaterLevel[2],
                            "WaterLevel Below_LowLowLow":status_WaterLevel[3],
                            "WaterLevel Fault":status_WaterLevel[4],
                            "WaterMakeup On":status_WaterLevel[5],
                            "****************************SYSTEM PRESSURE STATUS********************" : "6",
                            "PSL1001 Clean Strainer":status_AirPressure[0],
                            "PSL1003 Clean Strainer":status_AirPressure[1],
                            "PSL1005 Clean Strainer":status_AirPressure[2],
                            "PSLL1001 PressureFault":status_AirPressure[3],
                            "PSLL1003 PressureFault":status_AirPressure[4],
                            "PSLL1004 PressureFault":status_AirPressure[5],
                            "PSLL1005 PressureFault":status_AirPressure[6],
                            "PSLL1006 PressureFault":status_AirPressure[7],
                            "***************************PUMPS STATUS**************************" : "7",
                            "VFD 101 Hand Mode":fault_PUMPS[0],
                            "VFD 101 OFF Mode":fault_PUMPS[1],
                            "VFD 101 Auto Mode":fault_PUMPS[2],
                            "VFD 101 Pump Running":fault_PUMPS[3],
                            "VFD 101 Pump Warning":fault_PUMPS[4],
                            "VFD 101 Pump Fault":fault_PUMPS[5],
                            "Ozone Booster Hand Mode":fault_PUMPS[6],
                            "Ozone Booster Auto Mode":fault_PUMPS[7],
                            "Ozone Booster Pump Enabled":fault_PUMPS[8],
                            "Ozone Booster Pump Running":fault_PUMPS[9],
                            "Ozone Booster Pump Fault":fault_PUMPS[10],
                            "Ozone Generator Active":fault_PUMPS[11],
                            "Ozone Destruct Active":fault_PUMPS[12],
                            "VFD 103 Hand Mode":fault_PUMPS[13],
                            "VFD 103 OFF Mode":fault_PUMPS[14],
                            "VFD 103 Auto Mode":fault_PUMPS[15],
                            "VFD 103 Pump Running":fault_PUMPS[16],
                            "VFD 103 Pump Warning":fault_PUMPS[17],
                            "VFD 103 Pump Fault":fault_PUMPS[18],
                            "VFD 104 Hand Mode":fault_PUMPS[19],
                            "VFD 104 OFF Mode":fault_PUMPS[20],
                            "VFD 104 Auto Mode":fault_PUMPS[21],
                            "VFD 104 Pump Running":fault_PUMPS[22],
                            "VFD 104 Pump Warning":fault_PUMPS[23],
                            "VFD 104 Pump Fault":fault_PUMPS[24],
                            "VFD 105 Hand Mode":fault_PUMPS[25],
                            "VFD 105 OFF Mode":fault_PUMPS[26],
                            "VFD 105 Auto Mode":fault_PUMPS[27],
                            "VFD 105 Pump Running":fault_PUMPS[28],
                            "VFD 105 Pump Warning":fault_PUMPS[29],
                            "VFD 105 Pump Fault":fault_PUMPS[30],
                            "VFD 106 Hand Mode":fault_PUMPS[31],
                            "VFD 106 OFF Mode":fault_PUMPS[32],
                            "VFD 106 Auto Mode":fault_PUMPS[33],
                            "VFD 106 Pump Running":fault_PUMPS[34],
                            "VFD 106 Pump Warning":fault_PUMPS[35],
                            "VFD 106 Pump Fault":fault_PUMPS[36],
                            "VFD 107 Hand Mode":fault_PUMPS[37],
                            "VFD 107 OFF Mode":fault_PUMPS[38],
                            "VFD 107 Auto Mode":fault_PUMPS[39],
                            "VFD 107 Pump Running":fault_PUMPS[40],
                            "VFD 107 Pump Warning":fault_PUMPS[41],
                            "VFD 107 Pump Fault":fault_PUMPS[42],
                            "VFD 107 GFCI Tripped":fault_PUMPS[43],
                            "VFD 108 Hand Mode":fault_PUMPS[44],
                            "VFD 108 OFF Mode":fault_PUMPS[45],
                            "VFD 108 Auto Mode":fault_PUMPS[46],
                            "VFD 108 Pump Running":fault_PUMPS[47],
                            "VFD 108 Pump Warning":fault_PUMPS[48],
                            "VFD 108 Pump Fault":fault_PUMPS[49],
                            "VFD 108 GFCI Tripped":fault_PUMPS[50],
                            "VFD 109 Hand Mode":fault_PUMPS[51],
                            "VFD 109 OFF Mode":fault_PUMPS[52],
                            "VFD 109 Auto Mode":fault_PUMPS[53],
                            "VFD 109 Pump Running":fault_PUMPS[54],
                            "VFD 109 Pump Warning":fault_PUMPS[55],
                            "VFD 109 Pump Fault":fault_PUMPS[56],
                            "VFD 109 GFCI Tripped":fault_PUMPS[57],
                            "F101A Running":fault_PUMPS[58],
                            "F101B Running":fault_PUMPS[59],
                            "***************************FOG STATUS**************************" : "8",
                            "FOG System 1 Running":fault_FOG[0],
                            "FOG System 1 Fault":fault_FOG[1],
                            "FOG System 1 Ring Open":fault_FOG[2],
                            "FOG System 1 Plume Open":fault_FOG[3],
                            "FOG System 2 Running":fault_FOG[4],
                            "FOG System 2 Fault":fault_FOG[5],
                            "FOG System 2 Ring Open":fault_FOG[6],
                            "FOG System 2 Plume Open":fault_FOG[7],
                            "FOG System 3 Running":fault_FOG[8],
                            "FOG System 3 Fault":fault_FOG[9],
                            "FOG System 3 Ring Open":fault_FOG[10],
                            "FOG System 3 Plume Open":fault_FOG[11],
                            "***************************DC POWER STATUS**************************" : "9",
                            "DCP-101 Power Enabled":status_DcPower[0],
                            "DCP-102 Power Enabled":status_DcPower[1],
                            "DCP-103 Power Enabled":status_DcPower[2],
                            "DCP-104 Power Enabled":status_DcPower[3],
                            "DCP-105 Power Enabled":status_DcPower[4],
                            "DCP-101 Warning":status_DcPower[5],
                            "DCP-102 Warning":status_DcPower[6],
                            "DCP-103 Warning":status_DcPower[7],
                            "DCP-104 Warning":status_DcPower[8],
                            "DCP-105 Warning":status_DcPower[9],
                            "DCP-101 Fault":status_DcPower[10],
                            "DCP-102 Fault":status_DcPower[11],
                            "DCP-103 Fault":status_DcPower[12],
                            "DCP-104 Fault":status_DcPower[13],
                            "DCP-105 Fault":status_DcPower[14],
                            "****************************DEVICE CONNECTION STATUS*************" : "10",
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
                            "playCmdIssued": playCmdIssued,
                            "stopCmdIssued": stopCmdIssued,
                            "jumpToStep_manual": jumpToStep_manual,
                            "jumpToStep_auto": jumpToStep_auto
                            }];
                            
            playMode_init = {"autoMan":autoMan};

            fs.writeFileSync(homeD+'/UserFiles/playMode.txt',JSON.stringify(playMode_init),'utf-8');
            fs.writeFileSync(homeD+'/UserFiles/playModeBkp.txt',JSON.stringify(playMode_init),'utf-8');
      }      
    });
}
var date = new Date();

plc_client.readHoldingRegister(202,1,function(resp){
    if (resp.register[0] > 0){
        playing = 1;
        //watchDog.eventLog("Show Playing");
        //watchDog.eventLog("Show Playing is :: "+resp.register[0]);
        show = resp.register[0];
        //watchDog.eventLog("Show Playing Name :: "+shows[show].name);
    } else{
        playing = 0;
        //watchDog.eventLog("Show Stopped");
    }
});

// if(((date.getMonth() > 5) && (date.getDate() > 21)) || (date.getMonth() > 6)){
//     serviceRequired = 1;
//     plc_client.writeSingleCoil(2,1,function(resp){});
// } else {
//     serviceRequired = 0;
//     plc_client.writeSingleCoil(2,0,function(resp){});
// }

    // compares current state to previous state to log differences
    function logChanges(currentState){
        // {"yes":"n/a","no":"n/a"} object template for detection but no logging... "n/a" disables log
        // {"yes":"positive edge message","no":"negative edge message"} object template for detection and logging
        // pattern of statements must match devStatus and totalStatus format
        var statements=[

            [   // Show Stopper - scio - 4
                {"yes":"Show Stopper: Estop","no":"Show Stopper Resolved: Estop"},
                {"yes":"Show Stopper: WaterLevel LL","no":"Show Stopper Resolved: WaterLevel LL"},
                {"yes":"Show Stopper: High Wind","no":"Show Stopper Resolved: High Wind"},
                {"yes":"Show Stopper: Filtration NotRunning","no":"Show Stopper Resolved: Filtration NotRunning"},
            ],

            [   // estop - scio - 14
                {"yes":"CP101 Estop Triggered","no":"Resolved: CP101 Estop"}, 
                {"yes":"DCP101 Estop Triggered","no":"Resolved: DCP101 Estop"},
                {"yes":"DCP102 Estop Triggered","no":"Resolved: DCP102 Estop"},
                {"yes":"DCP103 Estop Triggered","no":"Resolved: DCP103 Estop"},
                {"yes":"DCP104 Estop Triggered","no":"Resolved: DCP104 Estop"},
                {"yes":"DCP105 Estop Triggered","no":"Resolved: DCP105 Estop"},
                {"yes":"MCC101 Estop Triggered","no":"Resolved: MCC101 Estop"},
                {"yes":"MCC102 Estop Triggered","no":"Resolved: MCC102 Estop"},
                {"yes":"Show Stop Active","no":"Resolved: Show Stop Active"},
                {"yes":"System Normal State","no":"System Not In Normal State"},
                {"yes":"One/More System Warnings","no":"Resolved: No System Warnings"}, 
                {"yes":"One/More System Faults","no":"Resolved: No System Faults"}, 
                {"yes":"BMS Warning Output","no":"Resolved: BMS Warning Output"},
                {"yes":"BMS Fault Output","no":"Resolved: BMS Fault Output"},
            ],

            [   // Ethernet - scio - 12
                {"yes":"VFD-101 Communication OK","no":"VFD-101 Communication Error"},
                {"yes":"VFD-103 Communication OK","no":"VFD-103 Communication Error"},
                {"yes":"VFD-104 Communication OK","no":"VFD-104 Communication Error"},
                {"yes":"VFD-105 Communication OK","no":"VFD-105 Communication Error"},
                {"yes":"VFD-106 Communication OK","no":"VFD-106 Communication Error"},
                {"yes":"VFD-107 Communication OK","no":"VFD-107 Communication Error"},
                {"yes":"VFD-108 Communication OK","no":"VFD-108 Communication Error"},
                {"yes":"VFD-109 Communication OK","no":"VFD-109 Communication Error"},
                {"yes":"MCC-102 REMIO Communication OK","no":"MCC-102 REMIO Communication Error"},
                {"yes":"MCC-102 GFCI Communication OK","no":"MCC-102 GFCI Communication Error"},
                {"yes":"Water Quality Communication OK","no":"Water Quality Communication Error"},
                {"yes":"Weather Station Communication OK","no":"Weather Station Communication Error"},
            ],

            [   // System Warning Faults - scio - 16
                {"yes":"Warning: Water Quality","no":"Resolved Warning: Water Quality"},
                {"yes":"Warning: Basin WaterLevel LL","no":"Resolved Warning: Basin WaterLevel LL"},
                {"yes":"Warning: Weather Station","no":"Resolved Warning: Weather Station"},
                {"yes":"Warning: CleanStrainer","no":"Resolved Warning: CleanStrainer"},
                {"yes":"Warning: Pump/VFD","no":"Resolved Warning: Pump/VFD"},
                {"yes":"Warning: DC Power","no":"Resolved Warning: DC Power"},
                {"yes":"Fault: EStop","no":"Resolved Fault: Estop"},
                {"yes":"Fault: Network","no":"Resolved Fault: Network"},
                {"yes":"Fault: Water Quality","no":"Resolved Fault: Water Quality"},
                {"yes":"Fault: Water Level","no":"Resolved Fault: Water Level"},
                {"yes":"Fault: Basin WaterLevel Below LLL","no":"Resolved Fault: Basin WaterLevel Below LLL"},
                {"yes":"Fault: Weather Station","no":"Resolved Fault: Weather Station"},
                {"yes":"Fault: Low Pressure","no":"Resolved Fault: Low Pressure"},
                {"yes":"Fault: VFD/Pump","no":"Resolved Fault: VFD/Pump"},
                {"yes":"Fault: Fog","no":"Resolved Fault: Fog"},
                {"yes":"Fault: DC Power","no":"Resolved Fault: DC Power"},
            ],

            [   //Water Quality Status - scio - 25
                
                
                {"yes":"PH AboveHi","no":"Resolved: PH Above Hi Alarm "},
                {"yes":"PH Below_Low","no":"Resolved: PH Below Low Alarm "},
                {"yes":"ORP AboveHi","no":"Resolved: ORP Above Hi Alarm "},
                {"yes":"ORP Below_Low","no":"Resolved: ORP Below Low Alarm "},
                {"yes":"Conductivity AboveHi","no":"Resolved: Conductivity Above Hi Alarm "},
                {"yes":"Conductivity Below_Low","no":"Resolved: Conductivity Below Low Alarm "},
                {"yes":"Bromine AboveHi","no":"Resolved: Bromine Above Hi Alarm "},
                {"yes":"Bromine Below_Low","no":"Resolved: Bromine Below Low Alarm "},
                {"yes":"Filtration Temperature AboveHi","no":"Resolved: Filtration Temperature Above Hi Alarm "},
                {"yes":"Filtration Temperature Below_Low","no":"Resolved: Filtration Temperature Below_Low Alarm "},
                {"yes":"Basin Return Temperature Below_Low","no":"Resolved: Basin Return Temperature Below_Low Alarm "},
                {"yes":"Basin Temperature Below_Low","no":"Resolved: Basin Temperature Below_Low Alarm "},
                {"yes":"Broming Dosing Timeout","no":"Resolved : Broming Dosing Timeout"},
                {"yes":"MW104 DCM512 Communication Fault","no":"Resolved : MW104 DCM512 Communication Fault"},
                {"yes":"pH Sensor Fault","no":"Resolved : pH Sensor Fault"},
                {"yes":"ORP Sensor Fault","no":"Resolved : ORP Sensor Fault"},
                {"yes":"Conductivity Sensor Fault","no":"Resolved : Conductivity Sensor Fault"},
                {"yes":"Bromine Sensor Fault","no":"Resolved : Bromine Sensor Fault"},
                {"yes":"Filtration Temperature Sensor Fault","no":"Resolved : Filtration Temperature Sensor Fault"},
                {"yes":"Basin Temperature Return Sensor Fault","no":"Resolved : Basin Temperature Return Sensor Fault"},
                {"yes":"Basin Temperature Sensor Fault","no":"Resolved : Basin Temperature Sensor Fault"},
                {"yes":"Basin Temperature Return Below LL","no":"Resolved : Basin Temperature Return Below LL"},
                {"yes":"Basin Temperature Below LL","no":"Resolved : Basin Temperature Below LL"},
                {"yes":"Broming Dosing On","no":"Broming Dosing Off"},
                {"yes":"Freeze Dump Valve Open","no":"Freeze Dump Valve Close"},
                
            ],

            [   // water level - scio - 6
                
                {"yes":"WaterLevel AboveHi","no":"Resolved: WaterLevel AboveHi Resolved"},
                {"yes":"WaterLevel Below_Low","no":"Resolved: WaterLevel Below_Low Resolved"},
                {"yes":"WaterLevel Below_LowLow","no":"Resolved: WaterLevel Below_LowLow Resolved"},
                {"yes":"WaterLevel Below_LowLowLow","no":"Resolved: WaterLevel Below_LowLowLow Resolved"},
                {"yes":"WaterLevel Fault","no":"Resolved: WaterLevel Fault Resolved"},
                {"yes":"WaterMakeup On","no":"WaterMakeup Off"},
                
            ],

            [   // system pressure - scio - 8
                
                {"yes":"PSL1001 Strainer Warning","no":"Resolved: PSL1001 Strainer Warning"},
                {"yes":"PSL1003 Strainer Warning","no":"Resolved: PSL1003 Strainer Warning"},
                {"yes":"PSL1005 Strainer Warning","no":"Resolved: PSL1005 Strainer Warning"},
                {"yes":"PSLL1001 Pressure Fault","no":"Resolved: PSLL1001 Pressure Fault"},
                {"yes":"PSLL1003 Pressure Fault","no":"Resolved: PSLL1003 Pressure Fault"},
                {"yes":"PSLL1004 Pressure Fault","no":"Resolved: PSLL1004 Pressure Fault"},
                {"yes":"PSLL1005 Pressure Fault","no":"Resolved: PSLL1005 Pressure Fault"},
                {"yes":"PSLL1006 Pressure Fault","no":"Resolved: PSLL1006 Pressure Fault"},
                   
            ],

            [   // pumps - scio - 58
                
                {"yes":"VFD 101 In Hand Mode","no":"VFD 101 NOT IN Hand Mode"},
                {"yes":"VFD 101 In Off Mode","no":"VFD 101 NOT IN Off Mode"},
                {"yes":"VFD 101 In Auto Mode","no":"VFD 101 NOT IN Auto Mode"},
                {"yes":"VFD 101 Pump Running","no":"VFD 101 Pump NOT Running"},
                {"yes":"VFD 101 Pump Warning","no":"Resolved: VFD 101 Pump Warning"},
                {"yes":"VFD 101 Pump Fault","no":"Resolved: VFD 101 Pump Fault"},
                {"yes":"Ozone Booster In Hand Mode","no":"Ozone Booster Pump NOT IN Hand Mode"},
                {"yes":"Ozone Booster In Auto Mode","no":"Ozone Booster Pump NOT IN Auto Mode"},
                {"yes":"Ozone Booster Pump Enabled","no":"Ozone Booster Pump NOT Enabled"},
                {"yes":"Ozone Booster Pump Running","no":"Ozone Booster Pump NOT Running"},
                {"yes":"Ozone Booster Pump Fault","no":"Resolved: Ozone Booster Pump Fault"},
                {"yes":"Ozone Generator Active","no":"Resolved: Ozone Generator InActive"},
                {"yes":"Ozone Destruct Active","no":"Resolved: Ozone Destruct InActive"},
                {"yes":"VFD 103 In Hand Mode","no":"VFD 103 NOT IN Hand Mode"},
                {"yes":"VFD 103 In Off Mode","no":"VFD 103 NOT IN Off Mode"},
                {"yes":"VFD 103 In Auto Mode","no":"VFD 103 NOT IN Auto Mode"},
                {"yes":"VFD 103 Pump Running","no":"VFD 103 Pump NOT Running"},
                {"yes":"VFD 103 Pump Warning","no":"Resolved: VFD 103 Pump Warning"},
                {"yes":"VFD 103 Pump Fault","no":"Resolved: VFD 103 Pump Fault"},
                {"yes":"VFD 104 In Hand Mode","no":"VFD 104 NOT IN Hand Mode"},
                {"yes":"VFD 104 In Off Mode","no":"VFD 104 NOT IN Off Mode"},
                {"yes":"VFD 104 In Auto Mode","no":"VFD 104 NOT IN Auto Mode"},
                {"yes":"VFD 104 Pump Running","no":"VFD 104 Pump NOT Running"},
                {"yes":"VFD 104 Pump Warning","no":"Resolved: VFD 104 Pump Warning"},
                {"yes":"VFD 104 Pump Fault","no":"Resolved: VFD 104 Pump Fault"},
                {"yes":"VFD 105 In Hand Mode","no":"VFD 105 NOT IN Hand Mode"},
                {"yes":"VFD 105 In Off Mode","no":"VFD 105 NOT IN Off Mode"},
                {"yes":"VFD 105 In Auto Mode","no":"VFD 105 NOT IN Auto Mode"},
                {"yes":"VFD 105 Pump Running","no":"VFD 105 Pump NOT Running"},
                {"yes":"VFD 105 Pump Warning","no":"Resolved: VFD 105 Pump Warning"},
                {"yes":"VFD 105 Pump Fault","no":"Resolved: VFD 105 Pump Fault"},
                {"yes":"VFD 106 In Hand Mode","no":"VFD 106 NOT IN Hand Mode"},
                {"yes":"VFD 106 In Off Mode","no":"VFD 106 NOT IN Off Mode"},
                {"yes":"VFD 106 In Auto Mode","no":"VFD 106 NOT IN Auto Mode"},
                {"yes":"VFD 106 Pump Running","no":"VFD 106 Pump NOT Running"},
                {"yes":"VFD 106 Pump Warning","no":"Resolved: VFD 106 Pump Warning"},
                {"yes":"VFD 106 Pump Fault","no":"Resolved: VFD 106 Pump Fault"},
                {"yes":"VFD 107 In Hand Mode","no":"VFD 107 NOT IN Hand Mode"},
                {"yes":"VFD 107 In Off Mode","no":"VFD 107 NOT IN Off Mode"},
                {"yes":"VFD 107 In Auto Mode","no":"VFD 107 NOT IN Auto Mode"},
                {"yes":"VFD 107 Pump Running","no":"VFD 107 Pump NOT Running"},
                {"yes":"VFD 107 Pump Warning","no":"Resolved: VFD 107 Pump Warning"},
                {"yes":"VFD 107 Pump Fault","no":"Resolved: VFD 107 Pump Fault"},
                {"yes":"VFD 107 GFCI Tripped","no":"Resolved: VFD 107 GFCI Tripped"},
                {"yes":"VFD 108 In Hand Mode","no":"VFD 108 NOT IN Hand Mode"},
                {"yes":"VFD 108 In Off Mode","no":"VFD 108 NOT IN Off Mode"},
                {"yes":"VFD 108 In Auto Mode","no":"VFD 108 NOT IN Auto Mode"},
                {"yes":"VFD 108 Pump Running","no":"VFD 108 Pump NOT Running"},
                {"yes":"VFD 108 Pump Warning","no":"Resolved: VFD 108 Pump Warning"},
                {"yes":"VFD 108 Pump Fault","no":"Resolved: VFD 108 Pump Fault"},
                {"yes":"VFD 108 GFCI Tripped","no":"Resolved: VFD 108 GFCI Tripped"},
                {"yes":"VFD 109 In Hand Mode","no":"VFD 109 NOT IN Hand Mode"},
                {"yes":"VFD 109 In Off Mode","no":"VFD 109 NOT IN Off Mode"},
                {"yes":"VFD 109 In Auto Mode","no":"VFD 109 NOT IN Auto Mode"},
                {"yes":"VFD 109 Pump Running","no":"VFD 109 Pump NOT Running"},
                {"yes":"VFD 109 Pump Warning","no":"Resolved: VFD 109 Pump Warning"},
                {"yes":"VFD 109 Pump Fault","no":"Resolved: VFD 109 Pump Fault"},
                {"yes":"VFD 109 GFCI Tripped","no":"Resolved: VFD 109 GFCI Tripped"},
                {"yes":"F101A Running","no":"F101A NOT Running"},
                {"yes":"F101B Running","no":"F101B NOT Running"},        
            ],

            [   // Fog System - scio - 12
                
                {"yes":"Fog System 1 Running","no":"Fog System 1 NOT Running"},
                {"yes":"Fog System 1 Fault","no":"Resolved:Fog System 1 Fault"},
                {"yes":"Fog System 1 Ring Open","no":"Fog System 1 Ring Close"},
                {"yes":"Fog System 1 Plume Open","no":"Fog System 1 Plume Close"},
                {"yes":"Fog System 2 Running","no":"Fog System 2 NOT Running"},
                {"yes":"Fog System 2 Fault","no":"Resolved:Fog System 2 Fault"},
                {"yes":"Fog System 2 Ring Open","no":"Fog System 2 Ring Close"},
                {"yes":"Fog System 2 Plume Open","no":"Fog System 2 Plume Close"},
                {"yes":"Fog System 3 Running","no":"Fog System 3 NOT Running"},
                {"yes":"Fog System 3 Fault","no":"Resolved:Fog System 3 Fault"},
                {"yes":"Fog System 3 Ring Open","no":"Fog System 3 Ring Close"},
                {"yes":"Fog System 3 Plume Open","no":"Fog System 3 Plume Close"},
            ],

            [   // filtration - scio - 15
                
                {"yes":"Enabled: DCP-101 Power","no":"Disabled: DCP-101 Power"},
                {"yes":"Enabled: DCP-102 Power","no":"Disabled: DCP-102 Power"},
                {"yes":"Enabled: DCP-103 Power","no":"Disabled: DCP-103 Power"},
                {"yes":"Enabled: DCP-104 Power","no":"Disabled: DCP-104 Power"},
                {"yes":"Enabled: DCP-105 Power","no":"Disabled: DCP-105 Power"},
                {"yes":"Warning: DCP-101 Power","no":"Resolved Warning: DCP-101 Power"},
                {"yes":"Warning: DCP-102 Power","no":"Resolved Warning: DCP-102 Power"},
                {"yes":"Warning: DCP-103 Power","no":"Resolved Warning: DCP-103 Power"},
                {"yes":"Warning: DCP-104 Power","no":"Resolved Warning: DCP-104 Power"},
                {"yes":"Warning: DCP-105 Power","no":"Resolved Warning: DCP-105 Power"},
                {"yes":"Fault: DCP-101 Power","no":"Resolved Fault: DCP-101 Power"},
                {"yes":"Fault: DCP-102 Power","no":"Resolved Fault: DCP-102 Power"},
                {"yes":"Fault: DCP-103 Power","no":"Resolved Fault: DCP-103 Power"},
                {"yes":"Fault: DCP-104 Power","no":"Resolved Fault: DCP-104 Power"},
                {"yes":"Fault: DCP-105 Power","no":"Resolved Fault: DCP-105 Power"},
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
                        //watchLog.eventLog(text);
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
