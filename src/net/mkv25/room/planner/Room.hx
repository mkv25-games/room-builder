package net.mkv25.room.planner;

import flash.geom.Rectangle;
import net.mkv25.room.builder.Door;

class Room
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
}