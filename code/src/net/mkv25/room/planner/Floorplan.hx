package net.mkv25.room.planner;
import flash.geom.Rectangle;

class Floorplan
{
	public var width:Int;
	public var height:Int;
	public var rooms:List<Room>;

	private var filled:Bool;
	
	public function new() 
	{
		rooms = new List<Room>();
	}
	
	public function addRoom(room:Room):Bool
	{
		if (spaceFor(room))
		{
			rooms.add(room);
			return true;
		}
		
		return false;
	}
	
	public function removeAllRooms():Void
	{
		while (rooms.length > 0)
		{
			rooms.pop();
		}
	}
	
	public function hasSpace():Bool
	{
		return !filled;
	}
	
	public function spaceFor(check:Room):Bool
	{
		var r1:Rectangle = check.dimensions();
		var r2:Rectangle;
		
		for (room in rooms)
		{
			r2 = room.dimensions();
			if (r1.intersects(r2))
			{
				return false;
			}
		}
		
		return true;
	}
}