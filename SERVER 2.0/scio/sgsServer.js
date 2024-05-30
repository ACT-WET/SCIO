var PROTO_PATH = './ShowInfo.proto';

var grpc = require('./../grpc-node/examples/node_modules/@grpc/grpc-js');
var protoLoader = require('./../grpc-node/examples/node_modules/@grpc/proto-loader');
var packageDefinition = protoLoader.loadSync(
    PROTO_PATH,
    {keepCase: true,
     longs: String,
     enums: String,
     defaults: true,
     oneofs: true
    });
var show_proto = grpc.loadPackageDefinition(packageDefinition).show;

/**
 * Implements the SayHello RPC method.
 */
function sayHello(call, callback) {
  callback(null, {message: 'Hello ' + call.request.name});
}

function startShow(call, callback) {
  callback(null, {session_id: 'Value is  ' +call.request.frame, error: 'Value is  ' +call.request.show_id});
}

/**
 * Starts an RPC server that receives requests for the Greeter service at the
 * sample server port
 */
function main() {
  var server = new grpc.Server();
  server.addService(show_proto.ShowService.service, {sayHello: sayHello, startShow: startShow});
  server.bindAsync('127.0.0.1:50051', grpc.ServerCredentials.createInsecure(), () => {
    console.log("gRPC server started at ");
  });
}

// Private

main();