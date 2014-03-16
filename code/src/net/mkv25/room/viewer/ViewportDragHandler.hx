package net.mkv25.room.viewer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

class ViewportDragHandler
{
	var stage:Stage;
	var viewport:Viewport;

	var dragX:Float = -1;
	var dragY:Float = -1;
	var mouseDown:Bool = false;
	
	public function new(stage:Stage, viewport:Viewport) 
	{
		this.stage = stage;
		this.viewport = viewport;
		
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	function onMouseDown(e)
	{
		beginDrag();	
	}
	
	function beginDrag():Void
	{
		mouseDown = true;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, updateDrag);
		stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
		dragX = viewport.viewx - stage.mouseX;
		dragY = viewport.viewy - stage.mouseY;
	}
	
	function updateDrag(e)
	{
		viewport.viewx = Std.int(dragX + stage.mouseX);
		viewport.viewy = Std.int(dragY + stage.mouseY);
		
		viewport.requestClear = true;
	}

	function endDrag(e)
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDrag);
		stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
		mouseDown = false;
	}
	
}