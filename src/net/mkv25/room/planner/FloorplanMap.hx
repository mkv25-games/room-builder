package net.mkv25.room.planner;

import net.mkv25.room.api.IFloorplanTileable;

class FloorplanMap
{
	var floorplan:Floorplan;
	var map:Map < String, IFloorplanTileable > ;

	public function new(floorplan:Floorplan) 
	{
		this.floorplan = floorplan;
		map = new Map < String, IFloorplanTileable >();
	}
	
	public function reset():Void
	{
		var keys = map.keys();
		while (keys.hasNext())
		{
			var key = keys.next();
			map.remove(key);
		}
	}
	
	public function set(x:Int, y:Int, tile:IFloorplanTileable):Void
	{
		var key = createKey(x, y);
		map.set(key, tile);
	}
	
	public function get(x:Int, y:Int):IFloorplanTileable
	{
		var key = createKey(x, y);
		var tile = map.get(key);
		
		return tile;
	}
	
	private inline function createKey(x:Int, y:Int):String
	{
		return x + ", " + y;
	}
}