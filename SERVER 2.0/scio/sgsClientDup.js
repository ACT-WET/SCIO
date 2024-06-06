  watchDog = require("./Includes/watchDog");
  fs = require("fs");
  homeD = __dirname; 
  proj = 'SCIO'; 
  const PROTO_PATH = './root/scio/ShowInfo.proto';
  const math = require('mathjs');
  tmpshows  = [];
  for ( var j =0; j <= 1024 ; j++){
      //watchDog.eventLog('values ' +JSON.stringify(temp));
      tmpshows[j]={"name":"-","number":j,"duration":0,"test":false,"color":1};
  }
  for ( var k =1025; k <= 2049 ; k++){
      //watchDog.eventLog('values ' +JSON.stringify(temp));
      tmpshows[k]={"name":"-","number":k-1025,"duration":0,"test":true,"color":1};
  }
  //console.log('Before await3');

  const parseArgs = require('./../grpc-node/examples/node_modules/minimist');
  //console.log('Before await4');
  const grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
  //console.log('Before await5');
  const protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
  //console.log('Before await6');
  const packageDefinition = protoLoader.loadSync(PROTO_PATH,
    {
     keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
  //console.log('Before await7');
  const show_proto = grpc.loadPackageDefinition(packageDefinition).show;

  const printShowInfo = (shows) => {
    for (const show of shows) {
          var nem = show.name;
          // watchDog.eventLog('Name: '+show.name);
          // watchDog.eventLog('Number: '+show.plc_id);
          // watchDog.eventLog('Duration: '+math.ceil(show.frame_count/30));
          tmpshows[show.plc_id]={"name":show.name,"number":show.plc_id,"duration":math.ceil(show.frame_count/30),"test": false,"color":1};
          watchDog.eventLog('Shows '+JSON.stringify(tmpshows));
        }
        fs.writeFileSync(homeD+'/UserFiles/shows.txt',JSON.stringify(tmpshows),'utf-8');
        fs.writeFileSync(homeD+'/UserFiles/showsBkp.txt',JSON.stringify(tmpshows),'utf-8');
    };

  function sgsReadShows(client) {

    return new Promise((resolve, reject) => {
        client.Init({}, (err, response) => {

            if (err) {
              watchDog.eventLog('Error during Init:', err);
            } else {
              watchDog.eventLog('Init Response:');
              printShowInfo(response.shows);
            }
            resolve();
        });
    });
  }

  async function main() {
    const client = new show_proto.ShowService('10.0.6.200:50051',grpc.credentials.createInsecure());
    await sgsReadShows(client);
  }

  function riskyParse(text,what,bkp,xsafe){

    var lamb=0;

    try{

        //First we want to make sure there are no extra qiated inside the text while parsing
        text = elminiateExtraQoutes(what,text);
        lamb = JSON.parse(text);

    }catch(e){

        watchDog.eventLog(what + ':Server Read Successful');
        watchDog.eventLog("Caught this :" +JSON.stringify(e));

    }finally{

        //Check if extra file safety check is desired
        //TODO: Check what is this used for and f we can eliminate it

        if(xsafe){

            if(riskyParse(fs.readFileSync(__dirname+'/UserFiles/'+bkp+'.txt','utf-8'),'xsafe '+what) !== 0){
                //Parsing of Bkp file was successfule, do nothing

            }else if(lamb !== 0){
                fs.writeFileSync(__dirname+'/UserFiles/'+bkp+'.txt',text,'utf-8');

            }
        }

        //Check if parsing to back-up on initial failure is not desired

        if(!bkp || (bkp && lamb !== 0)){
            
            lamb = (lamb === null) ? 0 : lamb;
            return lamb;
        
        }
        else{
            watchDog.eventLog(what+" file recovered and parsed to bkp");
            lamb = fs.readFileSync(__dirname+'/UserFiles/'+bkp+'.txt','utf-8');
            fs.writeFileSync(__dirname+'/UserFiles/'+what+'.txt',lamb,'utf-8');
            return riskyParse(lamb,what);
        }
    }
}

  main();
/*
 *
 * Copyright 2023 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
  

  // const startShowRequest = { name: 'OpeningShow_debug_1716512335.360731' };
  // client.StartShow(startShowRequest, (err, response) => {
  //   if (err) {
  //     console.error('Error during StartShow:', err);
  //   } else if (response.error) {
  //     console.error(`Failed to start show: ${response.error}`);
  //   } else {
  //     console.log(`Show started with session ID: ${response.session_id}`);
  //   }
  // });

  // const stopShowRequest = { session_id: '2e76f4ff-e14f-49cb-a4ae-d80ecf84f586' };
  // client.StopShow(stopShowRequest, (err, response) => {
  //   if (err) {
  //     console.error('Error during StopShow:', err);
  //   } else if (response.error) {
  //     console.error(`Failed to stop show: ${response.error}`);
  //   } else {
  //     console.log('Show stopped successfully');
  //   }
  // });


  // syntax = "proto3";

  // option optimize_for = SPEED;

  // import "google/protobuf/empty.proto";
  // import "google/protobuf/timestamp.proto";

  // package show;

  // // The greeting service definition.
  // service ShowService {
  //   // Sends a greeting
  //   rpc Init(google.protobuf.Empty) returns (InitResponse) {}
  //   rpc StartShow(StartShowRequest) returns (StartShowResponse) {}
  //   rpc StopShow(StopShowRequst) returns (StopShowResponse) {}
  // }

  // message StartShowRequest {
  //   string show_id = 1;
  //   uint32 frame = 2;
  // }

  // message StartShowResponse {
  //   oneof disco {
  //     string session_id = 1;
  //     string error = 2;
  //   }
  // }

  // message StopShowRequst {
  //   string session_id = 1;
  // }

  // message StopShowResponse {
  //   optional string error = 2;
  // }

  // message ShowInfo {
  //   string show_id = 1 [default="0.1.0"];
  //   string name = 2 [default="0.1.0"];
  //   uint32 frame_count = 3 [default=2];
  //   google.protobuf.Timestamp mtime = 4 [default=45];
  // }

  // message InitResponse {
  //   repeated ShowInfo shows = 1;
  // }


  // var PROTO_PATH = './ShowInfo.proto';

  // var parseArgs = require('./../grpc-node/examples/node_modules/minimist');
  // var grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
  // var protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
  // var packageDefinition = protoLoader.loadSync(
  //     PROTO_PATH,
  //     {
  //      keepCase: true,
  //      longs: String,
  //      enums: String,
  //      defaults: true,
  //      oneofs: true
  //     });
  // var show_proto = grpc.loadPackageDefinition(packageDefinition).show;

  // function main() {

  //   var argv = parseArgs(process.argv.slice(2), {
  //     string: 'target'
  //   });

  //   var target;
    
  //   if (argv.target) {
  //     target = argv.target;
  //   } else {
  //     target = 'localhost:50051';
  //   }
    
  //   var client = new show_proto.ShowService(target,grpc.credentials.createInsecure());
  //   var user;
    
  //   if (argv._.length > 0) {
  //     user = argv._[0];
  //   } else {
  //     user = 'Rakesh';
  //   }

  //   client.StartShow({show_id: user, frame: 32}, function(err, response) {
  //     console.log('Start Show Session ID:', response.session_id);
  //     console.log('Start Show Error:', response.error);
  //   });

  //   client.StopShow({session_id: user}, function(err, response) {
  //     console.log('Stop Show Error:', response.error);
  //   });

  //   client.Init(null, function(err, response) {
  //     console.log('Show ID:', response.show_id);
  //     console.log('Show Name:', response.name);
  //     console.log('Show FrameCount:', response.frame_count);
  //     console.log('Show Time:', response.mtime);
  //   });
  // }

  // main();

  // syntax = "proto3";

  // package live;
  // option optimize_for = SPEED;

  // message InitRequest {
  //     string agent = 1;
  // }

  // message WorkspaceDevice {
  //   string name = 1;
  //   uint32 len = 2;
  // }

  // message InitResponse {
  //   repeated WorkspaceDevice devices = 1;
  // }

  // message DeviceCommand {
  //   oneof device {
  //     string name = 1;
  //     uint32 idx = 2;
  //   }
  //   bytes values = 3;
  // }

  // message CommandRequest {
  //   repeated DeviceCommand devices = 1;
  // }

  // message CommandResponse {}

  // message StreamRequest {
  //   oneof request {
  //     InitRequest init = 1;
  //     CommandRequest command = 2;
  //   }
  // }

  // message StreamResponse {
  //   oneof response {
  //     string err = 1;
  //     InitResponse init = 2;
  //     CommandResponse command = 3;
  //   }
  // }

  // service LiveService {
  //     rpc Stream(stream StreamRequest) returns (stream StreamResponse) {}
  // }

  // function main() {
  //   const client = new show_proto.LiveService('10.0.4.200:50051',grpc.credentials.createInsecure());
  //   const call = client.stream();
  //   call.on('data', (response) => {
  //     if (response.response === 'init') {
  //       console.log('Received InitResponse:', response.init.devices);
  //     } else if (response.response === 'err') {
  //       console.error('Error:', response.err);
  //     }
  //   });
  //   call.on('end', () => {
  //     console.log('Stream ended');
  //   });
  //   call.on('error', (error) => {
  //     console.error('Stream error:', error);
  //   });
  //   call.on('status', (status) => {
  //     console.log('Stream status:', status);
  //   });
  //   const initRequest = {
  //     request: 'init',
  //     init: {
  //       agent: 'Rak'
  //     }
  //   };
  //   call.write(initRequest);
  // }
  // main();

  //List of Shows
  //1. OpeningShow_debug (2)_1716527541.9981039 :: Frame_Count = 10452  :: Duration = (5min 48sec 12ticks) 348 sec 12 frames
  //2. LowPower_1716542110.7783792              :: Frame_Count = 3150   :: Duration = (1min 45sec) 105 sec
  //3. Silent2_debug_1716137182.8706946         :: Frame_Count = 9620   :: Duration = (5min 20sec 20ticks) 320 sec 20 frames
  //4. nothing_9m_40s_1716562479.3428712        :: Frame_Count = 17400  :: Duration = (9min 40sec) 580 sec
  //5. Silent Show 1_debug_1716528169.5118327   :: Frame_Count = 10452  :: Duration = (5min 48sec 12ticks) 348 sec 12 frames
  //6. XX_Intro_VW_InX_debug_1716540459.0       :: Frame_Count = 6673   :: Duration = (3min 42sec 13ticks) 222 sec 13 frames