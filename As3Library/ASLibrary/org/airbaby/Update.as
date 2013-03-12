/* ------------------------------------autoUpdate  -----------------
   ----------------------------------- 自动升级---------------------
eg:

import org.airbaby.Update
Update.CheckUpdateAt("http://www.littlesix.com.cn/air/applications/updates/airmusic.xml",0,0,0,0,0)

*/


package org.airbaby
{
	import air.update.events.UpdateEvent;
	import air.update.ApplicationUpdaterUI;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
    import flash.filesystem.File
	public class Update
	{
		private static var _updater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		private static var cpyRightLoader:URLLoader=new URLLoader();
		public function Update()
		{

		}
		public static function CheckUpdateUseSysAt(url:String="http://yourserver/description.xml",downloadUpdateVisible=1,updateProgressVisible=1,installUpdateVisible=1,fileUpdateVisible=1,unexpectedErrorVisible=1):void
		{
			//updater framework   
			_updater.updateURL = url;
			_updater.isCheckForUpdateVisible = false;
			_updater.isDownloadProgressVisible = updateProgressVisible;
			_updater.isDownloadUpdateVisible = downloadUpdateVisible;
			_updater.isInstallUpdateVisible = installUpdateVisible;
			_updater.isFileUpdateVisible = fileUpdateVisible;
			_updater.isUnexpectedErrorVisible = unexpectedErrorVisible;
			_updater.addEventListener(UpdateEvent.INITIALIZED, onUpdateInitializedHandler);
			_updater.initialize();
		}
		public static function checkUpdateAt(url:String,downLoaderVisible:Boolean=true,autoInstall:Boolean=false){
			var l:URLLoader=new URLLoader()
			l.load(new URLRequest(url))
			l.addEventListener(Event.COMPLETE,lok)
			function lok(e:Event){
				
			}
		}
		private static function onUpdateInitializedHandler(event:UpdateEvent):void
		{
			_updater.checkNow();
		}
		public static function InstallFile(file:File){
			_updater.installFromAIRFile(file)
		}
		public static  function getVersion():Number{
			return Number(_updater.currentVersion)
		}
		public static function checkCopyRight(onWrong:Function ,url:String )
		{

			cpyRightLoader.load(new URLRequest(url));
			cpyRightLoader.addEventListener("complete",cpyLoaded);
			cpyRightLoader.addEventListener(IOErrorEvent.IO_ERROR,io);
			function cpyLoaded(e:Event)
			{
				if (cpyRightLoader.data == "illegal")
				{
					onWrong();
				}
			}
			function io(e:IOErrorEvent)
			{

			}
		}

	}

}