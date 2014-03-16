package net.mkv25.room.builder;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;
import net.mkv25.room.pathfinding.PathFinder;
import net.mkv25.room.viewer.Blitter;
import net.mkv25.room.viewer.PathGrid;
import net.mkv25.room.viewer.ViewportDragHandler;
import net.mkv25.room.viewer.MapPathingHandler;
import net.mkv25.room.viewer.Viewport;
import net.mkv25.room.viewer.MapBlitter;
import openfl.Assets;

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	var viewport:Viewport;
	var blitter:Blitter;
	var map:MapBlitter;
	var pathfinder:PathFinder;
	var pathgrid:PathGrid;
	
	var pathingHandler:MapPathingHandler;
	var dragHandler:ViewportDragHandler;
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		// disable traces
		#if !debug
		Log.trace = nullTrace;
		#end
		
		// create blitter and viewport
		viewport = new Viewport(stage);
		blitter = new Blitter(viewport);
		
		// create map
		map = new MapBlitter();
		map.baseColour = 0xFF000000;
		map.setup(40, 20);
		blitter.add(map);
		
		// create path finding
		pathfinder = new PathFinder();
		pathgrid = new PathGrid(pathfinder);
		pathgrid.setup(40, 20);
		blitter.add(pathgrid);
		
		// do stuff with map
		map.generateNewFloorplan();
		pathgrid.generatePathing(map.floorplan);
		
		// create handler
		pathingHandler = new MapPathingHandler(stage, viewport, pathgrid);
		dragHandler = new ViewportDragHandler(stage, viewport);
	}
	
	function nullTrace(v:Dynamic, ?inf:PosInfos)
	{
		// no trace
	}
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
		
		viewport.resize();
	}
	
	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
		addEventListener(Event.ENTER_FRAME, enterFrame);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	function enterFrame(e)
	{
		blitter.redraw();
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
