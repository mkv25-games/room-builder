package net.mkv25.room.planner;

import net.mkv25.room.api.IFloorplanTileable;
import net.mkv25.room.planner.Door.DoorDirectionEnum;

enum DoorDirectionEnum {
	North;
	South;
	East;
	West;
	Up;
	Down;
}

class Door implements IFloorplanTileable
{
	public static inline var WIDTH:Int = 32;
	public static inline var HEIGHT:Int = 64;
	
	var room:Room;
	
	public function new(room:Room)
	{
		this.direction = DoorDirectionEnum.North;
		this.room = room;
	}
	
	public var doorType:Int = 0;
	public var x:Int = 0;
	public var y:Int = 0;
	public var direction:DoorDirectionEnum;
	
	public function mapX():Int
	{
		return room.x + x;
	}
	
	public function mapY():Int
	{
		return room.y + y;
	}
	
	public function mapTo(map:FloorplanMap):Void
	{
		map.set(room.x + x, room.y + y, this);
	}
}