/* as3 结合PHP发送邮件

  PhpMail属性：
      phpScriptURL        php脚本的地址;默认为"http://www.littlesix.com.cn/apps/mail/jmailer.php"
	  server:String       smtp服务器的地址;默认为"smtp.qq.com" 
	  userName:String     smtp的用户名;默认为"ok@airbaby.org"
	  password:String     smtp的密码;默认为"sixiqq"
	  senderMail:String   发送时使用的邮件地址;默认"ok@airbaby.org"
  
     方法：
	 sendTo(_targetMail:String,_senderName:String,_subject:String,_body:String)
	       _targetMail为邮件接收者的地址；  _senderName为发送是所使用的名字； 
		   _subject为邮件主题；    _body为邮件的主体内容 支持html
		   
     事件：
	 当发送结束后 会抛出MailEvent事件
	 事件属性
	    result:Number  发送结果 成功为1 失败为0
		phpScriptURL   发送是调用的php文件地址
		senderName     发送时使用的用户名


eg:
   import org.airbaby.PhpMail
   import org.airbaby.events.MailEvent;
   var mail:PhpMail=new PhpMail
   mail.server="smtp.qq.com"//smtp服务器地址
   mail.userName="623039447@qq.com"//smtp服务器使用的用户名
   mail.password="您的密码"
   mail.sendTo("623039447@qq.com","six","hi~","this is test")
   mail.addEventListener(MailEvent.COMPLETE,onComplete)
   function onComplete(e:MailEvent){
   trace(e.result)
	//e.result 返回发送结果，0为失败 1为成功
   }
*/
package org.airbaby {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.events.Event;
	import org.airbaby.events.MailEvent;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.system.System

	[Event(name="complete",type="org.airbaby.events.MailEvent")]
	public class PhpMail extends EventDispatcher{
        private var l:URLLoader=new URLLoader
		private var r:URLRequest=new URLRequest
		private var v:URLVariables=new URLVariables
		public var phpScriptURL="http://www.littlesix.com.cn/apps/mail/jmailer.php"
		public var server:String="smtp.qq.com"
		public var userName:String="ok@airbaby.org"
		public var password:String="sixiqq"
		public var senderMail:String="ok@airbaby.org"
		private var evt:MailEvent
		
		public function PhpMail() {
			super()
			l.addEventListener(Event.COMPLETE,sended)
			r.method="post"
			r.data=v
			System.useCodePage=true
		}
		public function sendTo(_targetMail:String,_senderName:String,_subject:String,_body:String){
			v.server=server
			v.username=userName
			v.password=password
			v.sendermail=senderMail
			v.sendername=_senderName
			v.targetmail=_targetMail
			v.subject=_subject
			v.body=_body
			r.url=phpScriptURL
			l.load(r)
		}
		private function sended(e:Event){
			
			evt=new MailEvent("complete")
			evt.phpScriptURL=server
			evt.senderName=v.sendername
			evt.subject=v.subject
			evt.result=l.data
			evt.targetMail=v.targetmail
			dispatchEvent(evt)
		}

	}
	
}
