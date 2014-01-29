package net.mkv25.room.builder;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import openfl.Assets;

class MapViewer
{	
	public var grid:Bitmap;
	
	var floors:Tileset;
	var walls:Wallset;
	
	var wos:Int = 0;
	var tos:Int = 0;
	
	public function new() 
	{
		grid = new Bitmap();
		
		floors = new Tileset(Tile.WIDTH, Tile.HEIGHT, Assets.getBitmapData('img/g02.png'));
		walls = new Wallset(Wallpiece.WIDTH, Wallpiece.HEIGHT, Assets.getBitmapData('img/w01.png'));
	}
	
	public function setup(columns:Int, rows:Int):Void
	{
		grid.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT);
		
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		drawRoomSamples();
	}
	
	public function blitRoom(tile:Int, wall:Int, wallpaper:Int, x:Int, y:Int, width:Int, height:Int, depth:Int=2)
	{
		tile = tile % 64;
		wall = wall % 16;
		
		floors.blitTileFill(tile, grid.bitmapData, x, y, width, height); 
		walls.blitWallPaper(wallpaper, grid.bitmapData, x, y - depth, width, depth);
		walls.blitOutsideWallBox(wall, grid.bitmapData, x, y - depth, width, height + depth);
	}
	
	public function drawRoomSamples()
	{
		walls.blitOutsideWallBox(0, grid.bitmapData, 1, 1, 38, 18);
		floors.blitTileFill(0, grid.bitmapData, 1, 1, 38, 18);
		
		blitRoom(1 + tos, 4 + wos, 1 + wos, 2, 5, 6, 5, 3);
		blitRoom(3 + tos, 4 + wos, 2 + wos, 9, 5, 22, 3, 3);
		blitRoom(1 + tos, 4 + wos, 1 + wos, 32, 5, 6, 5, 3);
		
		blitRoom(1 + tos, 4 + wos, 1 + wos, 2, 13, 6, 5, 2);
		blitRoom(2 + tos, 4 + wos, 2 + wos, 9, 12, 9, 6, 3);
		blitRoom(1 + tos, 4 + wos, 3 + wos, 19, 12, 2, 6, 3);
		blitRoom(2 + tos, 4 + wos, 2 + wos, 22, 12, 9, 6, 3);
		blitRoom(1 + tos, 4 + wos, 1 + wos, 32, 13, 6, 5, 2);
	}
	
	public function cycleRoomSamples(?e)
	{
		grid.bitmapData.fillRect(new Rectangle(0, 0, grid.width, grid.height), 0xFFAAAAAA);
		
		tos = (tos + 1) % 32;
		wos = (wos + 1) % 16;
		drawRoomSamples();
	}
	
}