package
{
	import org.flixel.*;
	import flash.events.Event;
	import flash.ui.Mouse;
 
	public class PlayState extends FlxState
	{	
		[Embed(source="../bin/tiles.png")] public static var g_tiles:Class;
		[Embed(source="../bin/flags.png")] public static var g_flags:Class;
		
		public var network:Network = new Network();
		public static var map:FlxTilemap = new FlxTilemap();
		public var designMode:DesignMode;
		
		public var player1:Player = new Player(1);
		public var player2:Player = new Player(2);
		public var flag1:Flag = new Flag(1);
		public var flag2:Flag = new Flag(2);
		public var base1:Base;
		public var base2:Base;
		
		public static var inDesignMode:Boolean = false;
		
		override public function create():void
		{
			network.connect();
			
			newGame();
			designMode = new DesignMode(this);
		}
		
		override public function update():void
		{
			super.update();
			Mouse.show();
			
			if (FlxG.keys.justPressed("Q"))
			{
				inDesignMode = !inDesignMode;
				designMode.modeTransition();
			}
			if (inDesignMode)
			{
				designMode.update();
				return;
			}
			
			if (FlxG.keys.justPressed("C"))
			{
				//connect();
			}
			
			if (FlxG.keys.justPressed("P"))
			{
				network.pingOut();
			}
			
			collision();
		}
		
		protected function newGame():void
		{
			intializeMap();
			
			player1.x = 2 * 16;
			player1.y = 7 * 16;
			add(player1);
			
			player2.x = 17 * 16;
			player2.y = 7 * 16;
			add(player2);
			
			//inDesignMode = true;
		}
		
		protected function intializeMap():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			var data:Array = new Array(
				1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
				1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
				
			map.loadMap(FlxTilemap.arrayToCSV(data, 20), g_tiles, 16, 16);
			map.setTileProperties(3, FlxObject.NONE);
			map.setTileProperties(4, FlxObject.NONE);
			add(map);
			
			flag1.baseX = 1 * 16;
			flag1.baseY = 7 * 16;
			flag1.returnToBase();
			add(flag1);
			base1 = new Base(flag1.x, flag1.y, 1);
			
			flag2.baseX = 18 * 16;
			flag2.baseY = 7 * 16;
			flag2.returnToBase();
			add(flag2);
			base2 = new Base(flag2.x, flag2.y, 2);
		}
		
		protected function collision():void 
		{
			FlxG.collide(map, player1);
			FlxG.collide(map, player2);
			
			if (player1.overlaps(flag2))
				grabFlag(player1, flag2);
			if (player2.overlaps(flag1))
				grabFlag(player2, flag1);
				
			if (base1.overlaps(new FlxRect(player1.x, player1.y, 14, 14)))
				scoreFlag(player1, base1);
			if (base2.overlaps(new FlxRect(player2.x, player2.y, 14, 14)))
				scoreFlag(player2, base2);
		}
		
		protected function grabFlag(player:Player, flag:Flag):void 
		{
			if (player.team == flag.team)
				return;
			
			player.hasFlag = true;
			flag.grabbed();
		}
		
		protected function scoreFlag(player:Player, base:Base):void 
		{
			if (player.team != base.team || !player.hasFlag)
				return;
			
			player.hasFlag = false;
			if (player.team == 1)
				flag2.returnToBase();
			else
				flag1.returnToBase();
				
			//player scores points
		}
	}
}