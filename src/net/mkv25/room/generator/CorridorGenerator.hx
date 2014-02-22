package net.mkv25.room.generator;

import net.mkv25.room.planner.Corridor;
import net.mkv25.room.planner.Door;
import net.mkv25.room.planner.Door.DoorDirectionEnum;
import net.mkv25.room.planner.Floorplan;

class CorridorGenerator
{
	public function new() 
	{
		
	}
	
	public function generateCorridors(floorplan:Floorplan):Void
	{
		var corridor:Corridor;
		
		for (room in floorplan.rooms)
		{
			for (door in room.doors)
			{
				generateCorridorForDoor(floorplan, door);
			}
		}
	}
	
	function generateCorridorForDoor(floorplan:Floorplan, door:Door):Corridor
	{
		var vx:Int = 0;
		var vy:Int = 0;
		var vz:Int = 0;
		
		switch(door.direction)
		{
			case DoorDirectionEnum.North:
				vy = -1;
				
			case DoorDirectionEnum.South:
				vy = 1;
				
			case DoorDirectionEnum.East:
				vx = 1;
				
			case DoorDirectionEnum.West:
				vx = -1;
				
			case DoorDirectionEnum.Down:
				vz = -1;
				
			case DoorDirectionEnum.Up:
				vz = 1;
			
		}
		
		return generateCorridorOnVector(floorplan, door.mapX(), door.mapY(), vx, vy);
	}
	
	function generateCorridorOnVector(floorplan:Floorplan, sx:Int, sy:Int, vx:Int=0, vy:Int=0):Corridor
	{
		var MAX_LENGTH:Int = 10;
		var corridor:Corridor = null;
		
		var length:Int = 0;
		for (i in 0...MAX_LENGTH)
		{
			if (i == 0)
			{
				length++;
				continue;
			}
			
			if (floorplan.hasSpaceAt(sx + vx * i, sy + vy * i) == false)
			{
				trace("Corridor conflict at: " + (sx + vx * i) + ", " + (sy + vy * i) + "...");
				length--;
				break;
			}
			
			length++;
		}
		
		if (length == MAX_LENGTH)
		{
			trace("No edge found for corridor in direction " + vx + ", " + vy + " after " + MAX_LENGTH + " tiles.");
		}
		else if (length > 0)
		{
			corridor = new Corridor();
			corridor.x = sx + vx;
			corridor.y = sy + vy;
			corridor.width = vx * length;
			corridor.height = vy * length;
			
			if (corridor.width < 0)
			{
				corridor.x = corridor.x + corridor.width + 1;
				corridor.width = - corridor.width;
				corridor.height = 1;
			}
			
			if (corridor.height < 0)
			{
				corridor.y = corridor.y + corridor.height + 1;
				corridor.height = - corridor.height;
				corridor.width = 1;
			}
			
			var success = floorplan.addCorridor(corridor);
			
			if (success)
			{
				trace("Created corridor: " + corridor.x + ", " + corridor.y + ", " + corridor.width + ", " + corridor.height);
			}
			else
			{
				trace("Failed corridor: " + corridor.x + ", " + corridor.y + ", " + corridor.width + ", " + corridor.height);
			}
		}
		
		return corridor;
	}
	
	function generateCorridor(floorplan:Floorplan, x:Int, y:Int, width:Int, height:Int, depth:Int = 2):Corridor
	{
		var corridor = new Corridor();
		
		corridor.x = x;
		corridor.y = y;
		corridor.width = width;
		corridor.height = height;
		corridor.depth = depth;
		
		floorplan.addCorridor(corridor);
		
		return corridor;
	}
	
}