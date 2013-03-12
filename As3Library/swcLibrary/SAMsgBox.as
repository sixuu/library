package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class SAMsgBox extends MovieClip
	{

		private var th;
		private var sFunction:Function = null;
		private var destroyFlag:Boolean=false
		public function SAMsgBox()
		{
			th = this;
			this.visible = false;
			//addEventListener(Event.ADDED_TO_STAGE,onAdd);
			sureBtn.addEventListener(MouseEvent.CLICK,onSure);
			caBtn.addEventListener(MouseEvent.CLICK,onCa);
			//this.addEventListener(MouseEvent.MOUSE_DOWN,sD);
			sureBtn.txt.text = "确定";
			caBtn.txt.text = "取消";
		}
		private function onAdd(e:Event)
		{
			//this.x = stage.stageWidth / 2;
			//this.y = stage.stageHeight / 2;
		}
		private function onSure(e:MouseEvent)
		{
			th.visible = false;
			if (sFunction!=null)
			{
				sFunction();
			}
			destroy();
		}
		private function onCa(e:MouseEvent)
		{
			th.visible = false;
			destroy();
		}
		public function showMsg(str,onSureFunction:Function=null,isDestroy:Boolean=false)
		{
			sFunction = null;
			MovieClip(parent).setChildIndex(th,MovieClip(parent).numChildren-1);
			th.visible = true;
			txt.htmlText = str;
			sFunction = onSureFunction;
			destroyFlag=isDestroy
		}
		private function sD(e:MouseEvent)
		{
			//th.startDrag();
			//stage.addEventListener(MouseEvent.MOUSE_UP,stopD);
		}
		private function stopD(e:MouseEvent)
		{
			//th.stopDrag();
			//stage.removeEventListener(MouseEvent.MOUSE_UP,stopD);
		}
		public function destroy()
		{
			if (destroyFlag)
			{
				removeEventListener(Event.ADDED_TO_STAGE,onAdd);
				sureBtn.removeEventListener(MouseEvent.CLICK,onSure);
				caBtn.removeEventListener(MouseEvent.CLICK,onCa);
				//this.removeEventListener(MouseEvent.MOUSE_DOWN,sD);
				this.parent.removeChild(this)
			}
		}


	}

}