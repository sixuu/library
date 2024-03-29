﻿package com.laosafu.errors
{	
	/**
	 抽象方法的错误类
	 */
	public class AbstractError extends Error
	{
		/**
		 * Use this error in the constructor for your abstract class.
		 */
		public static const CONSTRUCTOR_ERROR:String = "ERROR: An abstract class may not be instantiated.";
		
		/**
		 * Use this error in abstract methods that should be overridden in your abstract class.
		 */
		public static const METHOD_ERROR:String = "ERROR: Failed to implement an abstract method.";
		
		
		public function AbstractError(message:String="", id:int=0)
		{   
			super(message, id);
		}
	}
}