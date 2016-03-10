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

class Tunnel extends Building
{
	var direction: Int;
	
	public function new(grid: Grid, column: Int, row: Int, direction: Int)
	{
		super(grid, column, row);
		color = 0xCCCCCC;
		this.direction = direction;
		draw();
	}
	public static function picture(grid: Grid)
	{
		var image = new Sprite();
		image.graphics.beginFill(0xCCCCCC);
		image.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize() / 4);
		image.graphics.drawRect( -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize(), grid.getCellSize() / 4);
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize() / 4);
		icon.graphics.drawRect( -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize(), grid.getCellSize() / 4);
		for (rotate in 0...direction)
		{
			icon.rotation += 90;
		}
		Lib.current.stage.addChild(icon);
	}
	public override function changeState()
	{
		if (direction == 3)
		{
			direction = 0;
		}
		else
		{
			direction++;
		}
		icon.rotation += 90;
		if (grid.isMinionAt(column, row))
		{
			grid.minionAt(column, row).changeDirection(direction);
		}
	}
	public override function canEnter(minion: Minion)
	{
		if (direction % 2 == 0)
		{
			return minion.getRow() == row;
		}
		else
		{
			return minion.getColumn() == column;
		}
	}
}