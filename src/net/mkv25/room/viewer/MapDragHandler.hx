package net.mkv25.room.viewer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

class MapDragHandler
{
	var stage:Stage;
	var slate:Sprite;

	var dragX:Float = -1;
	var dragY:Float = -1;
	var mouseDown:Bool = false;
	
	public function new(stage:Stage, slate:Sprite) 
	{
		this.stage = stage;
		this.slate = slate;
		
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
	
}