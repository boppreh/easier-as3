package boppreh
{
	import boppreh.Action;
	
	public class ActionList
	{
		private var index:int
		private var maxLength:int
		private var autoExecute:Boolean
		private var actions:Array
		
		public function ActionList(autoExecute:Boolean = true, maxLength:int = 0) {
			this.maxLength = maxLength
			this.autoExecute = autoExecute
			
			actions = []
			index = -1
		}
		
		public function push(action:Action):void {
			if (index != actions.length)
				actions.splice(index + 1)
				
			actions.push(action)
			index++
			
			if (autoExecute)
				action.run()
			
			if (maxLength > 0 && index > maxLength) {
				actions[0].undo()
				actions.shift()
			}
		}
		
		public function undo():void {
			if (index >= 0) {
				actions[index].undo()
				index--
			}
		}
		
		public function redo():void {
			if (index < actions.length - 1) {
				index++
				actions[index].run()
			}
		}
	}
	
}