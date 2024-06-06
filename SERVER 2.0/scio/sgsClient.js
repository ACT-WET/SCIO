function sgsClient(){
  // watchDog.eventLog('Before await');
  // watchDog.eventLog('Before await2');
  const PROTO_PATH = './root/scio/ShowInfo.proto';
  //watchDog.eventLog('Before await3');

  const parseArgs = require('./../grpc-node/examples/node_modules/minimist');
  //watchDog.eventLog('Before await4');
  const grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
  //watchDog.eventLog('Before await5');
  const protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
  //watchDog.eventLog('Before await6');
  const packageDefinition = protoLoader.loadSync(PROTO_PATH,
    {
     keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
  //watchDog.eventLog('Before await7');
  const show_proto = grpc.loadPackageDefinition(packageDefinition).show;
  //watchDog.eventLog('Before await8');
  const sgsClient = new show_proto.ShowService('10.0.4.200:50051',grpc.credentials.createInsecure());
  //watchDog.eventLog('Before await9');

  const printShowInfo = (shows) => {
    for (const show of shows) {
          watchDog.eventLog(
            `Name: ${show.name}, Frame Count: ${show.frame_count}, Show Number: ${show.plc_id}`,
          );
        }
    };

  sgsClient.Init({}, (err, response) => {

    if (err) {
      watchDog.eventLog('Error during Init:', err);
    } else {
      watchDog.eventLog('Init Response:');
      printShowInfo(response.shows);
    }
  });
  watchDog.eventLog('After await');

}
module.exports = sgsClient;
  
  

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