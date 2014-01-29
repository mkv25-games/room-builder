package net.mkv25.room.builder;
import flash.display.BitmapData;

class Wallset extends Tileset
{	
	public static inline var GROUPS_WIDE:Int = 8;
	
	public function blitInsideWallBox(wallGroup:Int, target:BitmapData, x:Int, y:Int, gridWidth:Int, gridHeight:Int):Void
	{
		var groupX = wallGroup % GROUPS_WIDE;
		var groupY = Math.floor(wallGroup / GROUPS_WIDE);
		
		var groupOffset = (groupX * 4) + (groupY * columns * 10);
		var TL = groupOffset + 0 + (columns * 2);
		var TR = groupOffset + 3 + (columns * 2);
		var BL = groupOffset + 0 + (columns * 5);
		var BR = groupOffset + 3 + (columns * 5);
		
		var HT = groupOffset + 1 + (columns * 2);
		var VL = groupOffset + 0 + (columns * 3);
		var HB = groupOffset + 1 + (columns * 5);
		var VR = groupOffset + 3 + (columns * 3);
		
		target.lock();
		
		blitTile(TL, target, x * 2, y * 2);
		blitTile(TR, target, (x + gridWidth) * 2 - 1, y * 2);
		blitTile(BL, target, x * 2, (y + gridHeight - 1) * 2 + 1);
		blitTile(BR, target, (x + gridWidth) * 2 - 1, (y + gridHeight - 1) * 2 + 1);
		
		blitHorizontalWall(HT, target, x * 2 + 1, y * 2, (gridWidth - 1) * 2);
		blitVerticalWall(VL, target, x * 2, y * 2 + 1, (gridHeight - 1) * 2);
		blitHorizontalWall(HB, target, x * 2 + 1, (y + gridHeight) * 2 - 1, (gridWidth - 1) * 2);
		blitVerticalWall(VR, target, (x + gridWidth) * 2 - 1, y * 2 + 1, (gridHeight - 1) * 2);
		
		target.unlock();
	}
	
	public function blitOutsideWallBox(wallGroup:Int, target:BitmapData, x:Int, y:Int, gridWidth:Int, gridHeight:Int):Void
	{
		var groupX = wallGroup % GROUPS_WIDE;
		var groupY = Math.floor(wallGroup / GROUPS_WIDE);
		var groupOffset = (groupX * 4) + (groupY * columns * 10);
		
		var TL = groupOffset + 3 + (columns * 1);
		var TR = groupOffset + 2 + (columns * 1);
		var BL = groupOffset + 3 + (columns * 0);
		var BR = groupOffset + 2 + (columns * 0);
		
		var HB = groupOffset + 1 + (columns * 2);
		var VR = groupOffset + 0 + (columns * 3);
		var HT = groupOffset + 1 + (columns * 5);
		var VL = groupOffset + 3 + (columns * 3);
		
		target.lock();
		
		blitTile(TL, target, (x * 2) - 1, (y * 2) - 1);
		blitTile(TR, target, (x + gridWidth) * 2, (y * 2) - 1);
		blitTile(BL, target, (x * 2) - 1, (y + gridHeight) * 2);
		blitTile(BR, target, (x + gridWidth) * 2, (y + gridHeight) * 2);
		
		blitHorizontalWall(HT, target, x * 2, y * 2 - 1, (gridWidth) * 2);
		blitVerticalWall(VL, target, x * 2 - 1, y * 2, (gridHeight) * 2);
		blitHorizontalWall(HB, target, x * 2, (y + gridHeight) * 2, (gridWidth) * 2);
		blitVerticalWall(VR, target, (x + gridWidth) * 2 , y * 2, (gridHeight) * 2);
		
		target.unlock();
	}
	
	public function blitWallPaper(wallGroup:Int, target:BitmapData, x:Int, y:Int, gridWidth:Int, gridHeight:Int):Void
	{
		var groupX = wallGroup % GROUPS_WIDE;
		var groupY = Math.floor(wallGroup / GROUPS_WIDE);
		var groupOffset = (groupX * 4) + (groupY * columns * 10);
		
		var TL = groupOffset + 0 + (columns * 6);
		var TR = groupOffset + 3 + (columns * 6);
		var BL = groupOffset + 0 + (columns * 9);
		var BR = groupOffset + 3 + (columns * 9);
		
		var HB = groupOffset + 1 + (columns * 9);
		var VR = groupOffset + 3 + (columns * 7);
		var HT = groupOffset + 1 + (columns * 6);
		var VL = groupOffset + 0 + (columns * 7);
		
		var WP = groupOffset + 1 + (columns * 7);
		
		target.lock();
		
		blitTile(TL, target, x * 2, y * 2);
		blitTile(TR, target, (x + gridWidth) * 2 - 1, y * 2);
		blitTile(BL, target, x * 2, (y + gridHeight - 1) * 2 + 1);
		blitTile(BR, target, (x + gridWidth) * 2 - 1, (y + gridHeight - 1) * 2 + 1);
		
		blitHorizontalWall(HT, target, x * 2 + 1, y * 2, (gridWidth - 1) * 2);
		blitVerticalWall(VL, target, x * 2, y * 2 + 1, (gridHeight - 1) * 2);
		blitHorizontalWall(HB, target, x * 2 + 1, (y + gridHeight) * 2 - 1, (gridWidth - 1) * 2);
		blitVerticalWall(VR, target, (x + gridWidth) * 2 - 1, y * 2 + 1, (gridHeight - 1) * 2);
		
		blitWallpaperFill(WP, target, x * 2 + 1, y * 2 + 1, (gridWidth - 1) * 2, (gridHeight - 1) * 2);
		
		target.unlock();
	}
	
	public function blitWallpaperFill(index:Int, target:BitmapData, x:Int, y:Int, tilesWide:Int, tilesHigh:Int):Void
	{
		for (j in 0...tilesHigh)
		{
			for (i in 0...tilesWide)
			{		
				r1.x = ((index + (i % 2)) % columns) * r1.width;
				r1.y = (Math.floor(index / columns) + (j % 2)) * r1.height;
				
				p1.x = (x + i) * tileWidth;
				p1.y = (y + j) * tileHeight;
				
				target.copyPixels(asset, r1, p1, null, null, true);
			}
		}
	}
	
	public function blitHorizontalWall(index:Int, target:BitmapData, x:Int, y:Int, tilesWide:Int):Void
	{
		for (i in 0...tilesWide)
		{
			r1.x = ((index + (i % 2)) % columns) * r1.width;
			r1.y = Math.floor(index / columns) * r1.height;
			
			p1.x = (x + i) * tileWidth;
			p1.y = y * tileHeight;
			
			target.copyPixels(asset, r1, p1, null, null, true);
		}
	}
	
	public function blitVerticalWall(index:Int, target:BitmapData, x:Int, y:Int, tilesHigh:Int):Void
	{
		for (j in 0...tilesHigh)
		{		
			r1.x = (index % columns) * r1.width;
			r1.y = (Math.floor(index / columns) + (j % 2)) * r1.height;
			
			p1.x = x * tileWidth;
			p1.y = (y + j) * tileHeight;
			
			target.copyPixels(asset, r1, p1, null, null, true);
		}
	}
}