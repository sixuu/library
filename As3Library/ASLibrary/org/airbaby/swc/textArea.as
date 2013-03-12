package 
{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.filters.BevelFilter;
	import flash.geom.ColorTransform;
	import flash.display.Loader;
	import flash.net.URLRequest;

	public class textArea extends MovieClip
	{

		private var sp:Sprite = new Sprite  ;
		private var w:Number;
		private var h:Number;
		private var bcolor:uint = 0;
		private var balpha:Number = .5;
		private var txtStr:String;
		private var txtColor:uint = 0;
		private var iconLoader:Loader=new Loader
		public function textArea(str:String,width:Number=300,backColor:uint=0x666666,backAlpha:Number=.5)
		{
			addChildAt(sp,0);
			addChild(iconLoader)
			this.txtStr = str;
			this.w = width;
			bcolor = backColor;
			balpha = backAlpha;
			txt.width = w;
			w = w + 5;
			txt.htmlText = str;
			h = txt.textHeight + 15;
			txt.height = h;
			init();
		}
		private function init()
		{   iconLoader.load(new URLRequest("icon.swf"))
			var flag:TFlag=new TFlag();
			sp.addChild(flag);
			flag.y = h - 15;
			flag.x = -20;
			iconLoader.x=-65
			iconLoader.y=h-40

			var bevel:BevelFilter=new BevelFilter();

			var s:ColorTransform = new ColorTransform();
			var m:uint = bcolor;
			s.color = m;
			flag.transform.colorTransform = s;
			sp.filters = [bevel];
			sp.alpha = balpha;
			sp.graphics.beginFill(bcolor);
			sp.graphics.drawRoundRect(0,0,w,h,9,9);
			sp.graphics.endFill();
		}

	}

}