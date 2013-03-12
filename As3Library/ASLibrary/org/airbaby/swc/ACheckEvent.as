package  {
	import flash.events.Event;
	
	public class ACheckEvent extends Event{
        public static const CHANGE:String="change"
		public var selected:Boolean
		public function ACheckEvent() {
			super(CHANGE)
		}
		

	}
	
}
