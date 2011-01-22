/*

  Licensed under the MIT License

  Copyright (c) 2011 Lucas Boppre Niehues

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

package boppreh.display
{
	
	import flash.display.DisplayObject
	import flash.geom.Point
	import boppreh.display.getPosition

	/**
	 * Visually define the position of object regardless of registration point.
	 * @param object The object to be moved.
	 * @param dest An object with x and y properties. NaN values will be ignored and no moment on that axis will be made.
	 * @param alignment Given the destination point, how to align the object to this point. See boppreh.utils.display.Alignment.
	 */
	public function setPosition(object:DisplayObject, dest:*, alignment:uint = 5):void
	{
		var currentPosition:Point = getPosition(object, alignment)
		
		// object.getBounds(object) ignores the scale property, so we have to take that into account
		// before moving.
		
		if (!isNaN(dest.x))
			object.x += dest.x - currentPosition.x
		if (!isNaN(dest.y))
			object.y += dest.y - currentPosition.y
	}
	
}