package org.airbaby{
	//
	import flash.display.Bitmap
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObject;
	//
	public class Alert {
		//
		private static var stage:Stage = null;
		private static var btnWidth:int = 45
		private static var btnHeight:int = 21;
		//
		public static function init(stageReference:Stage):void {
			stage = stageReference;
		}
		//
		public static function show(Text:* = "Made by Dark Vyper", callback:Function = null, Colour:int =  0xCCCCCC, textColour:int = 0x000000):void {
			if (stage == null) {
				trace("Alert class has not been initialised!");
				return;
			}
			var myAlert:Sprite = new Sprite();
			//myAlert.addChild(createBackground(Colour));
			myAlert.addChild(new Sprite ())
			myAlert.addChild(createPrompt(Text.toString(), Colour, textColour));
			assignListeners(myAlert, callback);
			stage.addChild(myAlert)
		}
		//
		private static function assignListeners(myAlert:Sprite, callback:Function):void {
			var Background:* = myAlert.getChildAt(1);
			var Prompt:* = Background.getChildAt(0);
			var OKbutton:* = Prompt.getChildAt(1);
			//	Cause Alert to call specified function when alert has been closed
			if (callback != null) {
				function myFunction(myEvent:MouseEvent):void {
					OKbutton.removeEventListener(MouseEvent.CLICK, myFunction);
					closeAlert(myEvent);
					callback();
				};
				OKbutton.addEventListener(MouseEvent.CLICK, myFunction);
			} else {
				OKbutton.addEventListener(MouseEvent.CLICK, closeAlert);
			}
		}
		//	removes the Alert from the display list
		private static function closeAlert(event:MouseEvent):void {
			var OKbutton:* = event.target;
			OKbutton.removeEventListener(MouseEvent.CLICK, closeAlert);
			var BG:* = event.target.parent;
			BG.removeEventListener(MouseEvent.CLICK, doStartDrag);
			BG.removeEventListener(MouseEvent.CLICK, doStopDrag);
			//	messy I know...
			var myAlert:Sprite = event.target.parent.parent.parent;
			myAlert.parent.removeChild(myAlert);
		}
		//	Creates the background for the Alert
		private static function createBackground(Colour:int):Sprite {
			var BackgroundBD:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x00000000+Colour);
			var stageBackground:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);
			stageBackground.draw(stage);
			var rect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			var point:Point = new Point(0, 0);
			var multiplier:uint = 120;
			BackgroundBD.merge(stageBackground, rect, point, multiplier, multiplier, multiplier, multiplier);
			BackgroundBD.applyFilter(BackgroundBD, rect, point, new BlurFilter(5, 5));
			var bitmap:Bitmap = new Bitmap(BackgroundBD);
			var Background:Sprite = new Sprite();
			Background.addChild(bitmap);
			return Background;
		}
		//	Returns an 'OK' button
		private static function createOKBtn(Colour:int, textColour:int):SimpleButton {
			var colors:Array = new Array();
			var alphas:Array = new Array(1, 1, 1);
			var ratios:Array = new Array(0, 128, 255);
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(btnWidth, btnHeight, Math.PI/2, 0, 0);
			//
			var btnUpState:Sprite = new Sprite();
			colors = [0xFFFFFF, Colour, 0xFFFFFF];
			btnUpState.graphics.lineStyle(1);
			btnUpState.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, gradientMatrix);
			btnUpState.graphics.drawRect(0, 0, btnWidth, btnHeight);
			btnUpState.addChild(getTextField("OK" , textColour, true));
			//
			var btnOverState:Sprite = new Sprite();
			colors = [0xFFFFFF, brightenColour(Colour, 50), 0xFFFFFF];
			btnOverState.graphics.lineStyle(1);
			btnOverState.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, gradientMatrix);
			btnOverState.graphics.drawRect(0, 0, btnWidth, btnHeight);
			btnOverState.addChild(getTextField("OK" , textColour, true))
			//
			var btnDownState:Sprite = new Sprite();
			colors = [Colour, brightenColour(Colour, 50), Colour];
			btnDownState.graphics.lineStyle(1);
			btnDownState.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, gradientMatrix);
			btnDownState.graphics.drawRect(0, 0, btnWidth, btnHeight);
			btnDownState.addChild(getTextField("^_^" , textColour, true))
			//
			var myButton:SimpleButton = new SimpleButton(btnUpState, btnOverState, btnDownState, btnOverState);
			return myButton;
		}
		//	returns a Sprite containing a prompt positioned in the middle of the stage
		private static function createPrompt(Text:String, Colour:int, textColour:int):Sprite {
			var holder:Sprite = new Sprite()
			holder.addEventListener(MouseEvent.MOUSE_DOWN, doStartDrag);
			holder.addEventListener(MouseEvent.MOUSE_UP, doStopDrag); 
			holder.addChild(getPrompt(Text, Colour, textColour));
			holder.x = (stage.stageWidth/2)-(holder.width/2);
			holder.y = (stage.stageHeight/2)-(holder.height/2);
			holder.filters = [getGlowFilter(Colour), getDropShadowFilter(Colour)];
			return holder;
		}
		//
		private static function getBlurFilter():BitmapFilter {
            var blurX:Number = 100;
            var blurY:Number = 100;
            return new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH);
        }
		//
		private static function getDropShadowFilter(Colour:int):DropShadowFilter {
			var color:Number = 0x000000;
            var angle:Number = 45;
            var alpha:Number = 0.6;
            var blurX:Number = 8;
            var blurY:Number = 8;
            var distance:Number = 4;
            var strength:Number = 1.3;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.LOW;
            return new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}	
		//
		private static function getGlowFilter(Colour:int):GlowFilter {
			var color:Number = 0xFFFFFF;
            var alpha:Number = 0.8;
            var blurX:Number = 15;
            var blurY:Number = 15;
            var strength:Number = 0.7;
            var inner:Boolean = true;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
            return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		//	returns a sprite containing a prompt complete with a background, the specified text and an OK button
		private static function getPrompt(Text:String, Colour:int, textColour:int):Sprite {
			var prompt:Sprite = new Sprite();
			prompt.addEventListener(MouseEvent.MOUSE_DOWN, doStartDrag);
			prompt.addEventListener(MouseEvent.MOUSE_UP, doStopDrag);
			prompt.name = "alert";
			var textField:TextField = getTextField(Text, textColour);
			var myWidth:int = textField.width+10;
			var myHeight:int = textField.height+55;
			if (myWidth < 150) {
				myWidth = 150;
			}
			if (myHeight < 100) {
				myHeight = 100;
			}
			if (myHeight > stage.stageHeight) {
				myHeight = stage.stageHeight - 20;
				textField.autoSize = TextFieldAutoSize.NONE;
				textField.height = stage.stageHeight-40;
			}
			//	Create a background for the prompt
			var ellipseSize:int = 5;
			prompt.graphics.lineStyle(1);
			prompt.graphics.beginFill(Colour);
			prompt.graphics.drawRoundRect(0, 0, myWidth, myHeight, ellipseSize, ellipseSize);
			//	Add the specified text to the prompt
			textField.x = (prompt.width/2)-(textField.width/2);
			textField.y = (prompt.height/2)-(textField.height/2)-10;
			prompt.addChild(textField);
			//	Add an OK Button to the prompt
			var OKbutton:SimpleButton = createOKBtn(Colour, textColour);
			OKbutton.x = (prompt.width/2)-(OKbutton.width/2);
			OKbutton.y = prompt.height-35;
			prompt.addChild(OKbutton);
			//
			return prompt;
		}
		//	Returns a textfield with the specified text
		private static function getTextField(Text:String, textColour:int, bold:Boolean = false):TextField {
			var myTextField:TextField = new TextField();
			myTextField.textColor = textColour;
			myTextField.name = "textfield";
			myTextField.multiline = true;
			myTextField.selectable = false;
			myTextField.autoSize = TextFieldAutoSize.CENTER;
			if (bold) {
				Text = "<b>"+Text+"</b>";
			}
			myTextField.htmlText = '<font face="Verdana">'+Text+'</font>';
			myTextField.x = (btnWidth/2)-(myTextField.width/2);
			myTextField.y = (btnHeight/2)-(myTextField.height/2);
			return myTextField;
		}
		//
		//	Helper functions
		//-----------------------------------------------------------------
		//
		//	returns a brighter version of the specified colour
		private static function brightenColour(colour:int, modifier:int):int {
			var hex:Array = hexToRGB(colour);
			var red:int = keepInBounds(hex[0]+modifier);
			var green:int = keepInBounds(hex[1]+modifier);
			var blue:int = keepInBounds(hex[2]+modifier);
			return RGBToHex(red, green, blue);
		}
		private static function doStartDrag(event:MouseEvent):void {
			if (event.target.name != "textfield") {
				if (event.target.name == "alert") {
					event.target.startDrag();
				}
			}
		}
		private static function doStopDrag(event:MouseEvent):void {
			if (event.target.name != "textfield") {
				if (event.target.name == "alert") {
					event.target.stopDrag();
				}
			}
		}
		private static function hexToRGB (hex:uint):Array {
			var Colours:Array = new Array(); 
			Colours.push(hex >> 16);
			var temp:uint = hex ^ Colours[0] << 16;
			Colours.push(temp >> 8);
			Colours.push(temp ^ Colours[1] << 8);
			return Colours;
		}
		private static function keepInBounds(number:int):int {
			if (number < 0)	number = 0;
			if (number > 255) number = 255;
			return number;
		}		
		private static function RGBToHex(uR:int, uG:int, uB:int):int {
			var uColor:uint;
			uColor =  (uR & 255) << 16;
			uColor += (uG & 255) << 8;
			uColor += (uB & 255);
			return uColor;
		}
		//	Stops any mouse events from getting below the alert
		private static function stopEvents(event:MouseEvent):void {
			event.stopImmediatePropagation();
		}
	}
}