/**
 * Neave Light ...light up your music
 * 
 * Copyright (C) 2008 Paul Neave
 * http://www.neave.com/
 * 
 * @author		Paul Neave
 * @version		1.0.0
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation at http://www.gnu.org/licenses/gpl.html
 */

package com.littlesix.light
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	import com.littlesix.link.*;
	
	public class NeaveLight
	{
		// Main variables
		private var container:DisplayObjectContainer;
		private var stage:Stage;
		private var canvasWidth:int;
		private var canvasHeight:int;
		private var light:Sprite;
		private var redOrb1:BigOrb;
		private var redOrb2:BigOrb;
		private var blueOrb1:BigOrb;
		private var blueOrb2:BigOrb;
		private var greenOrb1:BigOrb;
		private var greenOrb2:BigOrb;
		private var whiteOrb1:BigOrb;
		private var whiteOrb2:BigOrb;
		private var bmp:Bitmap;
		private var blackBitmap:BitmapData;
		private var m:Matrix;
		private var p:Point;
		private var blur:BlurFilter;
		private var link:NeaveLink;
		
		/**
		 * Creates a new instance of Neave Light on the stage
		 * 
		 * @param	container	The display object (sprite or movieclip) to contain Neave Light
		 * @param	mic			The microphone object to use to animate the lights
		 * @param	width		The width of Neave Light
		 * @param	height		The height of Neave Light
		 */
		public function NeaveLight(container:DisplayObjectContainer,  width:int = 770, height:int = 400)
		{
			this.container = container;
			stage = container.stage;
			//this.mic = mic;
			canvasWidth = width;
			canvasHeight = height;
			initStage();
			initLights();
			initBitmap();
			//initLink();
		}
		
		/**
		 * Sets up stage listeners
		 */
		private function initStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stageResizeListener);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			stage.addEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Sets up light properties
		 */
		private function initLights():void
		{
			/*var midX:Number = canvasWidth / 2;
			var midY:Number = canvasHeight / 2;*/
			var midX:Number = 1
			var midY:Number = 1
			
			// Create the orbs
			redOrb1 = new BigOrb(0xFF0000, midX, midY);
			redOrb2 = new BigOrb(0xFF0000, midX, midY);
			blueOrb1 = new BigOrb(0x00FF00, midX, midY);
			blueOrb2 = new BigOrb(0x00FF00, midX, midY);
			greenOrb1 = new BigOrb(0x0000FF, midX, midY);
			greenOrb2 = new BigOrb(0x0000FF, midX, midY);
			whiteOrb1 = new BigOrb(0xFFFFFF, midX, midY);
			whiteOrb2 = new BigOrb(0xFFFFFF, midX, midY);
			
			// Add the orbs
			light = new Sprite();
			light.addChild(redOrb1);
			light.addChild(redOrb2);
			light.addChild(blueOrb1);
			light.addChild(blueOrb2);
			light.addChild(greenOrb1);
			light.addChild(greenOrb2);
			light.addChild(whiteOrb1);
			light.addChild(whiteOrb2);
		}
		
		/**
		 * Sets up the main bitmap
		 */
		private function initBitmap():void
		{
			// Stage sizes
			var sw:int = stage.stageWidth;
			var sh:int = stage.stageHeight;
			var sw4:int = Math.ceil(sw / 4);
			var sh4:int = Math.ceil(sh / 4);
			
			// Create the main bitmap to draw into (and quarter the size to run faster)
			bmp = new Bitmap(new BitmapData(sw, sh, true,0));
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = 4;
			bmp.x = 0;
			bmp.y = 0;
			container.addChild(bmp);
			
			// Create bitmap data for fading into black
			blackBitmap = new BitmapData(sw, sh, true, 0x00000000);
			
			// Bitmap is moved over into position then quartered in size to run faster
			m = new Matrix();
			m.translate(-bmp.x, -bmp.y);
			m.scale(0.25, 0.25);
			
			// Origin and blur filter
			p = new Point(0, 0);
			blur = new BlurFilter(64, 64, 2);
		}
		
		/**
		 * Creates a link to Neave.com above the bitmap
		 */
		private function initLink():void
		{
			if (link) link.destroy();
			link = new NeaveLink(container, canvasWidth, canvasHeight);
		}
		
		/**
		 * Draws the light animation
		 */
		private function drawLight(a:Number):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			// Draw the orbs
			redOrb1.draw(a * Math.random(), w, h,stage);
			redOrb2.draw(a * Math.random(), w, h,stage);
			blueOrb1.draw(a * Math.random(), w, h,stage);
			blueOrb2.draw(a * Math.random(), w, h,stage);
			greenOrb1.draw(a * Math.random(), w, h,stage);
			greenOrb2.draw(a * Math.random(), w, h,stage);
			whiteOrb1.draw(a * Math.random(), w, h,stage);
			whiteOrb2.draw(a * Math.random(), w, h,stage);
		}
		
		/**
		 * Draw the orbs into the main bitmap and repeatedly fades them out
		 */
		private function drawBitmap():void
		{
			// Repeatedly fade out and blur
			var b:BitmapData = bmp.bitmapData;
			b.lock();
			b.merge(blackBitmap, b.rect, p, 8, 8, 8, 0);
			b.applyFilter(b, b.rect, p, blur);
			b.draw(light, m, null, BlendMode.ADD);
			b.unlock();
		}
		
		/**
		 * Listens for mouse press
		 */
		private function mouseDownListener(e:MouseEvent):void
		{
			// Fake a microphone respone on mouse press
			
				for (var i:int = 5; i--; ) drawLight(1);
			
		}
		
		/**
		 * Frees up memory by disposing all bitmap data
		 */
		private function disposeBitmaps():void
		{
			bmp.bitmapData.dispose();
			bmp.bitmapData = null;
			blackBitmap.dispose();
			blackBitmap = null;
		}
		
		/**
		 * Remove light orbs and all other objects
		 */
		public function destroy():void
		{
			stage.removeEventListener(Event.RESIZE, stageResizeListener);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			stage.removeEventListener(Event.ENTER_FRAME, update);
			container.removeChild(bmp);
			disposeBitmaps();
			link.destroy();
		}
		
		/**
		 * Listens for stage resize
		 */
		private function stageResizeListener(e:Event):void
		{
			// Start again with the bitmap if the stage is resized
			light.x=stage.stageWidth/2
			light.y=stage.stageHeight/2
			container.removeChild(bmp);
			disposeBitmaps();
			initBitmap();
			//initLink()
		}
		
		/**
		 * Updates the animation
		 */
		private function update(e:Event):void
		{
			drawLight(0);
			drawBitmap();
		}
		
	}
}