package net.mkv25.room.planner;

import flash.geom.Rectangle;
import net.mkv25.room.api.IFloorplanTileable;
import net.mkv25.room.planner.Door;

class Room implements IFloorplanTileable
{
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var depth:Int;
	
	public var floorType:Int;
	public var wallpaperType:Int;
	public var wallType:Int;
	
	public var doors:List<Door>;
	
	private var rectangle:Rectangle;
	
	public function new() 
	{
		rectangle = new Rectangle();
		doors = new List<Door>();
	}
	
	public function dimensions():Rectangle
	{
		rectangle.x = x;
		rectangle.y = y;
		rectangle.width = width;
		rectangle.height = height;
		
		return rectangle;
	}
	
	public function addDoor(door:Door):Void
	{
		doors.push(door);
	}
	
	public function mapTo(map:FloorplanMap):Void
	{
		for (j in 0...height)
		{
			for (i in 0...width) {
				map.set(x + i, y + j, this);
			}
		}
		
		for (door in doors)
		{
			door.mapTo(map);
		}
	}
}