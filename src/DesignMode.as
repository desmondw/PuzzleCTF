package  
{
	import org.flixel.*;
	
	public class DesignMode 
	{
		[Embed(source = "../bin/selected.png")] public var g_selected:Class;
		
		public var selection:FlxSprite;
		
		public function DesignMode(state:FlxState)
		{
			selection = new FlxSprite(-16, -16);
			selection.loadGraphic(g_selected);
			state.add(selection);
		}
		
		public function update():void
		{
			selection.x = Math.floor(FlxG.mouse.x / 16) * 16;
			selection.y = Math.floor(FlxG.mouse.y / 16) * 16;
			
			if (FlxG.mouse.pressed())
			{
				if (FlxG.keys.SHIFT)
					changeTile(selection.x / 16, selection.y / 16, 0);
				else
					changeTile(selection.x / 16, selection.y / 16, 2);
			}
		}
		
		protected function changeTile(tileX:int, tileY:int, newTile:int):void 
		{
			var currentTile:int = PlayState.map.getTile(tileX, tileY);
			if (currentTile != newTile && currentTile != 1 && currentTile != 3 && currentTile != 4)
				PlayState.map.setTile(tileX, tileY, newTile);
		}
		
		public function modeTransition():void
		{
			selection.visible = PlayState.inDesignMode;
		}
	}
}