package net.mkv25.room.viewer;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

class MapPathingHandler
{
	var stage:Stage;
	var slate:Sprite;
	var viewer:MapViewer;
	
	var lastX:Int = -1;
	var lastY:Int = -1;
	
	public function new(stage:Stage, slate:Sprite, viewer:MapViewer) 
	{
		this.stage = stage;
		this.slate = slate;
		this.viewer = viewer;
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	function onMouseDown(e)
	{
		pathBetweenPoints();
	}
	
	function onKeyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == Keyboard.M && e.ctrlKey)
		{
			viewer.togglePathingInfo();
		}
	}
	
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
}