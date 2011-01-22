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
	import flash.geom.Rectangle

	/**
	 * Visually retrieve a point from an object regardless of registration point.
	 * @param object The object to be analysed.
	 * @param alignment Given the origin object, where to sample the point from. See boppreh.utils.display.Alignment.
	 */
	public function getPosition(object:DisplayObject, alignment:uint = 5):Point
	{
		var bounds:Rectangle
		
		bounds = object.getBounds(object)
		
		// object.getBounds(object) ignores the scale property, so we have to take that into account
		
		// generates a top_left alignment by default
		var point:Point = new Point()
		point.x = object.x + bounds.left * object.scaleX
		point.y = object.y + bounds.left * object.scaleY
		
		// if it's not left aligned
		if ((alignment & 2) == 0)
			point.x += object.width * ((alignment & 1) ? 1 : 0.5)
		
		// if it's not top aligned
		if ((alignment & 8) == 0) {
			point.y += object.height * ((alignment & 4) ? 1 : 0.5)
		}
		
		return point
	}
	
}