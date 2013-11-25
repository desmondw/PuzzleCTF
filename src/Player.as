package  
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source = "../bin/player1.png")] public var g_player1:Class;
		[Embed(source = "../bin/player2.png")] public var g_player2:Class;
		
		public var team:int;
		public var hasFlag:Boolean = false;
		
		public function Player(team:int)
		{
			this.team = team;
			
			if (team == 1)
			{
				loadGraphic(g_player1, true, false, 14, 14);
				facing = RIGHT;
			}
			else
			{
				loadGraphic(g_player2, true, false, 14, 14);
				facing = LEFT;
			}
			
			addAnimation("down", new Array(0, 0), 8);
			addAnimation("down_run", new Array(1, 2), 8);
			addAnimation("right", new Array(3, 3), 8);
			addAnimation("right_run", new Array(4, 5), 8);
			addAnimation("up", new Array(6, 6), 8);
			addAnimation("up_run", new Array(7, 8), 8);
			addAnimation("left", new Array(9, 9), 8);
			addAnimation("left_run", new Array(10, 11), 8);
			addAnimation("f_down", new Array(12, 12), 8);
			addAnimation("f_down_run", new Array(13, 14), 8);
			addAnimation("f_right", new Array(15, 15), 8);
			addAnimation("f_right_run", new Array(16, 17), 8);
			addAnimation("f_up", new Array(18, 18), 8);
			addAnimation("f_up_run", new Array(19, 20), 8);
			addAnimation("f_left", new Array(21, 21), 8);
			addAnimation("f_left_run", new Array(22, 23), 8);
			
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			
			width = 14;
			height = 14;
		}
		
		override public function update():void 
		{
			if (PlayState.inDesignMode)
			{
				acceleration.x = 0;
				acceleration.y = 0;
				velocity.x = 0;
				velocity.y = 0;
				
				if (hasFlag)
					play("f_down");
				else
					play("down");
				return;
			}
			
			var running:Boolean = false;
			acceleration.x = 0;
			acceleration.y = 0;
			
			//moves player
			running = input();
			
			//animates player
			if (!running)
			{
				if (hasFlag)
				{
					if (facing == LEFT)
						play("f_left");
					else if (facing == RIGHT)
						play("f_right");
					else if (facing == UP)
						play("f_up");
					else if (facing == DOWN)
						play("f_down");
				}
				else
				{
					if (facing == LEFT)
						play("left");
					else if (facing == RIGHT)
						play("right");
					else if (facing == UP)
						play("up");
					else if (facing == DOWN)
						play("down");
				}
			}
		}
		
		public function input():Boolean
		{
			var running:Boolean = false;
			
			var left:Boolean = false;
			var right:Boolean = false;
			var up:Boolean = false;
			var down:Boolean = false;
			
			if (team == 1)
			{
				if (FlxG.keys.A)
					left = true;
				if (FlxG.keys.D)
					right = true;
				if (FlxG.keys.W)
					up = true;
				if (FlxG.keys.S)
					down = true;
			}
			else
			{
				if (FlxG.keys.LEFT)
					left = true;
				if (FlxG.keys.RIGHT)
					right = true;
				if (FlxG.keys.UP)
					up = true;
				if (FlxG.keys.DOWN)
					down = true;
			}
			
			if (left)
			{
				acceleration.x = -maxVelocity.x * 4;
				facing = LEFT;
				if (hasFlag)
					play("f_left_run");
				else
					play("left_run");
				
				running = true;
			}
			if (right)
			{
				acceleration.x = maxVelocity.x * 4;
				facing = RIGHT;
				if (hasFlag)
					play("f_right_run");
				else
					play("right_run");
				
				running = true;
			}
			if (up)
			{
				acceleration.y = -maxVelocity.y * 4;
				facing = UP;
				if (hasFlag)
					play("f_up_run");
				else
					play("up_run");
				
				running = true;
			}
			if (down)
			{
				acceleration.y = maxVelocity.y * 4;
				facing = DOWN;
				if (hasFlag)
					play("f_down_run");
				else
					play("down_run");
				
				running = true;
			}
			
			return running;
		}
	}
}