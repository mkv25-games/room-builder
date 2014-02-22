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
		
		generateDoors(room);
		
		floorplan.addRoom(room);
		
		return room;
	}
	
	function generateDoors(room:Room):List<Door>
	{
		if (room.width > 3 && room.width % 2 == 0)
		{
			var leftDoor = new Door(room);
			leftDoor.doorType = 5;
			leftDoor.x = Math.round(room.width / 2) - 1;
			leftDoor.y = -1;
			
			var rightDoor = new Door(room);
			rightDoor.doorType = 6;
			rightDoor.x = Math.round(room.width / 2);
			rightDoor.y = -1;
			
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
				room.addDoor(door);
			}
			
			if (room.width > 4)
			{
				var door = new Door(room);
				door.doorType = 4;
				door.x = room.width - 2;
				door.y = -1;
				room.addDoor(door);
			}
		}
		
		return room.doors;
	}
	
}