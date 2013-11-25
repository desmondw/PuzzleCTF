package  
{
	import org.flixel.*;
	
	public class Flag extends FlxSprite
	{
		[Embed(source = "../bin/flags.png")] public var g_flags:Class;
		
		public var team:int;
		public var baseX:int;
		public var baseY:int;
		
		public function Flag(team:int) 
		{
			this.team = team;
			
			loadGraphic(g_flags, true);
			addAnimation("show", new Array(team - 1, team - 1), 8);
			play("show");
			
			solid = false;
		}
		
		public function grabbed():void 
		{
			solid = false;
			visible = false;
		}
		
		public function returnToBase():void 
		{
			solid = true;
			visible = true;
			x = baseX;
			y = baseY;
		}
	}
}