package example {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import flashio.DataEvent;
	import flashio.FlashIO;

	public class Example extends Sprite {
		public function Example() {
			var client:FlashIO = new FlashIO("127.0.0.1", 3000);			
			client.addEventListener(Event.CONNECT, function(event:Event):void {
				var data:Object = {};
				data.message = "Hey there buddy !";
				data.otherMessage = "How are you ?";
				
				client.send(data);
			});
			
			client.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event:SecurityErrorEvent):void {
				trace(event);
			});
			
			client.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
				trace(event);
			});
			
			client.addEventListener(DataEvent.DATA, function(event:DataEvent):void {
				trace(JSON.stringify(event.data));
			});
				
			client.connect();
			
			
		}
	}
}