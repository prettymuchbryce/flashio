> flashio facilitates JSON/Object communication from Flash to node.js over a TCP socket.

The goal of this project is to create a reliable way for Flash to talk to node.js over a typical (not a websocket) TCP connection. 

## Server (node.js)

### Installation

Install via npm `npm install flashio`

### Usage

You can create a server via

    var flashio = require('flashio);
    var server = flashio.createServer(port);


You can then listen to various events via

    server.on('connect', function(data) {
      console.log(data.socket.id + " connected");
    };

Events are
* .on('**data**', function(data)) *emitted when client sends data*
* .on('**close**', function(data)) *emitted when client disconects*
* .on('**error**', function(error)) *emitted on error*
* .on('**connect**', function(data)) *emitted on connect*

All event callback parameters (data or error) contain a data.socket or error.socket value representing a client's socket.
Each socket has a unique id property via `data.socket.id`

In order to send data to the client use

`server.send(socket, { message: "Hi client" });`

## Client (flash)

### Installation

Find the flashio package in this repository under src/flash/src/flashio. Include this package in your AS3 project.

### Usage

You can create a client via

    var client:FlashIO = new FlashIO(host, port);
    client.connect();

You can listen to various events via

    client.addEventListener(DataEvent.DATA, function(event:DataEvent):void {
    	trace(data.message);
    });
    
Events are
* Event.CONNECT
* Event.CLOSE
* IOErrorEvent.IO_ERROR
* SecurityErrorEvent.SECURITY_ERROR
* flashio.DataEvent

In order to send data to the server use

`client.send({ message: "Hi server" });`

## Other information

This is a work in progress.
