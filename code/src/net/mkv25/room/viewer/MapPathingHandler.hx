package net.mkv25.room.viewer;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

class MapPathingHandler
{
	var stage:Stage;
	var viewport:Viewport;
	var pathgrid:PathGrid;
	
	var lastX:Int = -1;
	var lastY:Int = -1;
	
	var mouseX:Float = 0;
	var mouseY:Float = 0;
	
	public function new(stage:Stage, viewport:Viewport, pathgrid:PathGrid) 
	{
		this.stage = stage;
		this.viewport = viewport;
		this.pathgrid = pathgrid;
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	function onMouseDown(e)
	{
		recordMousePosition();
	}
	
	function onMouseUp(e)
	{
		if (mouseX == stage.mouseX && mouseY == stage.mouseY)
		{
			pathBetweenPoints();
		}
	}
	
	function onKeyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == Keyboard.M && e.ctrlKey)
		{
			pathgrid.togglePathingInfo();
		}
	}
	
	function recordMousePosition():Void
	{
		mouseX = stage.mouseX;
		mouseY = stage.mouseY;
	}
	
	function pathBetweenPoints():Void
	{
		var x:Int = Math.floor(viewport.getMouseX() / 32);
		var y:Int = Math.floor(viewport.getMouseY() / 32);
		
		trace("Tile: " + x + ", " + y);
		
		if (lastX != -1 && lastY != -1)
		{
			pathgrid.pathBetween(x, y, lastX, lastY);
			lastX = -1;
			lastY = -1;
		}
		else
		{
			lastX = x;
			lastY = y;
			pathgrid.pathBetween(x, y, lastX, lastY);
		}
	}
}