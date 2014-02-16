package net.mkv25.room.planner;
import flash.geom.Rectangle;

class Floorplan
{
	public var x:Int;
	public var y:Int;
	
	public var width:Int;
	public var height:Int;
	public var rooms:List<Room>;
	public var corridors:List<Corridor>;

	private var filled:Bool;
	
	public function new() 
	{
		x = 0;
		y = 0;
		width = 10;
		height = 10;
		rooms = new List<Room>();
		corridors = new List<Corridor>();
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
	
	public function addCorridor(corridor:Corridor):Bool
	{
		if (spaceFor(corridor))
		{
			corridors.add(corridor);
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
		
		for (corridor in corridors)
		{
			r2 = corridor.dimensions();
			if (r1.intersects(r2))
			{
				return false;
			}
		}
		
		return true;
	}
}