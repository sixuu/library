package org.airbaby
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.SharedObject;

	public class Cookie extends MovieClip
	{
       
		public function Cookie()
		{

		}
		public static function setCookie(cookieName:String,thecookie:Object,maxCookieSize=0)
		{ 
            var so:SharedObject=SharedObject.getLocal(cookieName,"/")
			so.data.datas=thecookie
			//trace("cookie creating size:"+so.size)
			so.flush (maxCookieSize)
		}
		
         public static function getCookie(cookieName:String )
		{ 
            var so:SharedObject=SharedObject.getLocal(cookieName,"/")
			//trace("cookie size is "+so.size)
			return so.data.datas
			
		}
		
         public static function clearCookie(clearedCookieName:String )
		{ 
            var so:SharedObject=SharedObject.getLocal(clearedCookieName,"/")
			so.clear()
			
		}
		

	}

}