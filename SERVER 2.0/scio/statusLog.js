
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
    var status_GasPressure = [];

    
if (PLCConnected){

    plc_client.readHoldingRegister(50,1,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
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

    plc_client.readHoldingRegister(55,1,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
            // Show Stoppers - atho
            fault_ShowStoppers.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0); // ShowStopper Estop Active
        }
    });//end of first PLC modbus call  

    plc_client.readHoldingRegister(60,1,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
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

    plc_client.readHoldingRegister(65,1,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
            // Show Stoppers - atho
            status_WarningFaults.push(nthBit(resp.register[0],0) ? nthBit(resp.register[0],0) : 0);   // WaterQuality Warning
            status_WarningFaults.push(nthBit(resp.register[0],1) ? nthBit(resp.register[0],1) : 0);   // Basin LL WaterLevel Warning
            status_WarningFaults.push(nthBit(resp.register[0],2) ? nthBit(resp.register[0],2) : 0);   // Weather Station Warning
            status_WarningFaults.push(nthBit(resp.register[0],3) ? nthBit(resp.register[0],3) : 0);   // CleanStrainer Warning
            status_WarningFaults.push(nthBit(resp.register[0],4) ? nthBit(resp.register[0],4) : 0);   // VFD/Pump Warning
            status_WarningFaults.push(nthBit(resp.register[0],5) ? nthBit(resp.register[0],5) : 0);   // DC Power Warning
        }
    });//end of first PLC modbus call 

    plc_client.readHoldingRegister(70,1,function(resp1){
        
        if (resp1 != undefined && resp1 != null){  
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

        status_WaterQuality.push(nthBit(resp.register[2],0) ? nthBit(resp.register[2],0) : 0);     // DCM512 Communication Fault
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

        fault_PUMPS.push(nthBit(resp.register[5],6) ? nthBit(resp.register[5],6) : 0);   // Ozone Hand Mode 
        fault_PUMPS.push(nthBit(resp.register[5],7) ? nthBit(resp.register[5],7) : 0);   // Ozone Auto Mode  
        fault_PUMPS.push(nthBit(resp.register[5],8) ? nthBit(resp.register[5],8) : 0);   // Ozone Enabled 
        fault_PUMPS.push(nthBit(resp.register[5],9) ? nthBit(resp.register[5],9) : 0);   // Ozone Pump Running 
        fault_PUMPS.push(nthBit(resp.register[5],10) ? nthBit(resp.register[5],10) : 0); // Ozone Pump Fault 
        fault_PUMPS.push(nthBit(resp.register[5],11) ? nthBit(resp.register[5],11) : 0); // Ozone Generator Active 
        fault_PUMPS.push(nthBit(resp.register[5],12) ? nthBit(resp.register[5],12) : 0); // Ozone Destruct Active 

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



        fault_PUMPS.push(nthBit(resp.register[3],6) ? nthBit(resp.register[3],6) : 0);      // VFD 201 PumpFault (Filter Pump)
        fault_PUMPS.push(nthBit(resp.register[3],7) ? nthBit(resp.register[3],7) : 0);      // VFD 202 PumpFault (Refelcting Pool Pump)
        fault_PUMPS.push(nthBit(resp.register[3],8) ? nthBit(resp.register[3],8) : 0);      // VFD 203 PumpFault (Level 2 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],9) ? nthBit(resp.register[3],9) : 0);      // VFD 204 PumpFault (Level 3 Pendant Dropper Pump)
        fault_PUMPS.push(nthBit(resp.register[3],10) ? nthBit(resp.register[3],10) : 0);    // VFD 205 PumpFault (Level 4 Pendant Dropper Pump)

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
                            "DCM512 Communication Fault": status_WaterQuality[13],
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
                            "****************************WIND STATUS********************" : "4",   
                            "ST2001 Abort_Show": status_windSensor[0],
                            "ST2001 Above_Hi": status_windSensor[1],
                            "ST2001 Above_Med": status_windSensor[2],
                            "ST2001 Above_Low": status_windSensor[3],
                            "ST2001 No_Wind": status_windSensor[4],
                            "ST2001 Speed_Channel_Fault": status_windSensor[5],
                            "ST2001 Direction_Channel_Fault": status_windSensor[6],
                            "***************************PUMPS STATUS**************************" : "5",
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
