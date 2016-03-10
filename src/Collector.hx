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

class Collector extends Building
{
	var direction: Int;
	
	public function new(grid: Grid, row: Int, column: Int, direction: Int)
	{
		super(grid, column, row);
		color = 0x0000DD;
		this.direction = direction;
		draw();
	}
	public static function picture(grid: Grid)
	{
		var image = new Sprite();
		image.graphics.beginFill(0x0000DD);
		image.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize() / 4);	
		image.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize());
		image.graphics.drawRect( -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize(), grid.getCellSize() / 4);
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize() / 4);	
		icon.graphics.drawRect( -grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize());
		icon.graphics.drawRect( -grid.getCellSize() / 2, grid.getCellSize() / 4, grid.getCellSize(), grid.getCellSize() / 4);
		for (angle in 0...direction)
		{
			icon.rotation += 90;
		}
		Lib.current.stage.addChild(icon);
	}
	public function buffSpawnTime()
	{
		if (startingTimer > 1)
		{
			startingTimer--;
		}
	}
	public function buffStartingSpeed()
	{
		//startingSpeed = grid.getCellSize() / (startingTimer / 2);
		startingSpeed+= grid.getCellSize() / 30;
	}
	public override function changeState()
	{
		direction += 1;
		if (direction > 3) direction = 0;
		icon.
	}
	public override function activate(minion: Minion)
	{
		if (minion.hasEquipment())
		{
			minion.buff(this);
		}
	}
}