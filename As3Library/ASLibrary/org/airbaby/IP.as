/* QQIP.as  获取客户端ip 以及所属的省份 ，地区 

@作者：Airbaby   QQ：133152019  ok@littlesix.com.cn


使用代码示例  eg：

import org.airbaby.QQIP

QQIP.showIP("http://fw.qq.com/ipaddress",afterGetIP)

function afterGetIP(){
	
trace(QQIP.at[0], QQIP.at[1] , QQIP.at[2]) // 210.46.97.21 黑龙江 哈尔滨

}
*/
package org.airbaby
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.*;

	public class IP
	{
		public static var at;
		public static var clientIPLoader:URLLoader = new URLLoader  ;
		public function IP()
		{

		}
		public static function showIP(url:String ,afterGetIP:Function)
		{

			System.useCodePage = true;
			//QQapi:http://fw.qq.com/ipaddress
			clientIPLoader.load(new URLRequest(url));
			clientIPLoader.addEventListener(Event.COMPLETE,loaded);
			function loaded(e)
			{
				var s:String = clientIPLoader.data;
				//var re:RegExp=/\([^)]*\)/
				var re1:RegExp = /\"[^"]*\"/g;
				//var r=s.match(re)
				at = s.match(re1);
				//trace(a[0].substr(1,a[0].length-2));
				at=new Array((at[0].substr(1,at[0].length-2)),(at[2].substr(1,at[2].length-3)),(at[3].substr(1,at[3].length-3)));
				afterGetIP();
				clientIPLoader.removeEventListener(Event.COMPLETE,loaded);


			}
		}

	}

}