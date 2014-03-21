var EventEmitter = require('events').EventEmitter;
var net = require('net');
var util = require('util');

var Server = function(port) {
    var self = this;
    var clientsSoFar = 0;

    var server = net.createServer(function(socket) {
        socket.id = clientsSoFar;
        clientsSoFar++;

        socket.on('socket', function(socket) {
            self.emit('connect', { socket: socket });
        });

        socket.on('data', function(socketData) {
            //Flash wants a policy file.
            if (socketData.toString('utf8', 0) === "<policy-file-request/>\0") {
                var policyFile = "<cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\"/></cross-domain-policy>\0";
                socket.write(policyFile, 'utf8');
                return;
            }

            var raw = socketData.toString('utf8');

            try {
                //-1 because we are removing the null terminator (\0) that flash appends to the message
                var jsonData = JSON.parse(raw.slice(0, raw.length - 1));
            } catch (error) {
                //invalid json
                self.emit('error', new Error('Failed to parse JSON from client.'));
                return;
            }

            if (jsonData !== undefined) {
                self.emit('data', { socket: socket, message: jsonData });
            }
        });

        socket.on('error', function(error) {
            error.socket = socket;
            self.emit('error', error);
        });

        // Client is requesting to disconnect naturally. This will be followed shortly
        // by a close event. Not really any need to care about this, but here it is anyway.
        socket.on('disconnect', function() {
            self.emit('disconnect', { socket: socket });
        });

        socket.on('timeout', function() {
            //TODO
        });

        // Client has exited, or otherwise closed their socket.
        socket.on('close', function() {
            self.emit('end', { socket: socket});
        });

    }).listen(port);


    server.on('connection', function(socket) {
        self.emit('connect', { socket: socket });
    });

    this.send = function(socket, messageObject) {
        var message = JSON.stringify(messageObject);
        socket.write(message + "\0", 'utf8');
    };
};

var flashio = {};

flashio.createServer = function(port) {
    return new Server(port);
};

util.inherits(Server, EventEmitter);

module.exports = flashio;