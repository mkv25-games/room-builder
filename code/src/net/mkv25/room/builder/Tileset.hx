package net.mkv25.room.builder;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class Tileset
{
	private var tileWidth:Int;
	private var tileHeight:Int;
	private var asset:BitmapData;
	
	private var columns:Int;
	private var rows:Int;
	
	private var r1:Rectangle;
	private var r2:Rectangle;
	
	private var p1:Point;
	private var p2:Point;
	
	public function new(tileWidth:Int, tileHeight:Int, asset:BitmapData)
	{
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		this.asset = asset;
		
		r1 = new Rectangle();
		r2 = new Rectangle();
		
		p1 = new Point();
		p2 = new Point();
		
		r1.width = tileWidth;
		r1.height = tileHeight;
		
		columns = Math.floor(asset.width / tileWidth);
		rows = Math.floor(asset.height / tileHeight);
	}
	
	public function blitTile(index:Int, target:BitmapData, x:Int, y:Int):Void
	{		
		r1.x = (index % columns) * r1.width;
		r1.y = Math.floor(index / columns) * r1.height;
		
		p1.x = x * tileWidth;
		p1.y = y * tileHeight;
		
		target.copyPixels(asset, r1, p1, null, null, true);
	}
	
	public function blitTileFill(index:Int, target:BitmapData, x:Int, y:Int, tilesWide:Int, tilesHigh:Int):Void
	{		
		r1.x = (index % columns) * r1.width;
		r1.y = Math.floor(index / columns) * r1.height;
		
		for (j in 0...tilesHigh)
		{
			for (i in 0...tilesWide)
			{
				p1.x = (x + i) * tileWidth;
				p1.y = (y + j) * tileHeight;
				
				target.copyPixels(asset, r1, p1, null, null, true);
			}
		}
	}
	
}