package net.mkv25.room.generator;

import net.mkv25.room.generator.CorridorGenerator;
import net.mkv25.room.generator.RoomGenerator;
import net.mkv25.room.planner.Floorplan;

class FloorplanGenerator
{
	public var wos:Int = 0;
	public var tos:Int = 0;
	
	var roomGenerator:RoomGenerator;
	var corridorGenerator:CorridorGenerator;
	
	public function new() 
	{
		roomGenerator = new RoomGenerator();
		corridorGenerator = new CorridorGenerator();
	}
	
	public function generateFloorplan(floorplan:Floorplan):Void
	{
		floorplan.removeAllRooms();
		floorplan.width = 38;
		floorplan.height = 18;
		
		roomGenerator.generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 5, 6, 5, 3);
		roomGenerator.generateRoom(floorplan, 3 + tos, 4 + wos, 2 + wos, 9, 5, 22, 3, 3);
		roomGenerator.generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 5, 6, 5, 3);
		
		roomGenerator.generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 2, 13, 6, 5, 2);
		roomGenerator.generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 9, 12, 9, 6, 3);
		roomGenerator.generateRoom(floorplan, 1 + tos, 4 + wos, 3 + wos, 19, 12, 2, 6, 3);
		roomGenerator.generateRoom(floorplan, 2 + tos, 4 + wos, 2 + wos, 22, 12, 9, 6, 3);
		roomGenerator.generateRoom(floorplan, 1 + tos, 4 + wos, 1 + wos, 32, 13, 6, 5, 2);
		
		corridorGenerator.generateCorridors(floorplan);
	}
}