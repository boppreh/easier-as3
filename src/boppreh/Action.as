package boppreh
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Action
	{
		public function Action(positiveFunction:Function = null, positiveArgs:Array = null, negativeFunction:Function = null, negativeArgs:Array = null) {
			this.positiveFunction = positiveFunction
			this.positiveArgs = positiveArgs || []
			this.negativeFunction = negativeFunction
			this.negativeArgs = negativeArgs || []
		}
		
		public var positiveFunction:Function
		public var positiveArgs:Array
		
		public function run():void {
			positiveFunction.apply(null, positiveArgs)
		}
		
		
		public var negativeFunction:Function
		public var negativeArgs:Array
		
		public function undo():void {
			negativeFunction.apply(null, negativeArgs)
		}
		
		
		public static function makeObjectCreationAction(type:Class, container:Sprite, position:Point):Action {
			var object:* = new type()
			object.x = position.x
			object.y = position.y
			
			var action:Action = new Action()
			action.positiveFunction = container.addChild
			action.positiveArgs = [object]
			
			action.negativeFunction = container.removeChild
			action.negativeArgs = [object]
			
			return action
		}
		
		public static function makePropertyChangeAction(object:Object, properties:Array, values:Array):Action {
			var previousValues:Array = []
			for each (var property:String in properties) {
				previousValues.push(object[property])
			}
			
			return new Action(setProperties, [object, properties, values], setProperties, [object, properties, previousValues])
		}
	}
	
}