package net.mkv25.room.viewer;
import flash.display.Bitmap;

class BlittableLayer
{
	var items:Array<Blittable>;
	
	public function new() 
	{
		items = new Array<Blittable>();
	}
	
	public function add(renderItem:Blittable):Void
	{
		items.push(renderItem);
		
		sort();
	}
	
	public function remove(renderItem:Blittable):Void
	{
		items.remove(renderItem);
	}
	
	function sort():Void
	{
		items.sort(sortOnDepth);
	}
	
	function sortOnDepth(a:Blittable, b:Blittable):Int
	{
		var az = a.artwork.y;
		var bz = a.artwork.y;
		
		if (az > bz) {
			return 1;
		}
		
		if (az < bz) {
			return -1;
		}
		
		return 0;
	}
	
	public function drawTo(blitter:Blitter):Void
	{
		sort();
		
		for (item in items)
		{
			blitter.render(item);
		}
	}
}