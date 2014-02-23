package net.mkv25.room.builder;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Timer;
import net.mkv25.room.viewer.MapDragHandler;
import net.mkv25.room.viewer.MapPathingHandler;
import net.mkv25.room.viewer.MapSlate;
import net.mkv25.room.viewer.MapViewer;
import openfl.Assets;

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	var viewer:MapViewer;
	var slate:MapSlate;
	var pathingHandler:MapPathingHandler;
	var dragHandler:MapDragHandler;
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		viewer = new MapViewer();
		viewer.baseColour = 0xFF000000;
		viewer.setup(40, 20);
		
		slate = new MapSlate(stage, viewer);
		viewer.generateNewFloorplan();
		viewer.generatePathing();
		
		pathingHandler = new MapPathingHandler(stage, slate.getContainer(), viewer);
		dragHandler = new MapDragHandler(stage, slate.getContainer());
	}
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
		
		if (slate != null)
		{
			slate.resize();
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
