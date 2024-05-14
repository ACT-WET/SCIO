var PROTO_PATH = './ShowInfo.proto';

var parseArgs = require('./../grpc-node/examples/node_modules/minimist');
var grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
var protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {
     keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
var show_proto = grpc.loadPackageDefinition(packageDefinition).show;

function main() {

  var argv = parseArgs(process.argv.slice(2), {
    string: 'target'
  });

  var target;
  
  if (argv.target) {
    target = argv.target;
  } else {
    target = 'localhost:50051';
  }
  
  var client = new show_proto.ShowService(target,grpc.credentials.createInsecure());
  var user;
  
  if (argv._.length > 0) {
    user = argv._[0];
  } else {
    user = 'Rakesh';
  }

  client.StartShow({show_id: user, frame: 32}, function(err, response) {
    console.log('Start Show Session ID:', response.session_id);
    console.log('Start Show Error:', response.error);
  });

  client.StopShow({session_id: user}, function(err, response) {
    console.log('Stop Show Error:', response.error);
  });

  client.Init(null, function(err, response) {
    console.log('Show ID:', response.show_id);
    console.log('Show Name:', response.name);
    console.log('Show FrameCount:', response.frame_count);
    console.log('Show Time:', response.mtime);
  });
}

main();