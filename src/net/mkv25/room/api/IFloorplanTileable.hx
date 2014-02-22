package net.mkv25.room.api;

import net.mkv25.room.planner.FloorplanMap;

interface IFloorplanTileable
{
	public function mapTo(map:FloorplanMap):Void;
}