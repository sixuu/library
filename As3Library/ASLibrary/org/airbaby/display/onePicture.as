package pic 
{
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Tiger 250942258@qq.com
	 * ...
	 */
	public class onePicture extends MovieClip
	{
		
		private var startX:Number = 0;                     //位置处理  
		private var startY:Number = 0;
	
		private var vx:Number;
		private var vy:Number;
		private var earthForce:Number = 0;
		private var wallForce:Number = -0.8;
		private var windForce:Number = 0.95;
		private var isDrag:Boolean;                        //拖拽判断
	
		private var minScaleY:Number = .3;
		private var minScaleX:Number = .335
		private var btnScaleX:Number = 2.98;
		private var btnScaleY:Number = 3.32;
		private var isScale:Boolean;                       //大小判断
		
		
		public function onePicture() 
		{
			initThis();
		}
		
		private function initThis():void
		{
			vx = 0;
			vy = 0;
			isDrag = false;
			isScale = false;
			addEvent();
		}
		
		private function addEvent():void
		{
			btn.doubleClickEnabled = true;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			btn.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			btn.addEventListener(MouseEvent.MOUSE_OUT, upHandler);
			this.addEventListener(Event.ENTER_FRAME, startMoving);
			btn.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			if (!isScale)
			{   
			    //缩放
				btn.scaleX = btnScaleX; 
				btn.scaleY = btnScaleY;
				mcCup.scaleX = mcCup.scaleY = 1;
				isScale = true;
				sideDeal();
			}
			else
			{
				btn.scaleX = btn.scaleY = 1;
				mcCup.scaleX = minScaleX
				mcCup.scaleY = minScaleY;
				isScale = false;
			}
		}
		
		//鼠标按下
		private function downHandler(e:MouseEvent):void 
		{
			this.startDrag();
			isDrag = true;
			
			var nameEvent:DataEvent = new DataEvent("ChangeDepth",true);
			nameEvent.data = e.target.parent.name;
			e.target.parent.dispatchEvent(nameEvent);
		}
		
		
		//鼠标松开
		private function upHandler(e:MouseEvent):void 
		{
			this.stopDrag();
			isDrag = false;
		}
		
		private function startMoving(e:Event):void 
		{
			
			if (!isDrag)
			{
				vy += earthForce;
				vx *= windForce;
				vy *= windForce;
				this.x += vx;
				this.y += vy;
				sideDeal();
			}
			else
			{
				 vx = (this.x - startX)/2;
				 vy = (this.y - startY)/2;
				 startX = this.x;
				 startY = this.y;

			}
		}
		
		private function sideDeal():void
		{
			if ((this.x + this.width)> stage.stageWidth) 
			{
				vx *= wallForce;
				this.x = stage.stageWidth - this.width;
			}
			if(this.x < 0)
			{
				vx *= wallForce;
				this.x = 0;
			}
			if (this.y < 0) 
			{
				vy *= wallForce;
				this.y = 0;
			}
			if ((this.y + this.height) > stage.stageHeight) 
			{
				vy *= wallForce;
				this.y = stage.stageHeight - this.height;
			}
			
			
			if (Math.abs(vx) < 0.3) 
			{
				vx = 0;
			}
			if (Math.abs(vy) < 0.3) 
			{
				vy = 0;
			}
			
		}
		
		public function setPlace():void
		{
			mcCup.scaleX = minScaleX;
			mcCup.scaleY = minScaleY;
			var midX:Number = Math.random() * (stage.stageWidth - this.width)
			var midY:Number = Math.random() * (stage.stageHeight -this.height);
			this.x = midX;
			this.y = midY;
			vx = Math.random() * 10 + 5;
			vy = vx;
		}
		
		public function loadPic(path:String):void
		{
			//载入图片模式
			var loader:Loader = new Loader();
			mcCup.addChild(loader);
			loader.load(new URLRequest(path));

		}
		public function setPic(d:Number):void
		{
			//内部图片模式
			mcCup.gotoAndStop(d);
		}
		
	}

}