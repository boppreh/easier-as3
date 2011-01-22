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

package boppreh
{
	import flash.events.Event;
	import flash.utils.getTimer

	/**
	 * Provides static methods for time related utilities.
	 *
	 * Requires a boppreh.TopLevel instance set.
	 */
	public class Time {
		
		private static var functions:Array = []
		private static var lastID:uint = 0
		
		{
			TopLevel.stage.addEventListener(Event.ENTER_FRAME, update)
			
		}
		
		private static function update(event:Event):void {
			while (functions.length && functions[0].time <= getTimer()) {
				
				var item:Object = functions.shift()
				item.function_(item.args)
			}
		}
		
		/**
		 * Calls a functions after a certain amount of time, in milliseconds, whitin a frame of precision.
		 * @param	delay The number of milliseconds to wait before calling the function.
		 * @param	function_ The function to be called.
		 * @param	args	A list of the arguments to be passed to the called function.
		 * @return An id to be used if you wish to cancel the booked function using "cancelDelayedFunction".
		 */
		public static function delayFunction(delay:int, function_:Function, args:Array = null):uint {
			var item:Object = { }
			item.id = lastID++
			item.time = getTimer() + delay
			item.function_ = function_
			item.args = args
			
			functions.push(item)
			
			return item.id
		}
		
		/**
		 * Cancels a delayed function booked with "delayFunction".
		 * @param	id The function id given when the delayFunction method was called.
		 */
		public static function cancelDelayedFunction(id:uint):void {
			var n:int = functions.length
			for (var i:int = 0; i < n; i++) {
				if (functions[i].id == id) {
					functions.splice(i, 1)
					return
				}
			}
		}
		
		/**
		 * Measures how much time a function takes to run, on average.
		 * @param	function_ The function to be timed.
		 * @param	args Array of arguments to be passed to the function, if any.
		 * @param	executions Number of executions to average the results.
		 * @return The number of milliseconds the function takes to run, in average.
		 */
		public static function timeFunction(function_:Function, args:Array = null, executions:uint = 1):Number {
			var totalTime:int = 0
			
			for (var i:int = 0; i < executions; i++) {
				var oldTime:int = getTimer()
				function_(args)
				totalTime += getTimer() - oldTime
			}
			
			return totalTime / Number(executions)
		}
	}
}