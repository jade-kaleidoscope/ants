package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Loot
{
	//Can be picked up by minions and delivered to the Launcher for points.
	var grid: Grid;
	var row: Int;
	var column: Int;
	var icon: Sprite;
	
	var size: Float;
	
	public function new(grid: Grid, column: Int, row: Int)
	{
		this.grid = grid;
		this.row = row;
		this.column = column;
		size = grid.getCellSize() / 4;
		icon = new Sprite();
		draw();
	}
	function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(0xFFFF00);
		icon.graphics.drawRect( -size / 2, -size / 2, size, size);
		Lib.current.stage.addChild(icon);
		
	}
	public function update()
	{
		return;
	}
	public function activate(target: Minion)
	{
		target.pickUp(this);
	}
	public function die()
	{
		grid.destroyed(this);
		Lib.current.stage.removeChild(icon);
	}
	public function comeAlong(x: Float, y: Float)
	{
		icon.x = x;
		icon.y = y;
		column = grid.columnAt(x);
		row = grid.rowAt(y);
	}
	public function getIcon()
	{
		return icon;
	}
	public function getRow()
	{
		return row;
	}
	public function getColumn()
	{
		return column;
	}
}