package ;

import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Tower extends Building
{
	var range: Float;
	var timer: Int;
	var shooting: Bool;
	var startingTimer: Int;
	
	public function new(grid: Grid, column: Int, row: Int)
	{
		super(grid, column, row);
		shooting = true;
		color = 0xFF4400;
		range = 5 * grid.getCellSize();
		draw();
		startingTimer = 45; //in frames (30 fps)
		timer = startingTimer;
	}
	public static function picture(grid: Grid)
	{
		var image = new Sprite();
		image.graphics.beginFill(0xFF4400);
		image.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize());
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect(-grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize());
		Lib.current.stage.addChild(icon);
	}
	function fire()
	{
		grid.findTargetWithinRange(icon.x, icon.y, this);
	}
	public function getRange()
	{
		return range;
	}
	public override function update()
	{
		if (!shooting) return;
		timer--;
		if (timer == 0)
		{
			timer = startingTimer;
			fire();
		}
	}
	public override function changeState()
	{
		shooting = !shooting;
		if (shooting) icon.alpha = 1;
		else icon.alpha = 0.5;
	}
	public override function canEnter(minion: Minion)
	{
		return false;
	}
}