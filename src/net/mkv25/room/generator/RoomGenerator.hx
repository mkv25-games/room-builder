package net.mkv25.room.generator;

import net.mkv25.room.planner.Corridor;
import net.mkv25.room.planner.Door;
import net.mkv25.room.planner.Floorplan;
import net.mkv25.room.planner.Room;

class RoomGenerator
{
	public function new() 
	{
		
	}
	
	public function generateRoom(floorplan:Floorplan, tile:Int, wall:Int, wallpaper:Int, x:Int, y:Int, width:Int, height:Int, depth:Int=2):Room
	{
		var room = new Room();
		
		room.floorType = tile;
		room.wallType = wall;
		room.wallpaperType = wallpaper;
		
		room.x = x;
		room.y = y;
		room.width = width;
		room.height = height;
		room.depth = depth;
		
		generateSideWallDoors(room);
		generateNorthWallDoors(room);
		
		floorplan.addRoom(room);
		
		return room;
	}
	
	function generateSideWallDoors(room:Room):Void
	{
		generateSideWallDoorsHelper(room, room.width, DoorDirectionEnum.East);
		generateSideWallDoorsHelper(room, -1, DoorDirectionEnum.West);
	}
	
	function generateSideWallDoorsHelper(room:Room, wallx:Int, direction:DoorDirectionEnum):Void
	{
		if (room.height > 3 && room.height % 2 == 0)
		{
			var topDoor = new Door(room);
			topDoor.doorType = 0;
			topDoor.x = wallx;  
			topDoor.y = Math.round(room.height / 2) - 1;
			topDoor.direction = direction;
			
			var bottomDoor = new Door(room);
			bottomDoor.doorType = 0;
			bottomDoor.x = wallx;
			bottomDoor.y = Math.round(room.height / 2);
			bottomDoor.direction = direction;
			
			room.addDoor(topDoor);
			room.addDoor(bottomDoor);
		}
		else
		{
			if (room.width > 2)
			{
				var door = new Door(room);
				door.doorType = 0;
				door.x = wallx;
				door.y = Math.floor(room.height / 2);
				door.direction = direction;
				
				room.addDoor(door);
			}
		}
	}
	
	function generateNorthWallDoors(room:Room):Void
	{
		if (room.width > 3 && room.width % 2 == 0)
		{
			var leftDoor = new Door(room);
			leftDoor.doorType = 5;
			leftDoor.x = Math.round(room.width / 2) - 1;
			leftDoor.y = -1;
			leftDoor.direction = DoorDirectionEnum.North;
			
			var rightDoor = new Door(room);
			rightDoor.doorType = 6;
			rightDoor.x = Math.round(room.width / 2);
			rightDoor.y = -1;
			rightDoor.direction = DoorDirectionEnum.North;
			
			room.addDoor(leftDoor);
			room.addDoor(rightDoor);
		}
		else
		{		
			if (room.width > 2)
			{
				var door = new Door(room);
				door.doorType = 4;
				door.x = 1;
				door.y = -1;
				door.direction = DoorDirectionEnum.North;
				
				room.addDoor(door);
			}
			
			if (room.width > 4)
			{
				var door = new Door(room);
				door.doorType = 4;
				door.x = room.width - 2;
				door.y = -1;
				door.direction = DoorDirectionEnum.North;
				
				room.addDoor(door);
			}
		}
	}
	
}