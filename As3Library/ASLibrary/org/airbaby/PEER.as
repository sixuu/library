package org.airbaby
{
	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	import org.airbaby.events.PeerEvent;
	[Event(name = "getPeerId",type = "org.airbaby.events.PeerEvent")]
	public class PEER extends Sprite
	{
		private var SERVER_ADD;
		private var APP_ADD;
		private var nc:NetConnection=new NetConnection();
		public function PEER(serverAddress:String="rtmfp://p2p.rtmfp.net/",appAddress:String="d18587b1da82eece261ccb2d-666aefa49c33")
		{
			SERVER_ADD = serverAddress;
			APP_ADD = appAddress;
			nc.connect(serverAddress+appAddress);
			nc.addEventListener(NetStatusEvent.NET_STATUS,ncHandler);
		}
		private function ncHandler(e:NetStatusEvent)
		{
			nc.removeEventListener(NetStatusEvent.NET_STATUS,ncHandler);
			var evt:PeerEvent = new PeerEvent("getPeerId");
			evt.ncMessage = e.info.code;
			evt.appKey = APP_ADD;
			evt.serverAdd = SERVER_ADD;
			evt.nc = nc;
			if (nc.connected)
			{
				evt.peerID = nc.nearID;
			}
			this.dispatchEvent(evt);


		}


	}

}