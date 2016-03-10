package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.remoting.FlashJsConnection;

/**
 * ...
 * @author Josh Eklund
 */

class Building
{
	//superclass for all buildings
	var grid: Grid;
	var icon: Sprite;
	var row: Int;
	var column: Int;
	var color: Int;
	
	public function new(grid: Grid, column: Int, row: Int)
	{
		this.grid = grid;
		this.column = column;
		this.row = row;
		this.color = 0xFFFFFF;
		icon = new Sprite();
		draw();
		grid.placeBuilding(column, row, this);
	}
	public function draw()
	{
		return;
	}
	public function update()
	{
		return;
	}
	public function changeState()
	{
		return;
	}
	public function activate(minion: Minion)
	{
		return;
	}
	public function stepOn(minion: Minion)
	{
		return;
	}
	public function stepOff(minion: Minion)
	{
		return;
	}
	public function onSelect()
	{
		grid.buildIfBuilding(column, row);
		return;
	}
	//can this minion occupy the same space as this building?
	public function canEnter(minion: Minion)
	{
		return true;
	}
	public static function picture(grid: Grid)
	{
		var image:Sprite;
		image = new Sprite();
		image.graphics.beginFill(0xFFFFFF);
		image.graphics.drawRect(0, 0, grid.getCellSize(), grid.getCellSize());
		return image;
	}
	public function getRow()
	{
		return row;
	}
	public function getColumn()
	{
		return column;
	}
	function die()
	{
		Lib.current.stage.removeChild(icon);
	}
}