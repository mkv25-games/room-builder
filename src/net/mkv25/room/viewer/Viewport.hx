package net.mkv25.room.viewer;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

class Viewport
{
	var stage:Stage;
	var blitter:Blitter;
	var slate:Sprite;
	
	var pathingHandler:MapPathingHandler;
	
	public function new(stage:Stage, blitter:Blitter) 
	{
		this.stage = stage;
		this.blitter = blitter;
		
		slate = new Sprite();
		slate.addChild(blitter.artwork);
		
		stage.addChild(slate);
		
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	function onEnterFrame(e):Void
	{
		blitter.redraw();
	}
	
	public function resize()
	{
		blitter.resize(stage.stageWidth, stage.stageHeight);
	}
	
	public function getMouseX():Int
	{
		return Std.int(blitter.artwork.mouseX - blitter.viewx - blitter.centerx);
	}
	
	public function getMouseY():Int
	{
		return Std.int(blitter.artwork.mouseY - blitter.viewy - blitter.centery);
	}
}