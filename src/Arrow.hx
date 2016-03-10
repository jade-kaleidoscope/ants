package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Arrow extends Building
{
	//This goes on the board and changes the direction of all minions that touch it.
	var direction: Int;
	
	public function new(grid: Grid, column: Int, row: Int, direction: Int)
	{
		super(grid, column, row);
		this.direction = direction;
		draw();
	}
	public static function picture(grid: Grid)
	{
		var image: Sprite;
		image = new Sprite();
		image.graphics.beginFill(0x00FF00);
		image.graphics.drawCircle(0, 0, grid.getCellSize() / 4);
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(0x00FF00);
		icon.graphics.drawCircle(grid.getCellSize() / 4, 0, grid.getCellSize() / 4);
		for (rotate in 0...direction)
		{
			icon.rotation += 90;
		}
		Lib.current.stage.addChildAt(icon, 5);
	}
	public function getDirection()
	{
		return direction;
	}
	public override function changeState()
	{
		direction = (direction + 2) % 4;
		icon.rotation += 180;
	}
	public override function activate(target: Minion)
	{
		target.changeDirection(direction);
	}
}