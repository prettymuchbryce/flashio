package flashio {
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	
	/**
	 * Mostly a wrapper for the XMLSocket object with some different error handling, and calling JSON.Stringify on the socket's "send" method.
	 */
	public class FlashIO extends EventDispatcher {
		private var _socket:XMLSocket;
		private var _host:String;
		private var _port:int;

		/**
		 * Instantiates a new FlashIO Socket.
		 * 
		 * @param host:String A fully qualified DNS domain name or an IP address in the form 111.222.333.444. You can also specify null to connect to the host server on which the SWF file resides. If the calling file is a SWF file running in a web browser, host must be in the same domain as the file.
		 * @param port:int The TCP port number on the target host used to establish a connection. In Flash Player 9.0.124.0 and later, the target host must serve a socket policy file specifying that socket connections are permitted from the host serving the SWF file to the specified port. In earlier versions of Flash Player, a socket policy file is required only if you want to connect to a port number below 1024, or if you want to connect to a host other than the one serving the SWF file.
		 */
		public function FlashIO(host:String, port:int) {
			_host = host;
			_port = port;
			_socket = new XMLSocket();
			_socket.addEventListener(flash.events.DataEvent.DATA, onSocketData);
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onSocketClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		/**
		 * Destroy the FlashIO Socket
		 */
		public function destroy():void {
			_socket.close();
			_socket.removeEventListener(flash.events.DataEvent.DATA, onSocketData);
			_socket.removeEventListener(Event.CONNECT, onConnect);
			_socket.removeEventListener(Event.CLOSE, onSocketClose);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);			
		}
		
		/**
		 * Converts the object or data specified in the object parameter to a string and transmits it to the server, followed by a zero (0) byte.
		 * 
		 * The send operation is asynchronous; it returns immediately, but the data may be transmitted at a later time. The send() method does not return a value indicating whether the data was successfully transmitted.
		 * 
		 * If you do not connect to the server using connect(), the send() operation fails.
		 * 
		 * @param object:Object — An object to send to the server
		 */
		public function send(data:Object):void {
			if (!_socket.connected) {
				throw new Error("Can't send. Not connected");
				return;
			}
			_socket.send(JSON.stringify(data));
		}
		
		/**
		 * Indicates whether this FlashIO object is currently connected. You can also check whether the connection succeeded by registering for the connect event and ioError event.
		 */
		public function get connected():Boolean {
			return _socket.connected;
		}
		
		/**
		 * Indicates the number of milliseconds to wait for a connection.
		 * 
		 * If the connection doesn't succeed within the specified time, the connection fails. The default value is 20,000 (twenty seconds).
		 */
		public function get timeout():int {
			return _socket.timeout;
		}
		
		public function set timeout(value:int):void {
			_socket.timeout = value;
		}
		
		/**
		 * Establishes a connection to the specified Internet host using the specified TCP port.
		 */
		public function connect():void {
			if (!_host) {
				throw new Error("Can't connect. No host specified.");
				return;
			}
			
			if (!_port) {
				throw new Error("Can't connect. No host specified.");
				return;
			}
			
			_socket.connect(_host, _port);
		}
		
		/**
		 * Closes the connection specified by the FlashIO object. The close event is dispatched only when the server closes the connection; it is not dispatched when you call the close() method.
		 */
		public function close():void {
			_socket.close();
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			dispatchEvent(event);
		}
		
		private function onSocketData(event:flash.events.DataEvent):void {
			var data:Object = JSON.parse(event.data);
			dispatchEvent(new flashio.DataEvent(data));
		}
		
		private function onConnect(event:Event):void {
			dispatchEvent(event);
		}
		
		private function onSocketClose(event:Event):void {
			dispatchEvent(event);
		}
		
		private function onIOError(event:IOErrorEvent):void {
			dispatchEvent(event);
		}
	}
}