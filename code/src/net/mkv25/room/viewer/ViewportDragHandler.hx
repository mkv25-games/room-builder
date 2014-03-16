package net.mkv25.room.viewer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

class ViewportDragHandler
{
	var stage:Stage;
	var blitter:Blitter;

	var dragX:Float = -1;
	var dragY:Float = -1;
	var mouseDown:Bool = false;
	
	public function new(stage:Stage, blitter:Blitter) 
	{
		this.stage = stage;
		this.blitter = blitter;
		
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
		dragX = blitter.viewx - stage.mouseX;
		dragY = blitter.viewy - stage.mouseY;
	}
	
	function updateDrag(e)
	{
		blitter.viewx = Std.int(dragX + stage.mouseX);
		blitter.viewy = Std.int(dragY + stage.mouseY);
		
		blitter.clear();
		blitter.redraw();
	}

	function endDrag(e)
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateDrag);
		stage.removeEventListener(MouseEvent.MOUSE_UP, endDrag);
		mouseDown = false;
	}
	
}