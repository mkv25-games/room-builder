package net.mkv25.room.planner;

class Floorplan
{
	public var width:Int;
	public var height:Int;
	public var rooms:List<Room>;

	public function new() 
	{
		rooms = new List<Room>();
	}
	
	public function removeAllRooms():Void
	{
		while (rooms.length > 0)
		{
			rooms.pop();
		}
	}
}