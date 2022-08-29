const {EchoRequest} = require('./api/api_grpc_web_pb');
const {EchoServerClient} = require('./api/api_pb');

const host = "http://localhost:80"

let echoClient = new EchoServerClient(host);

let request = new EchoRequest();
echoClient.echo(request, {}, function (err, response) {
    console.log("err", err)
    console.log("response", response)
});
