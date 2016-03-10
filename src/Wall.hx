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

class Wall extends Building
{
	var solid: Bool;
	
	public function new(grid: Grid, column: Int, row: Int)
	{
		super(grid, column, row);
		color = 0xCC2222;
		draw();
		solid = true;
	}
	public static function picture(grid: Grid)
	{
		var image = new Sprite();
		image.graphics.beginFill(0xCC2222);
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
	public override function changeState()
	{
		if (solid)
		{
			icon.alpha = 0.5;
		}
		else
		{
			icon.alpha = 1;
		}
		solid = !solid;
	}
	public override function canEnter(minion: Minion)
	{
		return !solid;
	}
}