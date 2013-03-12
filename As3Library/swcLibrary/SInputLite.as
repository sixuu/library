package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class SInputLite extends MovieClip {
		
		var th
		var f:Function
		public function SInputLite() {
			this.visible=false
			btn.txt.text="确定"
			th=this
			txt.text="请输入内容.."
			btn.addEventListener(MouseEvent.CLICK,onBtnCK)
			closeBtn.addEventListener(MouseEvent.CLICK,onBtnCK)
			txt.addEventListener(MouseEvent.CLICK,onTxtCK)
			this.addEventListener(MouseEvent.MOUSE_DOWN,d)
		}
		private function onTxtCK(e:MouseEvent){
			if(txt.text=="请输入内容.."){
				txt.text=""
			}
		}
		public function show(onCompleteFunc:Function,str:String ="请您输入"){
			this.visible=true
			tipTxt.htmlText=str
			this.parent.setChildIndex(this,this.parent.numChildren-1)
			f=onCompleteFunc
		}
		
		private function onBtnCK(e:MouseEvent){
			this.visible=false
			if(Boolean(f)){
			   f()
			}
		}
		public function set text(str:String){
			txt.htmlText=str
		}
		public function set tip(str:String){
			tipTxt.htmlText=str
		}
		public function get tip(){
			return tipTxt.text
		}
		public function get text(){
			return txt.text
		}
		private function d(e:MouseEvent){
			if(e.target!="[object TextField]"){
			stage.addEventListener(MouseEvent.MOUSE_UP,u)
			th.startDrag()
			}
		}
		private function u(e:MouseEvent){
			th.stopDrag()
		}
		
	}
	
}
