package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent
	
	public class AMsgBox extends MovieClip {
		
		 private var th
		 private var sFunction:Function=null
		public function AMsgBox() {
			th=this
			this.visible=false
			addEventListener(Event.ADDED_TO_STAGE,onAdd)
			sureBtn.addEventListener(MouseEvent.CLICK,onSure)
			caBtn.addEventListener(MouseEvent.CLICK,onCa)
			sureBtn.txt.text="确定"
			caBtn.txt.text="取消"
		}
		 private function onAdd(e:Event){
			this.x=stage.stageWidth/2
			this.y=stage.stageHeight/2
		}
		 private function onSure(e:MouseEvent){
			th.visible=false
			if(sFunction!=null){
			   sFunction()
			}
		}
		 private function onCa(e:MouseEvent){
			th.visible=false
		}
		public function showMsg(str,onSureFunction:Function=null){
			sFunction=null
			MovieClip(parent).setChildIndex(th,MovieClip(parent).numChildren-1)
			th.visible=true
			txt.htmlText=str
			sFunction=onSureFunction
		}
		
		
	}
	
}
