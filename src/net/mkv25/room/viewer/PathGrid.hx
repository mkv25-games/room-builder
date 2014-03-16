package net.mkv25.room.viewer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import net.mkv25.room.builder.Tile;
import net.mkv25.room.pathfinding.PathFinder;
import net.mkv25.room.planner.Floorplan;

class PathGrid implements Blittable
{
	var pathfinder:PathFinder;
	
	public var artwork:Bitmap;
	public var frame:Int;
	public var layer:Int;
	public var dirty:Bool;
	
	var pathgrid:Sprite;
	var paths:Sprite;
	
	var drawPathingInfo:Bool = false;
	
	public function new(pathfinder:PathFinder) 
	{
		this.pathfinder = pathfinder;
		
		artwork = new Bitmap();
		frame = 0;
		layer = 10;
		dirty = false;
		
		pathgrid = new Sprite();
		paths = new Sprite();
	}
	
	public function setup(columns:Int, rows:Int):Void
	{
		artwork.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT, true, 0x00FF0000);
		
		dirty = true;
	}
	
	public function redraw():Void
	{
		artwork.bitmapData.draw(pathgrid);
		artwork.bitmapData.draw(paths);
		
		dirty = false;
	}
	
	public function generatePathing(floorplan:Floorplan):Void
	{
		pathfinder.graphFloorplan(floorplan);
		pathfinder.report();
		
		if (drawPathingInfo)
		{
			pathfinder.draw(pathgrid);
		}
	}
	
	public function togglePathingInfo():Void
	{
		drawPathingInfo = !drawPathingInfo;
		
		if (drawPathingInfo)
		{
			pathfinder.draw(pathgrid);
		}
		else
		{
			pathgrid.graphics.clear();
			paths.graphics.clear();
		}
		
		dirty = true;
	}
	
	public function pathBetween(x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		var path = pathfinder.findPath(x1, y1, x2, y2);
		
		if (drawPathingInfo)
		{
			pathfinder.drawPath(paths, path);
		}
		
		dirty = true;
	}
}