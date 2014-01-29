package net.mkv25.room.builder;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import net.mkv25.room.planner.Floorplan;
import net.mkv25.room.planner.Room;
import openfl.Assets;

class MapViewer
{	
	public var grid:Bitmap;
	public var floorplan:Floorplan;
	
	var floors:Tileset;
	var walls:Wallset;
	
	var wos:Int = 0;
	var tos:Int = 0;
	
	
	public function new() 
	{
		grid = new Bitmap();
		floorplan = new Floorplan();
		
		floors = new Tileset(Tile.WIDTH, Tile.HEIGHT, Assets.getBitmapData('img/g02.png'));
		walls = new Wallset(Wallpiece.WIDTH, Wallpiece.HEIGHT, Assets.getBitmapData('img/w01.png'));
	}
	
	public function setup(columns:Int, rows:Int):Void
	{
		grid.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT);
		
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		generateRoomSamples();
	}
	
	public function generateRoomSamples()
	{
		floorplan.removeAllRooms();
		
		/*
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 5, 6, 5, 3);
		generateRoom(floorplan, 3 + tos, 4 + wos, 2 + wos, 9, 5, 22, 3, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 5, 6, 5, 3);
		
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 13, 6, 5, 2);
		generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 9, 12, 9, 6, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 3 + wos, 19, 12, 2, 6, 3);
		generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 22, 12, 9, 6, 3);
		generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 13, 6, 5, 2);
		*/
		
		generateFloorplan(floorplan, 38, 18, 7);
		
		drawRooms(floorplan);
	}
	
	public function drawRooms(floorplan:Floorplan)
	{
		walls.blitOutsideWallBox(0, grid.bitmapData, 1, 1, floorplan.width, floorplan.height);
		floors.blitTileFill(0, grid.bitmapData, 1, 1, floorplan.width, floorplan.height);
		
		for (room in floorplan.rooms)
		{
			blitRoom(room);
		}
	}
	
	public function generateFloorplan(floorplan:Floorplan, maxWidth:Int, maxHeight:Int, roomSize:Int, walls:Int=5)
	{
		floorplan.width = maxWidth;
		floorplan.height = maxHeight;
		
		var spacing = 1;
		var depth = 2;
		
		var remainingX:Int = 0;
		var remainingY:Int = maxHeight - spacing * 2;
		
		while (remainingY > depth)
		{
			remainingX = maxWidth - spacing * 2;
			while (remainingX > 0)
			{
				var room = new Room();
				room.x = maxWidth - remainingX;
				room.y = maxHeight - remainingY + depth;
				room.width = cast Math.min(roomSize, remainingX);
				room.height = cast Math.min(roomSize - depth, remainingY);
				room.depth = depth;
				
				room.walls = 5 + wos;
				room.wallpaper = room.x + wos;
				room.floor = room.y + tos;
				
				floorplan.rooms.add(room);
				
				remainingX = remainingX - roomSize - spacing;
			}
			remainingY = remainingY - roomSize - spacing;
		}
	}
	
	public function generateRoom(floorplan:Floorplan, tile:Int, wall:Int, wallpaper:Int, x:Int, y:Int, width:Int, height:Int, depth:Int=2)
	{
		var room = new Room();
		
		room.floor = tile;
		room.walls = wall;
		room.wallpaper = wallpaper;
		
		room.x = x;
		room.y = y;
		room.width = width;
		room.height = height;
		room.depth = depth;
		
		floorplan.rooms.add(room);
	}
	
	public function blitRoom(room:Room)
	{
		room.floor = room.floor % 64;
		room.walls = room.walls % 16;
		room.wallpaper = room.wallpaper % 16;
		
		floors.blitTileFill(room.floor, grid.bitmapData, room.x, room.y, room.width, room.height); 
		walls.blitWallPaper(room.wallpaper, grid.bitmapData, room.x, room.y - room.depth, room.width, room.depth);
		walls.blitOutsideWallBox(room.walls, grid.bitmapData, room.x, room.y - room.depth, room.width, room.height + room.depth);
	}
	
	public function cycleRoomSamples(?e)
	{
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		tos = (tos + 1) % 32;
		wos = (wos + 1) % 16;
		generateRoomSamples();
	}
	
}