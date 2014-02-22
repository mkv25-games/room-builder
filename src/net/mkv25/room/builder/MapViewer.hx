package net.mkv25.room.builder;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import haxe.Timer;
import net.mkv25.room.generator.FloorplanGenerator;
import net.mkv25.room.pathfinding.PathFinder;
import net.mkv25.room.planner.Corridor;
import net.mkv25.room.planner.Door;
import net.mkv25.room.planner.Floorplan;
import net.mkv25.room.planner.Room;
import openfl.Assets;

class MapViewer
{	
	public var grid:Bitmap;
	public var pathgrid:Sprite;
	public var paths:Sprite;
	
	public var floorplan:Floorplan;
	public var pathFinder:PathFinder;
	public var generator:FloorplanGenerator;
	
	var floorPainter:Tileset;
	var wallPainter:Wallset;
	var doorPainter:Tileset;
	
	public function new() 
	{
		grid = new Bitmap();
		pathgrid = new Sprite();
		paths = new Sprite();
		
		floorplan = new Floorplan();
		pathFinder = new PathFinder();
		generator = new FloorplanGenerator();
		
		floorPainter = new Tileset(Tile.WIDTH, Tile.HEIGHT, Assets.getBitmapData('img/g02.png'));
		wallPainter = new Wallset(Wallpiece.WIDTH, Wallpiece.HEIGHT, Assets.getBitmapData('img/w01.png'));
		doorPainter = new Tileset(Door.WIDTH, Door.HEIGHT, Assets.getBitmapData('img/d01.png'));
	}
	
	public function setup(columns:Int, rows:Int):Void
	{
		grid.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT);
		
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		generator.generateFloorplan(floorplan);
	}
	
	public function generatePathing():Void
	{
		pathFinder.graphFloorplan(floorplan);
		pathFinder.report();
		pathFinder.draw(pathgrid);
	}
	
	public function pathBetween(x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		var path = pathFinder.findPath(x1, y1, x2, y2);
		pathFinder.drawPath(paths, path);
	}
	
	public function drawRooms(floorplan:Floorplan):Void
	{
		wallPainter.blitOutsideWallBox(0, grid.bitmapData, 1, 1, floorplan.width, floorplan.height);
		floorPainter.blitTileFill(0, grid.bitmapData, 1, 1, floorplan.width, floorplan.height);
		
		for (room in floorplan.rooms)
		{
			blitRoom(room);
		}
	}
	
	public function drawPaths():Void
	{
		pathFinder.draw(paths);
	}
	
	public function blitRoom(room:Room)
	{
		room.floorType = room.floorType % 64;
		room.wallType = room.wallType % 16;
		room.wallpaperType = room.wallpaperType % 16;
		
		floorPainter.blitTileFill(room.floorType, grid.bitmapData, room.x, room.y, room.width, room.height); 
		wallPainter.blitWallPaper(room.wallpaperType, grid.bitmapData, room.x, room.y - room.depth, room.width, room.depth);
		wallPainter.blitOutsideWallBox(room.wallType, grid.bitmapData, room.x, room.y - room.depth, room.width, room.height + room.depth);
		for (door in room.doors)
		{
			doorPainter.blitTile(door.doorType, grid.bitmapData, room.x + door.x, (room.y + door.y - 1) / 2);
		}
	}
	
	public function cycleRoomSamples(?e)
	{
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		generator.tos = (generator.tos + 1) % 32;
		generator.wos = (generator.wos + 1) % 16;
		
		generator.generateFloorplan(floorplan);
		drawRooms(floorplan);
	}
	
}