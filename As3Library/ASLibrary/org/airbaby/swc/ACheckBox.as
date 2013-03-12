package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	[Event(name="change",type="ACheckEvent")]
	public class ACheckBox extends MovieClip
	{
        private var stageFrame:Number
		public function ACheckBox()
		{


			checkEdge.overs.visible = selectedmc.visible = false;
			checkEdge.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER,m_ov);
			this.addEventListener(MouseEvent.CLICK,on_ck);
			
		}

		private function m_ov(e:MouseEvent)
		{
			stageFrame=stage.frameRate
			stage.frameRate=24
			checkEdge.overs.visible = true;
			checkEdge.overs.alpha=1
			if (selectedmc.visible)
			{
				checkEdge.overs.alpha=.5
			}
			checkEdge.overs.gotoAndPlay(1);
			this.addEventListener(MouseEvent.ROLL_OUT,m_out);

		}
		private function m_out(e:MouseEvent)
		{
			checkEdge.overs.visible = false;
			this.removeEventListener(MouseEvent.ROLL_OUT,m_out);
			stage.frameRate=stageFrame
		}
		private function on_ck(e:MouseEvent)
		{
			selectedmc.visible = ! selectedmc.visible;
			if (selectedmc.visible)
			{
				checkEdge.overs.visible = false;
			}
			var evt:ACheckEvent=new ACheckEvent()
			evt.selected=selectedmc.visible
			dispatchEvent(evt)
		}
		public function set text(str:String){
			txt.text=str
			txt.width=txt.textWidth+5
		}
		public function get text(){
			return txt.text
		}
		public function set textColor(color:uint){
			txt.textColor=color
		}
		public function get textColor(){
			trace(txt.textColor)
		}
		public function set selecte(s:Boolean){
			selectedmc.visible=s
		}
		public function get selecte(){
			return selectedmc.visible
		}
		
	}

}