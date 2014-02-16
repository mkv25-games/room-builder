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
import de.polygonal.ds.HashMap;

class PathFinder
{
	private var graph:Graph<AStarWaypoint>;
	private var map:HashMap < String, GraphNode<AStarWaypoint> > ;
	
	private var astar:AStar;
	
	var rooms:Int = 0;
	var nodes:Int = 0;
	var arcs:Int = 0;
	
	public function new() 
	{
		graph = new Graph<AStarWaypoint>();
		map = new HashMap < String, GraphNode<AStarWaypoint> > ();
		astar = new AStar(graph);
	}
	
	public function clear():Void
	{
		graph.clear();
		map.clear();
		
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
		astar.find(graph, source.val, target.val, path);
		
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
	
	private function mapTile(tilex:Int, tiley:Int):Void
	{
		var waypoint = new AStarWaypoint();
		waypoint.x = tilex;
		waypoint.y = tiley;
		waypoint.z = 0;
		
		var node = new GraphNode<AStarWaypoint>(graph, waypoint);
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
		
		// arc NESW
		arcNodes(node, tilex, tiley - 1);
		arcNodes(node, tilex + 1, tiley);
		arcNodes(node, tilex, tiley + 1);
		arcNodes(node, tilex - 1, tiley);
		
		arcNodes(node, tilex + 1, tiley - 1);
		arcNodes(node, tilex + 1, tiley + 1);
		arcNodes(node, tilex - 1, tiley + 1);
		arcNodes(node, tilex - 1, tiley - 1);
	}
	
	private function getTileNode(tilex:Int, tiley:Int):GraphNode<AStarWaypoint>
	{
		var key = tilex + "," + tiley; 
		return map.get(key);
	}
	
	private inline function arcNodes(tile:GraphNode<AStarWaypoint>, targetx:Int, targety:Int):Void
	{
		var target = getTileNode(targetx, targety);
		if (target != null)
		{
			graph.addSingleArc(tile, target);
			arcs++;
		}
	}
	
	public function draw(slate:Sprite):Void
	{
		var scale = 32;
		var offset = scale / 2;
		
		var g:Graphics = slate.graphics;
		g.clear();
		
		for (tile in map)
		{
			g.beginFill(0xFF0000);
			g.drawCircle(tile.val.x * scale + offset, tile.val.y * scale + offset, 5);
			g.endFill();
		}
	}
	
	public function report():Void
	{
		trace("Rooms: " + rooms);
		trace("Nodes: " + nodes);
		trace("Arcs: " + arcs);
	}
	
}