package net.mkv25.room.viewer;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;

class Viewport
{
	var stage:Stage;
	
	public var artwork:Bitmap;
	public var slate:Sprite;
	public var baseColour:Int;
	
	public var centerx:Int;
	public var centery:Int;
	
	public var viewx:Int;
	public var viewy:Int;
	
	public var requestClear:Bool;
	
	var pathingHandler:MapPathingHandler;
	
	public function new(stage:Stage) 
	{
		this.stage = stage;
		
		artwork = new Bitmap();
		slate = new Sprite();
		baseColour = 0xFFAA5555;
		
		centerx = 0;
		centery = 0;
		
		viewx = 0;
		viewy = 0;
		
		requestClear = false;
		
		slate.addChild(artwork);
		stage.addChild(slate);
	}
	
	public function resize()
	{
		var width = stage.stageWidth;
		var height = stage.stageHeight;
		
		artwork.bitmapData = new BitmapData(width, height, false, baseColour);
		
		centerx = Std.int(width / 2);
		centery = Std.int(height / 2);
		
		trace("Resized Viewport");
	}
	
	public function clear():Void
	{
		artwork.bitmapData.fillRect(new Rectangle(0, 0, artwork.width, artwork.height), baseColour);
		
		requestClear = false;
	}
	
	public function getMouseX():Int
	{
		return Std.int(artwork.mouseX - viewx - centerx);
	}
	
	public function getMouseY():Int
	{
		return Std.int(artwork.mouseY - viewy - centery);
	}
}