function startShow(shwname){
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

  const client = new show_proto.ShowService('10.0.6.200:50051',grpc.credentials.createInsecure());

  const startShowRequest = { name: shwname};
  client.StartShow(startShowRequest, (err, response) => {
    if (err) {
      watchDog.eventLog('Error during StartShow:', err);
      setTimeout(function(){
        playCmdIssued = 0;
      },1000);
    } else if (response.error) {
      watchDog.eventLog(`Failed to start show: ${response.error}`);
      setTimeout(function(){
        playCmdIssued = 0;
      },1000);
    } else {
      watchDog.eventLog(`Show started with session ID: ${response.session_id}`);
      setTimeout(function(){
        playCmdIssued = 0;
      },1000);
    }
  });

}

module.exports = startShow;