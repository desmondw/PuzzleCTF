package  
{
	import org.flixel.*;
	
	public class Base extends FlxRect
	{
		public var team:int;
		
		public function Base(x:int, y:int, team:int) 
		{
			this.team = team;
			
			super(x, y, 16, 16);
		}
	}
}