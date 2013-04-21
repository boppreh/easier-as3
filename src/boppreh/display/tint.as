/*

  Licensed under the MIT License

  Copyright (c) 2010 Lucas Boppre Niehues
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

package boppreh.display
{
	
	import flash.display.DisplayObject
	import fl.motion.Color

	/**
	 * Tints an object with a certain color and amount.
	 * @param object The object to have its color changed.
	 * @param color The tint color.
	 * @param alpha The amount to be tinted, being 0 no change and 1 completely painted.
	 */
	public function tint(object:DisplayObject, color:uint, alpha:Number = 1):void
	{
		var tintColor:Color = new Color()
		tintColor.setTint(color, alpha)
		object.transform.colorTransform = tintColor
	}
	
}
