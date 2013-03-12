/**
 * Neave Link
 * 
 * Copyright (C) 2008 Paul Neave
 * http://www.neave.com/
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation at http://www.gnu.org/licenses/gpl.html
 */

package com.littlesix.link
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	public class NeaveLink
	{
		private var container:DisplayObjectContainer;
		private var stage:Stage;
		private var canvasWidth:Number;
		private var canvasHeight:Number;
		private var onSite:Boolean;
		private var button:NeaveLinkButton;
		
		/**
		 * Creates a link to www.littlesix.com.cn at the bottom of the stage
		 */
		public function NeaveLink(container:DisplayObjectContainer, canvasWidth:Number, canvasHeight:Number)
		{
			this.container = container;
			this.stage = container.stage;
			this.canvasWidth = canvasWidth;
			this.canvasHeight = canvasHeight;
			
			onSite = stage.loaderInfo.url.indexOf("file:///") != -1 || stage.loaderInfo.url.indexOf("http://localhost/") != -1 || stage.loaderInfo.url.indexOf("http://www.airbaby.org/") != -1;
			//if (onSite) return;
			
			button = new NeaveLinkButton();
			button.addEventListener(MouseEvent.CLICK, navigateToNeave);
			container.addChild(button);
			button.x = canvasWidth / 2;
			
			stage.addEventListener(Event.RESIZE, linkResizeListener);
			linkResizeListener();
		}
		
		/**
		 * Opens a URL request to www.neave.com
		 */
		private function navigateToNeave(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.littlesix.com.cn/"), "_top");
		}
		
		/**
		 * Positions the link near the bottom of the stage
		 */
		private function linkResizeListener(e:Event = null):void
		{
			button.y = Math.ceil(canvasHeight + (stage.stageHeight - canvasHeight - 20) / 2);
		}
		
		/**
		 * Removes the link and all other referenced objects
		 */
		public function destroy():void
		{
			if (onSite) return;
			
			stage.removeEventListener(MouseEvent.CLICK, navigateToNeave);
			stage.removeEventListener(Event.RESIZE, linkResizeListener);
			container.removeChild(button);
			button = null;
		}
	}
}