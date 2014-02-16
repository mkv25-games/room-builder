package net.mkv25.room.builder;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import haxe.Timer;
import net.mkv25.room.pathfinding.PathFinder;
import net.mkv25.room.planner.Corridor;
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
	
	var floorPainter:Tileset;
	var wallPainter:Wallset;
	var doorPainter:Tileset;
	
	var wos:Int = 0;
	var tos:Int = 0;
	
	
	public function new() 
	{
		grid = new Bitmap();
		pathgrid = new Sprite();
		paths = new Sprite();
		
		floorplan = new Floorplan();
		pathFinder = new PathFinder();
		
		floorPainter = new Tileset(Tile.WIDTH, Tile.HEIGHT, Assets.getBitmapData('img/g02.png'));
		wallPainter = new Wallset(Wallpiece.WIDTH, Wallpiece.HEIGHT, Assets.getBitmapData('img/w01.png'));
		doorPainter = new Tileset(Door.WIDTH, Door.HEIGHT, Assets.getBitmapData('img/d01.png'));
	}
	
	public function setup(columns:Int, rows:Int):Void
	{
		grid.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT);
		
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		generateRoomSamples();
	}
	
	public function generateRoomSamples()
	{
		//*
		floorplan.removeAllRooms();
		floorplan.width = 38;
		floorplan.height = 18;
		
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 5, 6, 5, 3);
		generateRoom(floorplan, 3 + tos, 4 + wos, 2 + wos, 9, 5, 22, 3, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 5, 6, 5, 3);
		
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 13, 6, 5, 2);
		generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 9, 12, 9, 6, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 3 + wos, 19, 12, 2, 6, 3);
		generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 22, 12, 9, 6, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 13, 6, 5, 2);
		
		generateCorridor(floorplan, 8, 6, 1, 1);
		generateCorridor(floorplan, 31, 6, 1, 1);
		generateCorridor(floorplan, 8, 14, 1, 1);
		generateCorridor(floorplan, 31, 14, 1, 1);
		generateCorridor(floorplan, 18, 13, 1, 1);
		generateCorridor(floorplan, 21, 13, 1, 1);
		generateCorridor(floorplan, 13, 8, 1, 4);
		generateCorridor(floorplan, 26, 8, 1, 4);
		generateCorridor(floorplan, 3, 10, 1, 3);
		generateCorridor(floorplan, 36, 10, 1, 3);
		generateCorridor(floorplan, 18, 16, 1, 1);
		generateCorridor(floorplan, 21, 16, 1, 1);
		//*/
		
		// generateFloorplan(floorplan, 38, 18, 7);
		
		drawRooms(floorplan);
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
	
	public function generateFloorplan(floorplan:Floorplan, maxWidth:Int, maxHeight:Int, roomSize:Int, walls:Int=5):Void
	{
		floorplan.removeAllRooms();
		
		floorplan.width = maxWidth;
		floorplan.height = maxHeight;
		
		var spacing = 1;
		var depth = 2;		
	}
	
	public function generateRoom(floorplan:Floorplan, tile:Int, wall:Int, wallpaper:Int, x:Int, y:Int, width:Int, height:Int, depth:Int=2):Room
	{
		var room = new Room();
		
		room.floorType = tile;
		room.wallType = wall;
		room.wallpaperType = wallpaper;
		
		room.x = x;
		room.y = y;
		room.width = width;
		room.height = height;
		room.depth = depth;
		
		generateDoors(room);
		
		floorplan.addRoom(room);
		
		return room;
	}
	
	public function generateDoors(room:Room):Void
	{
		if (room.width > 3 && room.width % 2 == 0)
		{
			var leftDoor = new Door();
			leftDoor.doorType = 5;
			leftDoor.x = Math.round(room.width / 2) - 1;
			leftDoor.y = -1;
			
			var rightDoor = new Door();
			rightDoor.doorType = 6;
			rightDoor.x = Math.round(room.width / 2);
			rightDoor.y = -1;
			
			room.addDoor(leftDoor);
			room.addDoor(rightDoor);
		}
		else
		{		
			if (room.width > 2)
			{
				var door = new Door();
				door.doorType = 4;
				door.x = 1;
				door.y = -1;
				room.addDoor(door);
			}
			
			if (room.width > 4)
			{
				var door = new Door();
				door.doorType = 4;
				door.x = room.width - 2;
				door.y = -1;
				room.addDoor(door);
			}
		}
	}
	
	public function generateCorridor(floorplan:Floorplan, x:Int, y:Int, width:Int, height:Int, depth:Int = 2)
	{
		var corridor = new Corridor();
		
		corridor.x = x;
		corridor.y = y;
		corridor.width = width;
		corridor.height = height;
		corridor.depth = depth;
		
		floorplan.addCorridor(corridor);
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
		
		tos = (tos + 1) % 32;
		wos = (wos + 1) % 16;
		generateRoomSamples();
	}
	
}