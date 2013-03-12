package org.airbaby
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.net.URLVariables;

	public class RenrenLogin
	{   
		public static var rr_loader:URLLoader=new URLLoader();
		public static var rr_req:URLRequest=new URLRequest();
		public static var rr_var:URLVariables=new URLVariables();
		public function RenrenLogin(){
			
		}
		public static function Login(user:String ,pass:String,afterLoad:Function )
		{
			rr_req.url = "http://www.renren.com/PLogin.do";
			rr_req.method = URLRequestMethod.POST;

			rr_var.email = user;
			rr_var.password = pass;
			rr_var.origURL = "";
			rr_var.domain = "renren.com";
			rr_var.formName = "";
			rr_var.method = "";
			rr_var.isplogin = true;
			rr_req.data = rr_var;
			//navigateToURL(rr_req)
			rr_loader.load(rr_req);
			rr_loader.addEventListener(Event.COMPLETE,rrLoaded);
			function rrLoaded(e:Event)
			{
				afterLoad();
				
			}

		}



	}

}