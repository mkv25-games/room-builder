package net.mkv25.room.builder;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import openfl.Assets;

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	var viewer:MapViewer;
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		viewer = new MapViewer();
		viewer.setup(40, 20);
		addChild(viewer.grid);
		addChild(viewer.pathgrid);
		addChild(viewer.paths);
		
		for (i in 0...6)
		{
			viewer.cycleRoomSamples();
		}
		
		viewer.generatePathing();
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	var lastX:Int = -1;
	var lastY:Int = -1;
	function onMouseDown(e)
	{
		var x:Int = Math.floor(stage.mouseX / 32);
		var y:Int = Math.floor(stage.mouseY / 32);
		
		trace("Tile: " + x + ", " + y);
		
		if (lastX != -1 && lastY != -1)
		{
			viewer.pathBetween(x, y, lastX, lastY);
			lastX = -1;
			lastY = -1;
		}
		else
		{
			lastX = x;
			lastY = y;
			viewer.pathBetween(x, y, lastX, lastY);
		}
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
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
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
