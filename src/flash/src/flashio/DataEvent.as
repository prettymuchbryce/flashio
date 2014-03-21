package flashio {
	import flash.events.Event;
	
	/**
	 * FlashIO DataEvent
	 */
	public class DataEvent extends Event {
		public static var DATA:String = "DATA";
		
		private var _data:Object;
		public function DataEvent(value:Object) {
			_data = value;
			super(DATA);
		}
		
		/**
		 * Serialized JSON data
		 */
		public function get data():Object {
			return _data;
		}
		
		override public function clone():Event {
			return new DataEvent(_data);
		}
	}
}