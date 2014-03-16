package net.mkv25.room.viewer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ds.IntMap.IntMap;

class Blitter
{
	var viewport:Viewport;
	
	var layers:IntMap<BlittableLayer>;
	
	var boundary:Rectangle;
	var box:Rectangle;
	var sourceRectangle:Rectangle;
	var copyPoint:Point;
	
	var layerCount:Int;
	var itemCount:Int;
	var drawCount:Int;

	public function new(viewport:Viewport) 
	{
		this.viewport = viewport;
		
		layers = new IntMap<BlittableLayer>();
		
		boundary = new Rectangle();
		box = new Rectangle();
		sourceRectangle = new Rectangle();
		copyPoint = new Point();
		
		layerCount = 0;
		itemCount = 0;
		drawCount = 0;
		
		trace("Created Blitter");
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
	
	public function redraw():Void
	{
		layerCount = 0;
		itemCount = 0;
		drawCount = 0;
		
		if (viewport.requestClear)
		{
			viewport.clear();
		}
		
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
		var width = viewport.artwork.bitmapData.width;
		var height = viewport.artwork.bitmapData.height;
		
		var hw = width / 2;
		var hh = height / 2;
		
		boundary.x = - viewport.viewx - viewport.centerx;
		boundary.y = - viewport.viewy - viewport.centery;
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
		viewport.artwork.bitmapData.fillRect(box, (drawCount > 0) ? 0xFFFFFF : 0x000000);
			
		// draw box for layer count
		box.x = 15;
		box.y = 5;
		viewport.artwork.bitmapData.fillRect(box, (layerCount > 0) ? 0xFFFFFF : 0x000000);
		
		// draw box for item count
		box.x = 25;
		box.y = 5;
		viewport.artwork.bitmapData.fillRect(box, (itemCount > 0) ? 0xFFFFFF : 0x000000);
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
			
			copyPoint.x = box.x - boundary.x;  // + viewport.viewx + viewport.centerx;
			copyPoint.y = box.y - boundary.y; // + viewport.viewy + viewport.centery;
			
			viewport.artwork.bitmapData.copyPixels(item.artwork.bitmapData, sourceRectangle, copyPoint, null, null, true);
			drawCount++;
		}
	}
}