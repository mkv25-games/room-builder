package net.mkv25.room.builder;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.Timer;
import net.mkv25.room.viewer.MapViewer;
import openfl.Assets;

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
		
		if (slate != null)
		{
			slate.x = stage.stageWidth / 2 - slate.width / 2;
			slate.y = stage.stageHeight / 2 - slate.height / 2;
		}
	}
	
	var viewer:MapViewer;
	var slate:Sprite;
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		viewer = new MapViewer();
		viewer.setup(40, 20);
		
		slate = new Sprite();
		slate.addChild(viewer.grid);
		slate.addChild(viewer.pathgrid);
		slate.addChild(viewer.paths);
		
		addChild(slate);
		
		for (i in 0...6)
		{
			viewer.cycleRoomSamples();
		}
		
		viewer.generatePathing();
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	function onMouseDown(e)
	{
		pathBetweenPoints();
		beginDrag();	
	}
	
	function onKeyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == Keyboard.M && e.ctrlKey)
		{
			viewer.togglePathingInfo();
		}
	}
	
	var lastX:Int = -1;
	var lastY:Int = -1;
	function pathBetweenPoints():Void
	{
		var x:Int = Math.floor(slate.mouseX / 32);
		var y:Int = Math.floor(slate.mouseY / 32);
		
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
	
	var dragX:Float = -1;
	var dragY:Float = -1;
	var mouseDown:Bool = false;
	function beginDrag():Void
	{
		mouseDown = true;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, updateDrag);
		stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
		dragX = slate.x - stage.mouseX;
		dragY = slate.y - stage.mouseY;
	}
	
	function updateDrag(e)
	{
		slate.x = dragX + stage.mouseX;
		slate.y = dragY + stage.mouseY;
	}

	function endDrag(e)
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDrag);
		stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
		mouseDown = false;
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
