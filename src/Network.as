package  
{
	import flash.events.Event;
	import org.flixel.*;
	import flash.display.MovieClip
	import playerio.*;
	
	public class Network extends MovieClip 
	{
		private var gameID:String = "playeriotest-w0crqcm8emypgrubebew";
		public var cl:Client;
		public var co:Connection;
		
		public var latency:int;
		
		public function Network() 
		{
			stop();
		}
		
		public function connect():void
		{
			trace("Connecting...");
			PlayerIO.connect(
				FlxG.stage,								//Referance to stage
				gameID,			//Game id (Get your own at playerio.com)
				"public",							//Connection id, default is public
				"GuestUser",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);
		}
		
		public function pingOut():void 
		{
			latency = new Date().getTime();
			co.send("ping");
		}
		
		private function pingIn():void 
		{
			latency = new Date().getTime() - latency;
			trace(latency.toString() + "ms");
		}
		
		
		
		
		
		
		private function handleConnect(client:Client):void
		{
			trace("Sucessfully connected to player.io");
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "localhost:8184";
			
			//Create or join the room test
			client.multiplayer.createJoinRoom(
				"Game",								//Room id. If set to null a random roomid is used
				"MyCode",							//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			
			cl = client;
		}
		
		private function handleJoin(connection:Connection):void
		{
			trace("Sucessfully connected to the multiplayer server");
			gotoAndStop(2);
			
			//Add disconnect listener
			connection.addDisconnectHandler(handleDisconnect);
					
			//Add listener for messages of the type "hello"
			connection.addMessageHandler("hello", function(m:Message):void
			{
				trace("Recived a message with the type hello from the server");			 
			})
			
			//Add message listener for users joining the room
			connection.addMessageHandler("UserJoined", function(m:Message, userid:uint):void
			{
				trace("Player with the userid", userid, "just joined the room");
			})
			
			//Add message listener for users leaving the room
			connection.addMessageHandler("UserLeft", function(m:Message, userid:uint):void
			{
				trace("Player with the userid", userid, "just left the room");
			})
			
			//Listen to all messages using a private function
			connection.addMessageHandler("*", handleMessages)
			
			connection.send("Hello World");
			co = connection;
		}
		
		private function handleMessages(m:Message):void
		{
			trace("Recived the message", m)
			
			switch (m.type)
			{
				case "ping":
					pingIn();
				break;
			}
		}
		
		private function handleDisconnect():void
		{
			trace("Disconnected from server")
		}
		
		private function handleError(error:PlayerIOError):void
		{
			trace("got",error)
			gotoAndStop(3);
		}
	}
}