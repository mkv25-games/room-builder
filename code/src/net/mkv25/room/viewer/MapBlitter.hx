package net.mkv25.room.viewer;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import haxe.Timer;
import net.mkv25.room.builder.Tile;
import net.mkv25.room.builder.Tileset;
import net.mkv25.room.builder.Wallpiece;
import net.mkv25.room.builder.Wallset;
import net.mkv25.room.generator.FloorplanGenerator;
import net.mkv25.room.pathfinding.PathFinder;
import net.mkv25.room.planner.Corridor;
import net.mkv25.room.planner.Door;
import net.mkv25.room.planner.Floorplan;
import net.mkv25.room.planner.Room;
import openfl.Assets;

class MapBlitter implements Blittable
{	
	public var artwork:Bitmap;
	public var frame:Int;
	public var layer:Int;
	public var dirty:Bool;
	
	public var floorplan:Floorplan;
	
	public var baseColour:Int = 0xFFAAAAAA;
	
	var floorPainter:Tileset;
	var wallPainter:Wallset;
	var doorPainter:Tileset;
	
	public function new() 
	{
		artwork = new Bitmap();
		frame = 0;
		layer = 0;
		dirty = false;
		
		floorplan = new Floorplan();
		
		floorPainter = new Tileset(Tile.WIDTH, Tile.HEIGHT, Assets.getBitmapData('img/g02.png'));
		wallPainter = new Wallset(Wallpiece.WIDTH, Wallpiece.HEIGHT, Assets.getBitmapData('img/w01.png'));
		doorPainter = new Tileset(Door.WIDTH, Door.HEIGHT, Assets.getBitmapData('img/d01.png'));
	}
	
	public function setup(floorplan:Floorplan, columns:Int, rows:Int):Void
	{
		this.floorplan = floorplan;
		artwork.bitmapData = new BitmapData(columns * Tile.WIDTH, rows * Tile.HEIGHT, false, baseColour);
		
		dirty = true;
	}
	
	public function redraw():Void
	{
		drawRooms(floorplan);
		
		dirty = false;
	}
	
	function drawRooms(floorplan:Floorplan):Void
	{
		wallPainter.blitOutsideWallBox(0, artwork.bitmapData, 1, 1, floorplan.width, floorplan.height);
		floorPainter.blitTileFill(0, artwork.bitmapData, 1, 1, floorplan.width, floorplan.height);
		
		for (room in floorplan.rooms)
		{
			blitRoom(room);
		}
	}
	
	function blitRoom(room:Room)
	{
		room.floorType = room.floorType % 64;
		room.wallType = room.wallType % 16;
		room.wallpaperType = room.wallpaperType % 16;
		
		floorPainter.blitTileFill(room.floorType, artwork.bitmapData, room.x, room.y, room.width, room.height); 
		wallPainter.blitWallPaper(room.wallpaperType, artwork.bitmapData, room.x, room.y - room.depth, room.width, room.depth);
		wallPainter.blitOutsideWallBox(room.wallType, artwork.bitmapData, room.x, room.y - room.depth, room.width, room.height + room.depth);
		for (door in room.doors)
		{
			doorPainter.blitTile(door.doorType, artwork.bitmapData, room.x + door.x, (room.y + door.y - 1) / 2);
		}
	}
}