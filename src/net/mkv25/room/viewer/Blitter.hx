package net.mkv25.room.viewer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ds.IntMap.IntMap;

class Blitter
{
	public var artwork:Bitmap;
	public var baseColour:Int;
	
	public var centerx:Int;
	public var centery:Int;
	
	public var viewx:Int;
	public var viewy:Int;
	
	var boundary:Rectangle;
	var box:Rectangle;
	var sourceRectangle:Rectangle;
	var copyPoint:Point;
	
	var layers:IntMap<BlittableLayer>;

	public function new() 
	{
		artwork = new Bitmap(null, PixelSnapping.ALWAYS, false);
		baseColour = 0xFFAA5555;
		
		centerx = 0;
		centery = 0;
		
		viewx = 0;
		viewy = 0;
		
		boundary = new Rectangle();
		box = new Rectangle();
		sourceRectangle = new Rectangle();
		copyPoint = new Point();
		
		layers = new IntMap<BlittableLayer>();
		
		trace("Created Blitter");
	}

	public function resize(width:Int, height:Int):Void
	{
		artwork.bitmapData = new BitmapData(width, height, false, baseColour);
		
		centerx = Std.int(width / 2);
		centery = Std.int(height / 2);
		
		trace("Resized Blitter");
	}
	
	public function add(renderItem:Blittable):Void
	{
		var layer:BlittableLayer = layers.get(renderItem.layer);
		if (layer == null) {
			layer = new BlittableLayer();
			layers.set(renderItem.layer, layer);
			
			trace("Created Blittable Layer: " + renderItem.layer);
		}
		
		layer.add(renderItem);
	}
	
	public function remove(renderItem:Blittable):Void
	{
		var layer:BlittableLayer = layers.get(renderItem.layer);
		if (layer == null) {
			trace("Render Item refers to non-existant Blittable Layer");
			return;
		}
		
		layer.remove(renderItem);
	}
	
	public function clear():Void
	{
		artwork.bitmapData.fillRect(new Rectangle(0, 0, artwork.width, artwork.height), baseColour);
	}
	
	var layerCount:Int;
	var itemCount:Int;
	var drawCount:Int;
	public function redraw():Void
	{
		layerCount = 0;
		itemCount = 0;
		drawCount = 0;
		
		updateBoundary();
		
		for (layer in layers)
		{
			layer.drawTo(this);
			layerCount++;
		}
		
		drawBlitCounters();
	}
	
	inline function updateBoundary():Void
	{
		var width = artwork.bitmapData.width;
		var height = artwork.bitmapData.height;
		
		var hw = width / 2;
		var hh = height / 2;
		
		boundary.x = - viewx - centerx;
		boundary.y = - viewy - centery;
		boundary.width = width;
		boundary.height = height;
	}
	
	inline function drawBlitCounters():Void
	{
		box.width = 5;
		box.height = 5;
		
		// draw box for draw count
		box.x = 5;
		box.y = 5;
		artwork.bitmapData.fillRect(box, (drawCount > 0) ? 0xFFFFFF : 0x000000);
			
		// draw box for layer count
		box.x = 15;
		box.y = 5;
		artwork.bitmapData.fillRect(box, (layerCount > 0) ? 0xFFFFFF : 0x000000);
		
		// draw box for item count
		box.x = 25;
		box.y = 5;
		artwork.bitmapData.fillRect(box, (itemCount > 0) ? 0xFFFFFF : 0x000000);
	}
	
	public function render(item:Blittable):Void
	{
		if (item.dirty)
		{
			item.redraw();
		}
		
		itemCount++;
		
		box.x = item.artwork.x;
		box.y = item.artwork.y;
		box.width = item.artwork.width;
		box.height = item.artwork.height;
		
		if (boundary.intersects(box))
		{
			sourceRectangle.x = 0;
			sourceRectangle.y = 0;
			sourceRectangle.width = box.width;
			sourceRectangle.height = box.height;
			
			copyPoint.x = box.x + viewx + centerx;
			copyPoint.y = box.y + viewy + centery;
			
			artwork.bitmapData.copyPixels(item.artwork.bitmapData, sourceRectangle, copyPoint, null, null, true);
			drawCount++;
		
		}
	}
}