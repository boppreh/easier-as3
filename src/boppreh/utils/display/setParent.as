/*

  Licensed under the MIT License

  Copyright (c) 2010 Lucas Boppre Niehues

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

package boppreh.utils.display
{
	
	import flash.display.DisplayObject
	import flash.display.DisplayObjectContainer
	import flash.geom.Matrix
	
	/**
	 * Add an object as a child of another while keeping its position, rotation, scale and skew visually unchanged.
	 * @param	child	The object to have its "parent" changed.
	 * @param	parent The new container object.
	 */
	public function setParent(child:DisplayObject, parent:DisplayObjectContainer):void {
		var parentMatrix:Matrix = parent.transform.concatenatedMatrix
		parentMatrix.invert()
		var childMatrix:Matrix = child.transform.concatenatedMatrix
		childMatrix.concat(parentMatrix)
		child.transform.matrix = childMatrix
		
		//TODO: deal with filters
		
		// TODO: keep tint when changing parents
		/*var parentColor:ColorTransform = parent.transform.concatenatedColorTransform
		
		//parentColor.redOffset *= -1
		//parentColor.blueOffset *= -1
		//parentColor.greenOffset *= -1
		//parentColor.alphaOffset *= -1
		
		//parentColor.redMultiplier = (parentColor.redMultiplier - 1) * -1 + 1
		//parentColor.blueMultiplier = (parentColor.blueMultiplier - 1) * -1 + 1
		//parentColor.greenMultiplier = (parentColor.greenMultiplier - 1) * -1 + 1
		//parentColor.alphaMultiplier = (parentColor.alphaMultiplier - 1) * -1 + 1
		
		var childColor:ColorTransform = child.transform.colorTransform
		
		childColor.concat(child.transform.concatenatedColorTransform)
		childColor.concat(parentColor)
		child.transform.colorTransform = childColor*/
		
		parent.addChild(child)
	}
	
}