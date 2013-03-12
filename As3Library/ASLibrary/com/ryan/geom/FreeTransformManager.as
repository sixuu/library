package com.ryan.geom {
	//import as3.utils.deepTrace;
	import fl.motion.MatrixTransformer;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/*
	 * FreeTransformEvent
	 * 
	 * @author Ryan
	 * 
	 * Usage: 	var fts:FreeTransformSprite = new FreeTransformSprite(false);			
	 *			fts.registerSprite(testObj);
	 * 
	 * 			registerSprite(sourceSprite:DisplayObject):void
	 * 			Registers a mouse down listener to the DisplayObject to activate on click
	 * 
	 * 			activateSprite(sourceSprite:DisplayObject):void
	 * 			Manually acticate the handlers on a DisplayObject
	 * 
	 * 			updateAfterChange():void
	 * 			Update the handlers after the DisplayObject is modified externally
	 * 
	 * 			property showInterestingStuff
	 * 			Whether to show tracking points and angle lines
	 * 
	 * 			hideHandlers()
	 * 			hides handlers. But they will be visible again the next time the user clicks on a registered DisplayObject
	 * 
	 */
	
	public class FreeTransformManager extends Sprite {
		
		// Constants
		
		public const DEFAULT_MIN_SCALE:Number = 0.1;
		public const DEFAULT_MAX_SCALE:Number = 10;
		
		protected var me:FreeTransformManager;
		protected var dispObj:DisplayObject;
		protected var _boundingRect:Sprite;
		protected var _border:Sprite;
		protected var _showInterestingStuff:Boolean;
		protected var _configs:Dictionary;
		protected var currConfig:Object;
		protected var stageListenersAdded:Boolean;
		
		protected  var _moveHandler:Sprite;
		protected  var _tlHandler:Sprite;
		protected  var _trHandler:Sprite;
		protected  var _blHandler:Sprite;
		protected  var _brHandler:Sprite;
		protected  var _brHandlerTrue:Sprite;
		
		protected  var handlerContainer:Sprite;
		protected  var mouseAngle:Sprite;				//sprite containing the interesting stuff
		protected  var trackPointsContainer:Sprite;
		protected  var transformContainer:Sprite;
		
		protected var _localCenter:Point;
		protected function get localCenter():Point {
			return _localCenter;
		}
		
		protected var _storedX:Number = 0;
		protected var _storedY:Number = 0;
		protected var _storedRotation:Number = 0;
		protected var _storedScale:Number = 1;
		
		protected var mode:int = 0; //0:move, 1:rotate + scale
		
		protected var mustReactivate:Boolean;
		protected var mIsDown:Boolean;
		protected var oriCP:Point;
		protected var oriCPCircle:TrackPoint;
		protected var oriX:Number;
		protected var oriY:Number;
		protected var oriAngle:Number;
		protected var oriDist:Number;
		protected var dX:Number;
		protected var dY:Number;
		protected var dAngle:Number;
		protected var iMatrix:Matrix;
		
		protected var angleOffset:Number;
		protected var scaleOffset:Number;
		protected var offsetX:Number;
		protected var offsetY:Number;
		
		protected var trackPoints:Array = [];
		
		public function FreeTransformManager(showInterestingStuff:Boolean = false):void {
			
			me = this;
			iMatrix = new Matrix();
			iMatrix.identity();
			
			_configs = new Dictionary(true);
			
			transformContainer = new Sprite();
			addChild(transformContainer);
			
			_boundingRect = new Sprite();
			transformContainer.addChild(_boundingRect);
			
			handlerContainer = new Sprite();
			addChild(handlerContainer);
			_border = new Sprite();
			handlerContainer.addChild(_border);
			
			buildHandles();
			
			mouseAngle = new Sprite();
			addChild(mouseAngle);
			
			trackPointsContainer = new Sprite();
			addChild(trackPointsContainer);
			
			//add some default trackpoints
			trackPoints.push(newTrackPoint());
			trackPoints.push(newTrackPoint());
			trackPoints.push(newTrackPoint());
			
			this.showInterestingStuff = showInterestingStuff;
			
			me.addEventListener(MouseEvent.ROLL_OVER, onROver);
			me.addEventListener(MouseEvent.ROLL_OUT, onROut);
			_boundingRect.addEventListener(MouseEvent.MOUSE_DOWN, onDispObjMDown);
			
			mustReactivate = true;
		}
		
		/*
		 * Initializes the FreeTransformSprite
		 * 
		 * @sourceSprite : Object to be made transformable.
		 * @showInterestingStuff : Whether to show debug information
		 */ 
		
		public function registerSprite(sourceSprite:DisplayObject, config:Object = null):void {
			
			sourceSprite.addEventListener(MouseEvent.MOUSE_DOWN, _onSpriteFocus);
			
			function _onSpriteFocus(evt:MouseEvent):void {
				activateSprite(evt.target as DisplayObject, config);
				onDispObjMDown(evt);
			}
		}
		
		public function activateSprite(sourceSprite:DisplayObject, config:Object = null):void {
			trace('activateSprite');
			
			if (dispObj == sourceSprite) {
				return;
			}
			
			mustReactivate = false;
			
			if (config != null) {
				_configs[sourceSprite] = config;
			}
			
			if (_configs[sourceSprite] == undefined) {
				_configs[sourceSprite] = { };
			}
			currConfig = _configs[sourceSprite] as Object;
			
			dispObj = sourceSprite;
			
			if (dispObj.stage) {
				//oh right, got the stage
				_init();
			}else {
				//oh no, no stage. wait for added to stage
				dispObj.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				function onAddedToStage(evt:Event):void {
					dispObj.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					_init();
				}
			}
			
			function _init():void {
				
				conformToSprite();
				
				//Bring the sprite to the top
				var oriParent:DisplayObjectContainer = dispObj.parent as DisplayObjectContainer;
				oriParent.addChild(dispObj);
				oriParent.addChild(me);
				
				handlerContainer.visible = true;
				updateHandles();
			
				if (!stageListenersAdded) {
					stageListenersAdded = true;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, onStageMUp);
				}
					
				dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, dispObj, _storedX, _storedY, _storedRotation, _storedScale));
			}
		}
		
		public function updateAfterChange():void {
			conformToSprite();
		}
		
		protected function conformToSprite():void {
			
			var tempMatrix:Matrix = dispObj.transform.matrix;
			
			_storedX = dispObj.x;
			_storedY = dispObj.y;
			//trace('dispObj.rotation=' + dispObj.rotation );
			_storedRotation = dispObj.rotation * (Math.PI / 180);
			_storedScale = dispObj.scaleX; //assume scaleX == scaleY
			//trace('_storedRotation=' + _storedRotation);
			
			//dispObj.transform.matrix = iMatrix;
			dispObj.transform.matrix = new Matrix();
			//trace('dispObj.rotation=' + dispObj.rotation);
			
			// Draw a new bounding rect
			_boundingRect.graphics.clear();
			_boundingRect.graphics.beginFill(0xFF0000, 0);
			_boundingRect.graphics.drawRect(0, 0, dispObj.width, dispObj.height);
			_boundingRect.graphics.endFill();
			
			// Get new LocalCenter
			_localCenter = new Point(dispObj.width / 2, dispObj.height / 2);
			(trackPoints[1] as TrackPoint).update('localCenter', localCenter);
			
			transformContainer.transform.matrix = tempMatrix;
			dispObj.transform.matrix = tempMatrix;
			updateHandles();
		}
		
		/*
		public function set minScale(n:Number):void {
			_minScale = n;
		}
		public function set maxScale(n:Number):void {
			_maxScale = n;
		}
		*/
		
		public function set showInterestingStuff(v:Boolean):void {
			_showInterestingStuff = v;
			if (_showInterestingStuff) {
				mouseAngle.visible = true;
				trackPointsContainer.visible = true;
			}else {
				mouseAngle.visible = false;
				trackPointsContainer.visible = false;
			}
		}
		
		public function get showInterestingStuff():Boolean {
			return _showInterestingStuff;
		}
		
		
		
		// Handles
		protected function buildHandles():void {

			_tlHandler = genDefaulthandle();
			_trHandler = genDefaulthandle();
			_blHandler = genDefaulthandle();
			_brHandler = genDefaulthandle();
			handlerContainer.addChild(_tlHandler);
			handlerContainer.addChild(_trHandler);
			handlerContainer.addChild(_brHandler);
			handlerContainer.addChild(_blHandler);
			_tlHandler.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			_trHandler.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			_brHandler.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
			_blHandler.addEventListener(MouseEvent.MOUSE_DOWN, onMDown);
		}
		
		protected function genDefaulthandle():Sprite {
			var tempSprite:Sprite = new Sprite();
			/* A square handler
			tempSprite.graphics.beginFill(0x000000, 1);
			tempSprite.graphics.drawRect( -6, -6, 12, 12);
			tempSprite.graphics.beginFill(0xFFFFFF, 1);
			tempSprite.graphics.drawRect( -5, -5, 10, 10);
			*/
			//Circular handler
			tempSprite.graphics.beginFill(0x000000, 1);
			tempSprite.graphics.drawCircle(0, 0, 6);
			tempSprite.graphics.beginFill(0xFFFFFF, 1);
			tempSprite.graphics.drawCircle(0, 0, 5);
			tempSprite.graphics.endFill();
			
			tempSprite.useHandCursor = true;
			return tempSprite;
		}
		
		protected function genHandlePH():Sprite {
			var tempSprite:Sprite = new Sprite();
			tempSprite.graphics.drawRect( 0, 0, 0, 0);
			return tempSprite;
		}
		
		protected function updateHandles():void {
			var tempPoint:Point;
			
			_border.graphics.clear();
			_border.graphics.lineStyle(2, 0x5555FF, 1, true);
			
			//top left
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(0, 0)));
			_tlHandler.x = tempPoint.x;
			_tlHandler.y = tempPoint.y;
			_tlHandler.rotation = _storedRotation / (Math.PI / 180);
			_border.graphics.moveTo(tempPoint.x, tempPoint.y);
			
			//top right
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(_boundingRect.width, 0)));
			_trHandler.x = tempPoint.x;
			_trHandler.y = tempPoint.y;
			_trHandler.rotation = _storedRotation / (Math.PI / 180);
			_border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//bottom right
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(_boundingRect.width, _boundingRect.height)));
			_brHandler.x = tempPoint.x;
			_brHandler.y = tempPoint.y;
			_brHandler.rotation = _storedRotation / (Math.PI / 180);
			_border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//bottom left
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(0, _boundingRect.height)));
			_blHandler.x = tempPoint.x;
			_blHandler.y = tempPoint.y;
			_blHandler.rotation = _storedRotation / (Math.PI / 180);
			_border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			//top left
			tempPoint = me.globalToLocal(transformContainer.localToGlobal(new Point(0, 0)));
			_border.graphics.lineTo(tempPoint.x, tempPoint.y);
			
			/*
			_border.graphics.beginFill(0x0000FF, 1);
			_border.graphics.drawRect( -2, -2, dispObj.width + 4, 2);
			_border.graphics.drawRect( dispObj.width, 0, 2, dispObj.height);
			_border.graphics.drawRect( -2, dispObj.height, dispObj.width + 4, 2);
			_border.graphics.drawRect( -2, 0, 2, dispObj.height);
			_border.graphics.endFill();
			*/
			
		}
		
		public function hideHandlers():void {
			handlerContainer.visible = false;
		}
		
		
		
		// Move 
		protected function onDispObjMDown(evt:MouseEvent):void {
			
			if (mustReactivate) {
				activateSprite(dispObj);
			}
			
			mode = 0;
			mIsDown = true;
			
			oriX = stage.mouseX;
			oriY = stage.mouseY;
			offsetX = _storedX;
			offsetY = _storedY;
			oriCP = getRelativeCenterPoint();
			(trackPoints[2] as TrackPoint).update('oriCP', oriCP);
		}
		
		protected function onROver(evt:MouseEvent):void {
			//handlerContainer.visible = true;
			handlerContainer.alpha = 1;
			transformContainer.alpha = 1;
		}
		
		protected function onROut(evt:MouseEvent):void {
			//handlerContainer.visible = false;
			handlerContainer.alpha = 0.5;
			transformContainer.alpha = 0;
		}
		
		protected function onMDown(evt:MouseEvent):void {
			mode = 1;
			mIsDown = true;
			
			//oriX = stage.mouseX;
			//oriY = stage.mouseY;
			//oriX = me.mouseX;
			//oriY = me.mouseY;
			var currHandler:Sprite = evt.target as Sprite;
			var handlerCenter:Point = me.globalToLocal(currHandler.localToGlobal(new Point(0, 0)));
			oriX = handlerCenter.x;
			oriY = handlerCenter.y;
			
			oriCP = getRelativeCenterPoint();
			(trackPoints[2] as TrackPoint).update('oriCP', oriCP);
			
			//oriAngle = Math.atan((oriY - oriCP.y) / (oriX - oriCP.x));
			oriAngle = getAngleFromMouseCoord(oriX, oriY, oriCP);
			
			oriDist = Math.sqrt(Math.pow(oriX - oriCP.x, 2) + Math.pow(oriY - oriCP.y, 2));
			//trace('oriAngle=' + oriAngle);
			angleOffset = _storedRotation;
			scaleOffset = _storedScale;
			
			//trace('oriCP: (' + oriCP.x + ',' + oriCP.y + ')');
				
		}
		
		protected function onStageMMove(evt:MouseEvent):void {
			if (mIsDown) {
				var currX:Number;
				var currY:Number;
				
				if (mode == 0) {
					//moving
					currX = stage.mouseX;
					currY = stage.mouseY;
					dX = currX - oriX;
					dY = currY - oriY;
					
					onTranslate(dX, dY);
				}else {
					///rotate + scale
					currX = me.mouseX;
					currY = me.mouseY;
					var currAngle:Number = getAngleFromMouseCoord(currX, currY, oriCP);
					//trace('currAngle=' + currAngle);
					
					dAngle = currAngle - oriAngle; //trace('dAngle=' + dAngle);
					
					var newDist:Number = Math.sqrt(Math.pow(currX - oriCP.x, 2) + Math.pow(currY - oriCP.y, 2));
					var percentage:Number = newDist / oriDist;
					//trace('newDist=' + newDist + ', oriDist=' + oriDist + ', percentage=' + percentage);
					
					onTransform(dAngle, percentage);
					
					clear();
					drawLine(oriCP.x, oriCP.y, currX, currY, 0x110000);
					drawLine(oriCP.x, oriCP.y, oriX, oriY, 0x001100);
					
				}
			}
		}
		
		/*
		 * Returns the bearing of the mouse relative to @center
		 * 
		 */
		//private var prevQuad:int;
		protected function getAngleFromMouseCoord(mx:Number, my:Number, center:Point):Number {
			
			var relX:Number = mx - center.x;
			var relY:Number = my - center.y;
			var angle:Number;
			var quad:int; //0: top left, 1:top right, 2:bottom right, 3:bottom left
			
			//flip Y
			relY = -relY;
			//trace('currConfig:'); deepTrace(currConfig);
			if (relX == 0 || relY == 0) {			
				if (currConfig.prevQuad != undefined) {
					quad = currConfig.prevQuad;
				}else {
					quad = 0; //default to first quadrant
				}
			}
			
			if (relX > 0 && relY > 0) {
				quad = 0;
			}else if (relX > 0 && relY < 0) {
				quad = 1;
			}else if (relX < 0 && relY < 0) {
				quad = 2;
			}else if (relX < 0 && relY > 0) {
				quad = 3;
			}
			
			currConfig.prevQuad = quad;
			
			relX = Math.abs(relX);
			relY = Math.abs(relY);
			
			angle = Math.atan(relY / relX);
			switch(quad) {
				case 0:
					angle = (Math.PI / 2) - angle;
					break;
				case 1:
					angle = angle + (Math.PI / 2);
					break;
				case 2:
					angle = (Math.PI / 2) - angle + Math.PI;
					break;
				case 3:
					angle = angle + (3 * Math.PI / 2);
					break;
			}
			//trace('relX=' + relX + ', relY=' + relY + ', quad=' +quad + ', angle=' + angle);
			//trace('relX=' + relX + ', relY=' + relY + ', quad=' +quad + ', angle=' + (angle / (Math.PI / 180)));
			
			/*
			//constrain to -180 to 180
			if (angle < -Math.PI) {
				angle = (2 * Math.PI) - angle;
			}else if(angle > Math.PI) {
				angle = angle - (2 * Math.PI);
			}
			*/
			//TestFTM.instance.txtQuad.text = quad.toFixed(0);
			//TestFTM.instance.txtDAngle.text = (angle / (Math.PI / 180)).toFixed(2);
			
			return angle;
		}
		
		protected function onStageMUp(evt:MouseEvent):void {
			mIsDown = false;
			clear();
		}
		
		protected function onTranslate(dX:Number, dY:Number):void {
			//trace('onTranslate()');
			_storedX = dX + offsetX;
			_storedY = dY + offsetY;
			
			var matrix:Matrix = dispObj.transform.matrix;
			matrix.tx = _storedX;
			matrix.ty = _storedY;
			
			dispObj.transform.matrix = matrix;
			transformContainer.transform.matrix = matrix;
			updateHandles();
			
			dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, dispObj, _storedX, _storedY, _storedRotation, _storedScale));
		}
		
		/*
		 * onTransform - Roates and scales the object
		 * @angle: angle in radians
		 * @scale: percentage of original size (relative to on mouse down)
		 */
		protected function onTransform(angle:Number, scale:Number):void {
			//trace('onTransform()');
			
			_storedRotation = angle + angleOffset;
			_storedScale = scale * scaleOffset;
			
			_applyStoredProperties(); 
			dispatchEvent(new FreeTransformEvent(FreeTransformEvent.ON_TRANSFORM, dispObj, _storedX, _storedY, _storedRotation, _storedScale));
		}
		
		public function setSize(w:Number, height:Number):void {
			oriCP = getRelativeCenterPoint();
			var s:Number = w / _boundingRect.width;
			
			_storedScale = s;
			_applyStoredProperties();
		}
		
		public function setRotate(r:Number):void {
			oriCP = getRelativeCenterPoint();
			_storedRotation = r;
			_applyStoredProperties();
		}
		
		public function setRotateDeg(r:Number):void {
			setRotate(r * Math.PI / 180);
		}
		
		protected function _applyStoredProperties():void {
			
			// Constrain to -180 to 180
			if (_storedRotation < -Math.PI) {
				_storedRotation = (2 * Math.PI) + _storedRotation;
			}else if(_storedRotation > Math.PI) {
				_storedRotation = _storedRotation - (2 * Math.PI);
			}
			
			// Constrain Scale by config
			if (_storedScale < minScale) _storedScale = minScale;
			if (_storedScale > maxScale) _storedScale = maxScale;
			
			var matrix:Matrix = new Matrix();
			matrix.rotate(_storedRotation);
			matrix.scale(_storedScale, _storedScale);
			
			var transedP:Point = matrix.transformPoint(localCenter);
			(trackPoints[0] as TrackPoint).update('transedP', transedP);
			matrix.translate(-transedP.x, -transedP.y);
			
			// return to original postion
			matrix.translate(oriCP.x, oriCP.y);
			// update stored x n y
			_storedX = matrix.tx;
			_storedY = matrix.ty;
			
			dispObj.transform.matrix = matrix;
			transformContainer.transform.matrix = matrix;
			updateHandles();
			
		}
		
		public function setObjectSize(obj:DisplayObject, w:Number):void {
			
		}
		
		
		
		
		// Config accessors
		public function get minScale():Number {
			
			if (currConfig) {
				if (currConfig.minScale != undefined) {
					return currConfig.minScale;
				}else {
					//TODO: if scale is not set, check W/H settings
					if (currConfig.minW != undefined && currConfig.minH != undefined) {
						return Math.min(currConfig.minW / _boundingRect.width, currConfig.minH / _boundingRect.height);
					}else if (currConfig.minW != undefined) {
						return currConfig.minW / _boundingRect.width;
					}else if (currConfig.minH != undefined) {
						return currConfig.minH / _boundingRect.height;
					}
				}
			}
			return DEFAULT_MIN_SCALE;
		}
		
		public function get maxScale():Number {
			
			if (currConfig) {
				if (currConfig.maxScale != undefined) {
					return currConfig.maxScale;
				}else {
					//TODO: if scale is not set, check W/H settings
					if (currConfig.maxW != undefined && currConfig.maxH != undefined) {
						return Math.max(currConfig.maxW / _boundingRect.width, currConfig.maxH / _boundingRect.height);
					}else if (currConfig.maxW != undefined) {
						return currConfig.maxW / _boundingRect.width;
					}else if (currConfig.maxH != undefined) {
						return currConfig.maxH / _boundingRect.height;
					}
				}
			}
			return DEFAULT_MAX_SCALE;
		}
		
		
		// Helpers
		
		protected function getRelativeCenterPoint():Point {
			/*
			if (stage) {
				var brect:Rectangle = dispObj.getRect(me);
				return new Point(brect.x + (brect.width / 2), brect.y + (brect.height / 2));
			}
			return new Point(brect.width / 2, brect.height / 2);
			*/
			
			return me.globalToLocal(dispObj.localToGlobal(_localCenter));
			//return _localCenter;
		}
		
		protected function clear():void {
			//trace('clear()');
			mouseAngle.graphics.clear();
		}
		
		protected function drawLine(x1:Number, y1:Number, x2:Number, y2:Number, color:uint):void {
			//trace('drawLine(' + x1 + ',' + y1 + ',' + x2 + ',' + y2 + ')');
			mouseAngle.graphics.lineStyle(3, color, 0.6, true);
			mouseAngle.graphics.moveTo(x1, y1);
			mouseAngle.graphics.lineTo(x2, y2);
		}
		
		protected function newTrackPoint(label:String = '', point:Point = null): TrackPoint {
			var tempTP:TrackPoint = new TrackPoint(label, point);
			trackPointsContainer.addChild(tempTP);
			return tempTP;
		}
		
	}
}