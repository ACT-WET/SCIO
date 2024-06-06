function tmdWrapper(){

  
  //========================== PLC CONNECTION ===========//

  if((PLCConnected == 0)&& (5 <= PLC_Heartbeat) && (PLC_Heartbeat < 10)){
    watchDog.eventLog('Attempted to reconnect to PLC ' +PLC_Heartbeat);

    plc_client.destroy();
    plc_client=null;

    plc_client = jsModbus.createTCPClient(502,'10.0.4.230',function(err){

      if(err){

        //watchDog.eventLog('PLC MODBUS CONNECTION FAILED');
        PLCConnected=false;

      }else{

        watchDog.eventLog('PLC MODBUS CONNECTION SUCCESSFUL');
        PLCConnected = 1;
        PLC_Heartbeat = 0;

      }

    });
  } 
  else if((PLCConnected == 0) && (PLC_Heartbeat > 10)){
    PLC_Heartbeat = 1;
  }
  
  //========================== BMS CONNECTION ===========//

  // if((BMSConnected == 0)&& (10 <= BMS_Heartbeat) && (BMS_Heartbeat < 15)){
  //   watchDog.eventLog('Attempted to reconnect to BMS ' +BMS_Heartbeat);

  //   bms_client.destroy();
  //   bms_client=null;

  //   bms_client = jsModbus.createTCPClient(502,'10.44.0.160',function(err){

  //     if(err){

  //       //watchDog.eventLog('BMS MODBUS CONNECTION FAILED');
  //       BMSConnected=false;

  //     }else{

  //       watchDog.eventLog('BMS MODBUS CONNECTION SUCCESSFUL');
  //       BMSConnected = 1;
  //       BMS_Heartbeat = 0;

  //     }

  //   });
  // } 
  // else if((BMSConnected == 0) && (BMS_Heartbeat > 60)){
  //   BMS_Heartbeat = 1;
  // }
  //end
}

module.exports=tmdWrapper;