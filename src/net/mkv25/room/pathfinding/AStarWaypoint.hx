/*
 *                            _/                                                    _/
 *       _/_/_/      _/_/    _/  _/    _/    _/_/_/    _/_/    _/_/_/      _/_/_/  _/
 *      _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/
 *     _/    _/  _/    _/  _/  _/    _/  _/    _/  _/    _/  _/    _/  _/    _/  _/
 *    _/_/_/      _/_/    _/    _/_/_/    _/_/_/    _/_/    _/    _/    _/_/_/  _/
 *   _/                            _/        _/
 *  _/                        _/_/      _/_/
 *
 * POLYGONAL - A HAXE LIBRARY FOR GAME DEVELOPERS
 * Copyright (c) 2009 Michael Baczynski, http://www.polygonal.de
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
package net.mkv25.room.pathfinding;

import de.polygonal.ds.GraphNode;
import de.polygonal.ds.Heapable;

class AStarWaypoint implements Heapable<AStarWaypoint>
{
	/**
	 * Cartesian coordinates (by default z=0).
	 */
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	/** Heapable interface */
	public var position:Int;
	
	/**
	 * The total distance of all the edges that compromise the best path to this node so far.
	 */
	public var distance:Float;
	
	/**
	 * Heuristic estimate of the distance to the target to direct the search towards the target.
	 */
	public var heuristic:Float;
	
	/**
	 * True if this waypoint is contained in the queue.
	 */
	public var onQue:Bool;
	
	/**
	 * The graph node that holds this waypoint.
	 */
	public var node:GraphNode<AStarWaypoint>;
	
	/**
	 * A helpful colour for plotting purposes
	 */
	public var colour:Int;
	
	public function new()
	{
		x = 0;
		y = 0;
		z = 0;
		position = -1;
		distance = Math.NaN;
		heuristic = Math.NaN;
		onQue = false;
		node = null;
		colour = 0x000000;
	}
	
	inline public function reset():Void
	{
		distance = 0;
		heuristic = 0;
		onQue = false;
	}
	
	public function distanceTo(wp:AStarWaypoint):Float
	{
		var dx = wp.x - x;
		var dy = wp.y - y;
		var dz = wp.z - z;
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}
	
	public function compare(other:AStarWaypoint):Int
	{
		var x = other.heuristic - heuristic;
		return (x > 0.) ? 1 : (x < 0. ? -1 : 0);
	}
	
	public function toString():String
	{
		return Printf.format("{ AStarWaypoint x: %.2f, y: %.2f }", [x, y]);
	}
}