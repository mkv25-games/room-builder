package net.mkv25.room.pathfinding;

import flash.display.Graphics;
import flash.display.Sprite;
import net.mkv25.room.pathfinding.AStar;
import net.mkv25.room.pathfinding.AStarWaypoint;
import net.mkv25.room.planner.Floorplan;
import net.mkv25.room.planner.Room;

import de.polygonal.ds.DA.DA;
import de.polygonal.ds.Graph.Graph;
import de.polygonal.ds.GraphNode.GraphNode;

class PathFinder
{
	private var graph:Graph<AStarWaypoint>;
	private var map:Map<String, GraphNode<AStarWaypoint> > ;
	
	private var astar:AStar;
	
	var rooms:Int = 0;
	var corridors:Int = 0;
	var nodes:Int = 0;
	var arcs:Int = 0;
	
	public function new() 
	{
		graph = new Graph<AStarWaypoint>();
		map = new Map<String, GraphNode<AStarWaypoint> > ();
		astar = new AStar(graph);
	}
	
	public function clear():Void
	{
		graph.clear();
		map = new Map<String, GraphNode<AStarWaypoint> > ();
		rooms = 0;
		nodes = 0;
		arcs = 0;
	}
	
	public function graphFloorplan(floorplan:Floorplan):Void
	{
		clear();
		
		for (room in floorplan.rooms)
		{
			graphRoom(floorplan, room);
		}
		
		for (corridor in floorplan.corridors)
		{
			graphCorridor(floorplan, corridor);
		}
		
		for (tile in map)
		{
			arcTile(tile);
		}
	}
	
	public function findPath(sourcex:Int, sourcey:Int, targetx:Int, targety:Int):DA<AStarWaypoint>
	{
		var source = getTileNode(sourcex, sourcey);
		var target = getTileNode(targetx, targety);
		
		var path = new DA<AStarWaypoint>();
		if (source != null && target != null)
		{
			astar.find(graph, source.val, target.val, path);
		}
		
		return path;
	}
	
	private function graphRoom(floorplan:Floorplan, room:Room):Void
	{
		rooms++;
		for (j in 0...room.height)
		{
			for (i in 0...room.width)
			{
				mapTile(floorplan.x + room.x + i, floorplan.y + room.y + j);
			}
		}
	}
	
	private function graphCorridor(floorplan:Floorplan, corridor:Room):Void
	{
		corridors++;
		for (j in 0...corridor.height)
		{
			for (i in 0...corridor.width)
			{
				mapTile(floorplan.x + corridor.x + i, floorplan.y + corridor.y + j);
			}
		}
	}
	
	private function mapTile(tilex:Int, tiley:Int):Void
	{
		var waypoint = new AStarWaypoint();
		waypoint.x = tilex;
		waypoint.y = tiley;
		waypoint.z = 0;
		
		var node = new GraphNode<AStarWaypoint>(graph, waypoint);
		waypoint.node = node;
		
		graph.addNode(node);
		nodes++;
		
		var key = tilex + "," + tiley; 
		map.set(key, node);
	}
	
	private function arcTile(node:GraphNode<AStarWaypoint>):Void
	{
		var tile = node.val;
		var tilex:Int = cast tile.x;
		var tiley:Int = cast tile.y;
		
		var diagonalCost = 1.414;
		
		// arc NESW
		arcNodes(node, tilex, tiley - 1);
		arcNodes(node, tilex + 1, tiley);
		arcNodes(node, tilex, tiley + 1);
		arcNodes(node, tilex - 1, tiley);
		
		arcNodes(node, tilex + 1, tiley - 1, diagonalCost);
		arcNodes(node, tilex + 1, tiley + 1, diagonalCost);
		arcNodes(node, tilex - 1, tiley + 1, diagonalCost);
		arcNodes(node, tilex - 1, tiley - 1, diagonalCost);
	}
	
	private function getTileNode(tilex:Int, tiley:Int):GraphNode<AStarWaypoint>
	{
		var key = tilex + "," + tiley; 
		return map.get(key);
	}
	
	private function arcNodes(tile:GraphNode<AStarWaypoint>, targetx:Int, targety:Int, cost:Float=1.0):Void
	{
		var target = getTileNode(targetx, targety);
		if (tile == null || target == null)
		{
			return;
		}
		
		if (targetx != tile.val.x || targety != tile.val.y)
		{
			var corner1 = getTileNode(cast tile.val.x, targety);
			var corner2 = getTileNode(targetx, cast tile.val.y);
			if (corner1 == null || corner2 == null)
			{
				return;
			}
		}
		
		graph.addSingleArc(tile, target, cost);
		arcs++;
		
	}
	
	public function draw(slate:Sprite):Void
	{
		var scale = 32;
		var offset = scale / 2;
		
		var g:Graphics = slate.graphics;
		g.clear();
		
		for (tile in map)
		{
			var x = tile.val.x * scale + offset;
			var y = tile.val.y * scale + offset;
			
			var arc = tile.arcList;
			while (arc != null)
			{
				var tx = arc.node.val.x * scale + offset;
				var ty = arc.node.val.y * scale + offset;
				g.lineStyle(2, 0x44AA00);
				g.moveTo(x, y);
				g.lineTo(tx, ty);
				
				arc = arc.next;
			}
		}
		
		for (tile in map)
		{
			var x = tile.val.x * scale + offset;
			var y = tile.val.y * scale + offset;
			
			g.lineStyle(2, 0x44AA00);
			g.beginFill(0x000000);
			g.drawCircle(x, y, 5);
			g.endFill();
		}
	}
	
	public function drawPath(slate:Sprite, path:DA<AStarWaypoint>)
	{
		var scale = 32;
		var offset = scale / 2;
		
		var g:Graphics = slate.graphics;
		g.clear();
		
		var previousWaypoint:AStarWaypoint = null;
		
		for (waypoint in path)
		{
			var x = waypoint.x * scale + offset;
			var y = waypoint.y * scale + offset;
			
			if (previousWaypoint != null)
			{
				var tx = previousWaypoint.x * scale + offset;
				var ty = previousWaypoint.y * scale + offset;
				g.lineStyle(2, 0x4499FF);
				g.moveTo(x, y);
				g.lineTo(tx, ty);
			}
			
			g.lineStyle(2, 0xFFFFFF);
			g.beginFill(0x4499FF);
			g.drawCircle(x, y, 5);
			g.endFill();
			
			previousWaypoint = waypoint;
		}
	}
	
	public function report():Void
	{
		trace("Rooms: " + rooms);
		trace("Corridors: " + corridors);
		trace("Nodes: " + nodes);
		trace("Arcs: " + arcs);
	}
	
}