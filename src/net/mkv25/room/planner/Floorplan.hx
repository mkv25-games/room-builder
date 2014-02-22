package net.mkv25.room.planner;
import flash.geom.Rectangle;

class Floorplan
{
	public var width:Int;
	public var height:Int;
	public var rooms:List<Room>;
	public var corridors:List<Corridor>;

	var map:FloorplanMap;
	
	public function new() 
	{
		width = 10;
		height = 10;
		rooms = new List<Room>();
		corridors = new List<Corridor>();
		
		map = new FloorplanMap(this);
	}
	
	public function addRoom(room:Room):Bool
	{
		if (spaceFor(room))
		{
			rooms.add(room);
			room.mapTo(map);
			return true;
		}
		
		return false;
	}
	
	public function addCorridor(corridor:Corridor):Bool
	{
		if (spaceFor(corridor))
		{
			corridors.add(corridor);
			corridor.mapTo(map);
			return true;
		}
		return false;
	}
	
	public function removeAllRooms():Void
	{
		map.reset();
		
		while (rooms.length > 0)
		{
			rooms.pop();
		}
		
		while (corridors.length > 0)
		{
			corridors.pop();
		}
	}
	
	public function hasSpaceAt(x:Int, y:Int):Bool
	{
		var tile = map.get(x, y);
		
		return (tile == null);
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