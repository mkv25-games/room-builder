package net.mkv25.room.viewer;

import flash.display.Sprite;
import flash.display.Stage;

class MapSlate
{
	var stage:Stage;
	var viewer:MapViewer;
	var slate:Sprite;
	
	var pathingHandler:MapPathingHandler;
	
	public function new(stage:Stage, viewer:MapViewer) 
	{
		this.stage = stage;
		this.viewer = viewer;
		
		slate = new Sprite();
		slate.addChild(viewer.grid);
		slate.addChild(viewer.pathgrid);
		slate.addChild(viewer.paths);
		
		stage.addChild(slate);
	}
	
	public function resize()
	{
		slate.x = stage.stageWidth / 2 - slate.width / 2;
		slate.y = stage.stageHeight / 2 - slate.height / 2;
	}
	
	public function getContainer():Sprite
	{
		return slate;
	}
}