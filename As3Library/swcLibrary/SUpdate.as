/* ------------------------------------autoUpdate  -----------------
   ----------------------------------- 自动升级---------------------
eg:
SUpdate.

*/


package 
{
	import air.update.events.UpdateEvent;
	import air.update.ApplicationUpdaterUI;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import com.sixuu.SFile;
	import com.sixuu.events.SProgressEvent;
	import com.sixuu.events.SEvent;
	import com.sixuu.events.SErrorEvent;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.events.MouseEvent;


	public class SUpdate extends MovieClip
	{
		private static var _updater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		private static var cpyRightLoader:URLLoader=new URLLoader();
		private static var th;
        private static var con:SUPContent=new SUPContent()
		public function SUpdate()
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
		public  static function checkUpdateAt(url:String,downLoaderVisible:Boolean=true)
		{
		    _updater.updateURL = url;
			_updater.initialize();
			var l:URLLoader=new URLLoader();
			l.load(new URLRequest(url));
			l.addEventListener(Event.COMPLETE,lok);
			function lok(e:Event)
			{
				var xml:XML = XML(l.data);
				//trace(xml,xml.url,getVersion())
				if (Number(xml.versionNumber)>getVersion())
				{
					var f:SFile = new SFile(SFile.documentsDirectory.resolvePath("temp_update.air").nativePath);
					if (downLoaderVisible)
					{
						var option:NativeWindowInitOptions=new NativeWindowInitOptions()
						option.systemChrome = "none";
						option.transparent = true;
						option.type = "lightweight";
						var win:NativeWindow=new NativeWindow(option);
						win.stage.scaleMode = "noScale";
						win.title = "—检测到有更新";
						win.stage.align = "TL";
						win.width = 560;
						win.height = 430;
						win.x=100
						win.y=60
						con.back.addEventListener(MouseEvent.MOUSE_DOWN,function onDOWN(e){
												  win.startMove()
												  })
	                    con.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,function onDOWN1(e){
												  win.close()
												  })
						con.btn.txt.text = "下载";
						con.des.text = xml.description;
						con.cv.text = getVersion().toString();
						con.nv.text = xml.versionNumber;
						win.stage.addChild(con);
						win.activate();
						var btnLabel = "down";
						con.btn.addEventListener(MouseEvent.CLICK,btnClick);
						f.addEventListener(SProgressEvent.FILE_DOWN_PROGRESS,onProgress);
						f.addEventListener(SErrorEvent.ERROR,onError);
					}
					f.addEventListener(SEvent.FILE_DOWN_COMPLETE,onComplete);
					
					function btnClick(e:MouseEvent)
					{
						if (btnLabel=="down")
						{
							f.downloadFile(xml.url);
							con.prog.visible = true;
							btnLabel = "downloading";
							con.btn.txt.text = "下载中";
						}
						if (btnLabel=="install")

						{
							_updater.installFromAIRFile(f);
							con.btn.txt.text = "正在安装";
						}

					}
					function onError(e:SErrorEvent)
					{
						con.info.text = "下载失败." + e.errorType;
					}
					function onProgress(e:SProgressEvent)
					{
						con.prog.dtxt.text = int(e.bytesLoaded * 100 / e.bytesTotal) + "%  Total: " + e.bytesTotal / 1000 + "KB";
						con.prog.gotoAndStop(int(e.bytesLoaded*100/e.bytesTotal));
					}
					function onComplete(e:SEvent)
					{
						con.info.text = "下载完成,是否立即安装？";
						con.btn.txt.text = "安装";
						btnLabel = "install";
					}

				}
			}
		}
		private static function onUpdateInitializedHandler(event:UpdateEvent):void
		{
			_updater.checkNow();
		}
		public static function InstallFile(file:File)
		{
			_updater.installFromAIRFile(file);
		}
		public static function getVersion():Number
		{
			return parseFloat(_updater.currentVersion);
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