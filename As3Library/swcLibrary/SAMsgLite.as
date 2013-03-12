package  {
	
	import flash.display.MovieClip;
	import com.greensock.TweenLite
	import flash.utils.setTimeout
	import flash.events.Event;

	public class SAMsgLite extends MovieClip {
		var th
		public function SAMsgLite() {
			this.alpha=0
			th=this
			
		}
		
		
		
		public function showMsg(str:String,duration:Number,xpos:Number=-1,ypos:Number=-1){
			xpos==-1?xpos=stage.stageWidth/2:1
			ypos==-1?ypos=stage.stageHeight/2:1
			txt.htmlText=str
			this.x=xpos
			this.y=ypos
			TweenLite.to(this,.6,{
						 alpha:1,
						 onComplete:afterTween
						 })
			function afterTween(){
				setTimeout(endMsg,duration)
				
			}
			function endMsg(){
				TweenLite.to(th,.6,{
						 alpha:0
						 })
			}
		}
		public function setText(str){
			txt.htmlText=str
		}
		public function getText():String{
			return txt.text
		}
	}
	
}
