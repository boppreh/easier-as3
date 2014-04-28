package boppreh.ui
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Draggable extends EventDispatcher
	{
		public static const START_DRAG:String = "startDrag"
		public static const UPDATE_DRAG:String = "updateDrag"
		public static const STOP_DRAG:String = "stopDrag"
		
		private static var _activeObject:InteractiveObject
		
		/// The last object that was clicked, dragged and/or moved
		public static function get activeObject():InteractiveObject { return _activeObject; }
		
		private var alwaysFollow:Boolean
		private var lastMousePos:Point
		
		private var _enabled:Boolean = false
		private var _grip:InteractiveObject
		private var _object:InteractiveObject
		private var _startingPoint:Point

		/// The object that can be dragged.
		public function get object():InteractiveObject {
			return _object
		}
		
		/// The x and y coordinates when it was last dragged
		public function get startingPoint():Point {
			return _startingPoint
		}
		
		/// True if the object can be dragged, false otherwise.
		public function get enabled():Boolean { return _enabled; }
		
		public function set enabled(value:Boolean):void
		{
			if (enabled != value) {
				if (value) {
					if (alwaysFollow) {
						startDrag()
					} else {
						grip.addEventListener(MouseEvent.MOUSE_DOWN, startDrag, false, 0, true)
					}
				} else {
					stopDrag()
					
					if (!alwaysFollow)
						grip.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag)
				}
				
				_enabled = value;
			}
		}
		
		/// The object that will dispatch the mouse down event to start the dragging
		public function get grip():InteractiveObject { return _grip; }
		
		public function set grip(value:InteractiveObject):void
		{
			if (value != grip) {
				
				if (enabled) {
					// removes the event listeners from the previous object
					enabled = false
					
					_grip = value
					
					// and re-adds them to the new grip
					enabled = true
					
				} else {
					_grip = value
				}
				
			}
		}
		
		/**
		 * Adds "draggability" to an object.
		 *
		 * When the user click and drag the grip (which is the object itself
		 * by default), the object will move with the mouse until the mouse
		 * button is released.
		 *
		 * This can be reversed setting "enabled" to false.
		 *
		 * @param object The object to be dragged around.
		 * @param grip Optional. The object that will dispatch
		 * the mouse down event to start the dragging.
		 * @param alwaysFollow if true, the user won't have to
		 * click and drag to move the object, essentially making
		 * it a cursor
		 */
		public function Draggable(object:InteractiveObject, grip:InteractiveObject = null, alwaysFollow:Boolean = false) {
			this._object = object
			
			this.alwaysFollow = alwaysFollow
			
			this.grip = grip || this.object
			
			this.enabled = true
		}
		
		public function startDrag(e:Event=null):void
		{
			_startingPoint = new Point(object.x, object.y)
			
			// It's important to use "object.parent" because we will be setting
			// the object x and y positions, which are relative to the parent.
			//
			// Otherwise, scale differences along the display hierarchy could
			// affect the results.
			lastMousePos = new Point(object.parent.mouseX, object.parent.mouseY)
			
			// stage is used because the user might release the mouse button
			// before the object has moved and is not under the mouse cursor yet
			object.stage.addEventListener(MouseEvent.MOUSE_MOVE, update)
			
			_activeObject = object
			
			if (!alwaysFollow)
				object.stage.addEventListener(MouseEvent.MOUSE_UP, stopDrag)
				
			dispatchEvent(new Event(START_DRAG))
		}
		
		public function update(e:Event=null):void
		{
			var curMousePos:Point = new Point(object.parent.mouseX, object.parent.mouseY)
			
			object.x -= lastMousePos.x - curMousePos.x
			object.y -= lastMousePos.y - curMousePos.y
			
			lastMousePos = curMousePos
			
			_activeObject = object
			
			dispatchEvent(new Event(UPDATE_DRAG))
		}
		
		public function stopDrag(e:Event=null):void
		{
			object.stage.removeEventListener(MouseEvent.MOUSE_MOVE, update)
			
			if (!alwaysFollow)
				object.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrag)
				
			_activeObject = null
			
			dispatchEvent(new Event(STOP_DRAG))
		}
	}
	
}