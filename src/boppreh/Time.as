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
	import flash.display.Sprite;
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
		
		private static const frameEventDispatcher:Sprite = new Sprite()
		
		{
			frameEventDispatcher.addEventListener(Event.ENTER_FRAME, update)
		}
		
		private static function update(event:Event):void {
			while (functions.length && functions[0].time <= getTimer()) {
				
				var item:Object = functions.shift()
				item.function_.apply(null, item.args)
			}
		}
		
		/**
		 * Calls a functions after a certain amount of time, in milliseconds, within a frame of precision.
		 * @param	delay The number of milliseconds to wait before calling the function.
		 * @param	function_ The function to be called.
		 * @param	args	A list of the arguments to be passed to the called function.
		 * @return An id to be used if you wish to cancel the booked function using "cancelDelayedFunction".
		 */
		public static function delayFunction(delay:int, function_:Function, args:Array=null):uint {
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
		 * Measures how long a function takes to run, averaged over many tests.
		 * @param	function_	The function to me analyzed.
		 * @param	args	Optional, arguments to be passed to the function during the test.
		 * @param	benchmarkDuration	How long the test will last, in milliseconds. Remember Flash has a default script time limit of 15 seconds.
		 * @return	The average number of milliseconds the function took to run.
		 */
		public static function benchmark(function_:Function, args:Array=null, benchmarkDuration:Number=2000):Number {
			args = args || []
			
			var startingTime:int = getTimer()
			
			var totalExecutionTime:int = 0
			var executionsCount:int = 0
			
			var timeBefore:int
			var timeAfter:int
			
			do {
				timeBefore = getTimer()
				function_.apply(null, args)
				timeAfter = getTimer()
				
				totalExecutionTime += timeAfter - timeBefore
				executionsCount++
				
			} while (timeAfter - startingTime < benchmarkDuration)
			
			return totalExecutionTime / executionsCount
		}
	}
}