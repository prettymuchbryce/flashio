var flashio = require('./flashio.js');
var server = flashio.createServer(3000);

server.on('connect', function(data) {
    var socket = data.socket;
    console.log(socket.id + " connected");
});

server.on('data', function(data) {
    console.log(data.message);
    server.send(data.socket, data.message);
});

server.on('end', function(data) {
   console.log("Socket disconnected " + data.socket.id);
});

