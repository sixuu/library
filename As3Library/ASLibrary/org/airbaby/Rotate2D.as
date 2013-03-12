package org.airbaby
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @author	rkuk
	 * @link	http://www.rkuk.org
	 */
	public class Rotate2D 
	{		
		/**
		 * @param	target			the display object you want to rotate
		 * @param	angle			the rotation angle in degree
		 * @param	pointX			the x coordinate to rotate around
		 * @param	pointY			the y coordinate to rotate around
		 * @param	coordinate		pointX and pointY are in this coordinate
		 */
		public static function rotate(target:DisplayObject, angle:Number, pointX:Number = 0, pointY:Number = 0, coordinate:DisplayObject = null):void
		{
			if (coordinate == null)
				coordinate = target;
			
			if (target.stage && coordinate.stage)
			{
				var rotatePoint:Point = new Point(pointX, pointY);
				rotatePoint = getRotatePointInParent(target.parent, coordinate, rotatePoint);
				var m:Matrix = target.transform.matrix;
				with (m)
				{
					translate( -rotatePoint.x, -rotatePoint.y);
					rotate(angle*Math.PI/180);
					translate(rotatePoint.x, rotatePoint.y);
				}
				target.transform.matrix = m;
			}				
		}
		
		private static function getRotatePointInParent(parent:DisplayObject, coordinate:DisplayObject, rotatePoint:Point):Point
		{
			var targetBranch:Array = new Array(parent);
			while (!(parent is Stage))
			{
				targetBranch.push(parent.parent);
				parent = parent.parent;
			}

			var depth:int = targetBranch.indexOf(coordinate);
			while (depth == -1)
			{
				rotatePoint = coordinate.transform.matrix.transformPoint(rotatePoint);
				coordinate = coordinate.parent;
				depth = targetBranch.indexOf(coordinate);
			}
			
			while (depth-->0)
			{
				var m:Matrix = targetBranch[depth].transform.matrix;
				m.invert();
				rotatePoint = m.transformPoint(rotatePoint);
			}
			return rotatePoint;
		}
	}
}