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
	import boppreh.display.tint;
	import boppreh.TopLevel;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Static class for recording and replaying keyboard and mouse events.
	 *
	 * Events recorded:
	 * MouseEvent.CLICK
	 * MouseEvent.MOVE (optional)
	 * KeyboardEvent.KEY_UP
	 * KeyboardEvent.KEY_DOWN
	 */
	public class Macroer
	{
		private static const MOUSE_EVENT:uint = 0
		private static const KEYBOARD_EVENT:uint = 1
		
		private static var index:int
		private static var inputs:Array
		private static var frame:int
		private static var cursor:Sprite
		
		/**
		 *
		 * @param	includeMouseMove
		 */
		public static function record(includeMouseMove:Boolean = false):void {
			inputs = []
			frame = 0
			
			TopLevel.stage.stage.addEventListener(Event.ENTER_FRAME, incrementFrame)
			TopLevel.stage.stage.addEventListener(KeyboardEvent.KEY_UP, recordKeyboardEvent)
			TopLevel.stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, recordKeyboardEvent)
			TopLevel.stage.stage.addEventListener(MouseEvent.CLICK, recordMouseEvent)
			
			if (includeMouseMove)
				TopLevel.stage.stage.addEventListener(MouseEvent.MOUSE_MOVE, recordMouseEvent)
		}
		
		private static function recordKeyboardEvent(event:KeyboardEvent):void {
			var input:Object = { }
			input.frame = frame
			input.source = KEYBOARD_EVENT
			input.type = event.type
			input.charCode = event.charCode
			input.keyCode = event.keyCode
			input.modifiers = Key.getModifiers(event)
			
			inputs.push(input)
		}
		
		private static function recordMouseEvent(event:MouseEvent):void {
			var input:Object = { }
			input.frame = frame
			input.source = MOUSE_EVENT
			input.type = event.type
			input.x = TopLevel.stage.mouseX
			input.y = TopLevel.stage.mouseY
			input.modifiers = Key.getModifiers(event)
			
			inputs.push(input)
		}
		
		private static function incrementFrame(e:Event):void {
			frame++
		}
		
		public static function stopRecordingAndReturn():Array {
			TopLevel.stage.stage.removeEventListener(Event.ENTER_FRAME, incrementFrame)
			TopLevel.stage.stage.removeEventListener(MouseEvent.CLICK, recordMouseEvent)
			TopLevel.stage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, recordMouseEvent)
			TopLevel.stage.stage.removeEventListener(KeyboardEvent.KEY_UP, recordKeyboardEvent)
			TopLevel.stage.stage.removeEventListener(KeyboardEvent.KEY_DOWN, recordKeyboardEvent)
			
			var allInputs:Array = inputs
			inputs = null
			return allInputs
		}
		
		public static function play(inputs:Array, showCursor:Boolean = true):void {
			Macroer.inputs = inputs
			frame = 0
			index = 0
			
			if (showCursor) {
				cursor = new Sprite()
				cursor.graphics.lineStyle(1.5, 0xFFFFFF)
				cursor.graphics.beginFill(0x000000)
				cursor.graphics.drawCircle(0, 0, 5)
				TopLevel.stage.addChild(cursor)
			}
			
			TopLevel.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		private static function updateCursor(position:Point, isClick:Boolean):void {
			cursor.x = position.x
			cursor.y = position.y
			
			if (isClick)
				tint(cursor, 0xFF0000)
			else
				tint(cursor, 0xFFFF00)
		}
		
		private static function replayInput(input:Object):void {
			if (input.source == MOUSE_EVENT) {
				var position:Point = new Point(input.x, input.y)
				
				if (cursor)
					updateCursor(position, input.type == MouseEvent.CLICK)
				
				var target:DisplayObject = TopLevel.stage.getObjectsUnderPoint(position)[0]
				if (target is Shape)
					target = target.parent
				if (target == null)
					target = TopLevel.stage
				
				var mouseEvent:MouseEvent = new MouseEvent(input.type)
				Key.setModifiers(mouseEvent, input.modifiers)
				target.dispatchEvent(mouseEvent)
				
			} else {
				var keyboardEvent:KeyboardEvent = new KeyboardEvent(input.type, true, false, input.charCode, input.keyCode)
				Key.setModifiers(keyboardEvent, input.modifiers)
				TopLevel.stage.dispatchEvent(keyboardEvent)
			}
		}
		
		private static function onEnterFrame(e:Event):void
		{
			while (inputs[index] && inputs[index].frame == frame) {
				replayInput(inputs[index])
				index++
			}
			
			if (index == inputs.length)
				stopPlaying()
			else
				frame++
		}
		
		public static function stopPlaying():void {
			if (cursor) {
				TopLevel.stage.removeChild(cursor)
				cursor = null
			}
			
			inputs = null
			
			TopLevel.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
	}
}