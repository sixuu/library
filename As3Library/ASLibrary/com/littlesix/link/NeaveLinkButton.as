/**
 * Neave Link Button
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
	import flash.text.*;
	
	public class NeaveLinkButton extends SimpleButton
	{
		/**
		 * Creates a textfield button for a link to www.neave.com
		 */
		public function NeaveLinkButton()
		{
			var tf:TextField = new TextField();
			tf.text = " LittleSix-cn//© 2007-2010";
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.blendMode = BlendMode.INVERT;
			
			var fmt:TextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
			fmt.align = TextFormatAlign.CENTER;
			tf.setTextFormat(fmt);
			tf.x = -tf.width / 2;
			tf.y = -tf.height;
			
			upState = overState = downState = hitTestState = tf;
			useHandCursor = true;
		}
	}
}