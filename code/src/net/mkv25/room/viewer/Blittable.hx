package net.mkv25.room.viewer;

import flash.display.Bitmap;
import flash.display.DisplayObject;

interface Blittable
{
	public var artwork:Bitmap;
	public var frame:Int;
	public var layer:Int;
	public var dirty:Bool;
	
	public function redraw():Void;
}