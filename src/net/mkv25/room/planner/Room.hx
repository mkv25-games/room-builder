package net.mkv25.room.planner;
import flash.geom.Rectangle;

class Room
{
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var depth:Int;
	
	public var floor:Int;
	public var wallpaper:Int;
	public var walls:Int;
	
	private var rectangle:Rectangle;
	
	public function new() 
	{
		rectangle = new Rectangle();
	}
	
	public function dimensions():Rectangle
	{
		rectangle.x = x;
		rectangle.y = y;
		rectangle.width = width;
		rectangle.height = height;
		
		return rectangle;
	}
}