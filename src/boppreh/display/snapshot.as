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

package boppreh.display
{
	
	import flash.display.DisplayObject
	import flash.display.Sprite
	import flash.display.BitmapData
	import flash.display.Bitmap
	import flash.geom.Rectangle
	import flash.geom.Matrix
	
	/**
	 * Takes a snapshot of an object, returning a bitmap image of its current appearance.
	 * @param object The object to be copied.
	 * @param transparentBitmapData Defines if the unused part of the bitmap will be transparent or not.
	 * @param smoothing A Boolean value that determines whether the returned bitmap object is smoothed when scaled or rotated.
	 * @return A sprite containing a bitmap snapshot of the original object.
	 */
	public function snapshot(object:DisplayObject, transparentBitmapData:Boolean=true, smoothing:Boolean=true):Sprite {
		var bounds:Rectangle = object.getBounds(object)
		var data:BitmapData = new BitmapData(bounds.width, bounds.height, transparentBitmapData, 0xFFFFFF)
		data.draw(object, new Matrix(1,0,0,1,-bounds.x,-bounds.y), null, null, null, smoothing );
		var sprite = new Sprite()
		sprite.addChild(new Bitmap(data, "auto", true))
		return sprite
	}
}