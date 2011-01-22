/*

  Licensed under the MIT License

  Copyright (c) 2011 Lucas Boppre Niehues
  lucasboppre@gmail.com

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

*/

package boppreh.ui
{
	import boppreh.TopLevel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	/**
	 * Static class for storing key's states and easy listener attachment.
	 *
	 * Requires a boppreh.TopLevel instance set.
	 */
	public class Key
	{
		public static const MODIFIER_ANY:int = -1
		public static const MODIFIER_NONE:int = 0
		public static const MODIFIER_SHIFT:int = 1
		public static const MODIFIER_ALT:int = 2
		public static const MODIFIER_CTRL:int = 4
		
		private static const MODIFIER_MAX:int = 8
		
		private static var pressedKeys:Object = new Object()
		private static var dispatcher:EventDispatcher = new EventDispatcher()
		
		{
			TopLevel.stage.addEventListener(KeyboardEvent.KEY_DOWN, pressedKey)
			TopLevel.stage.addEventListener(KeyboardEvent.KEY_UP, releasedKey)
		}
		
		public static function getModifiers(event:Event):int {
			return (event.altKey && MODIFIER_ALT) +
				 (event.shiftKey && MODIFIER_SHIFT) +
				 (event.ctrlKey && MODIFIER_CTRL)
		}
		
		private static function pressedKey(event:KeyboardEvent):void {
			pressedKeys[event.keyCode] = true
			
			dispatcher.dispatchEvent(new Event(getEventType(event.keyCode, MODIFIER_ANY)))
			dispatcher.dispatchEvent(new Event(getEventType(event.keyCode, getModifiers(event))))
		}
		
		private static function releasedKey(event:KeyboardEvent):void {
			pressedKeys[event.keyCode] = false
		}
		
		/**
		 * Returns true if the key specified by the keyCode number is pressed.
		 * @param	keyCode The key number.
		 */
		public static function isDown(keyCode:uint):Boolean {
			return pressedKeys[keyCode]
		}
		
		/**
		 * Encodes the key and modifiers into an event type.
		 * @return A string representing the event type of the key and modifiers combination being pressed.
		 */
		public static function getEventType(key:int, modifiers:int):String {
			return String(key) + "-" + String(modifiers)
		}
		
		public static function addEventListener (type:String, listener:Function) : void {
			dispatcher.addEventListener(type, listener)
		}
		
		public static function dispatchEvent (event:Event) : Boolean {
			return dispatcher.dispatchEvent(event)
		}
		
		public static function hasEventListener (type:String) : Boolean {
			return dispatcher.hasEventListener(type)
		}
		
		public static function removeEventListener (type:String, listener:Function) : void {
			dispatcher.removeEventListener(type, listener)
		}
		
		public static function willTrigger (type:String) : Boolean {
			return dispatcher.willTrigger(type)
		}
	}
}