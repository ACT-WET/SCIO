function stopShow(){
  const PROTO_PATH = './root/scio/ShowInfo.proto';

  const parseArgs = require('./../grpc-node/examples/node_modules/minimist');
  const grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
  const protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
  const packageDefinition = protoLoader.loadSync(PROTO_PATH,
      {
       keepCase: true,
       longs: String,
       enums: String,
       defaults: true,
       oneofs: true
      });
  const show_proto = grpc.loadPackageDefinition(packageDefinition).show;

  const client = new show_proto.ShowService('10.0.4.200:50051',grpc.credentials.createInsecure());

  const stopShowRequest = { session_id: '55793bfa-5be9-4a7b-aab3-b215a2d6f782' };
  client.StopShow(stopShowRequest, (err, response) => {
    if (err) {
      watchDog.eventLog('Error during StopShow:', err);
      setTimeout(function(){
        stopCmdIssued = 0;
      },1000);
    } else if (response.error) {
      watchDog.eventLog(`Failed to stop show: ${response.error}`);
      setTimeout(function(){
        stopCmdIssued = 0;
      },1000);
    } else {
      watchDog.eventLog('Show stopped successfully');
      setTimeout(function(){
        stopCmdIssued = 0;
      },1000);
    }
  });

}

module.exports = stopShow;