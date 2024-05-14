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
let dummyRecord = {
    show_id: "153642", name: "Rakesh", frame_count: 12, mtime: 243445
};

/**
 * Implements the SayHello RPC method.
 */

function StartShow(call, callback) {
  callback(null, {session_id: 'Value is  ' +call.request.frame, error: 'Value is  ' +call.request.show_id});
}

function StopShow(call, callback) {
  callback(null, {error: 'Show Stopped ' +call.request.session_id});
}

function Init(call, callback) {
  callback(null, {show_id: 'Show Id is ' +dummyRecord.show_id, name: 'Show Name is ' +dummyRecord.name, frame_count: 'Frame Count is '+dummyRecord.frame_count, mtime: 'Time is  '+dummyRecord.mtime});
}

/**
 * Starts an RPC server that receives requests for the Greeter service at the
 * sample server port
 */
function main() {
  var server = new grpc.Server();
  server.addService(show_proto.ShowService.service, {StartShow: StartShow, StopShow: StopShow, Init:Init});
  server.bindAsync('127.0.0.1:50051', grpc.ServerCredentials.createInsecure(), () => {
    console.log("gRPC server started");
  });
}

// Private

main();