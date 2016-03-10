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

class Launcher extends Building
{
	var direction: Int;
	var startingSpeed: Float;
	var timer: Int;
	var startingTimer: Int;
	var launching: Bool;
	
	public function new(grid: Grid, row: Int, column: Int, direction: Int)
	{
		super(grid, column, row);
		launching = true;
		color = 0x0000DD;
		this.direction = direction;
		draw();
		startingTimer = 30; //in frames (30 fps)
		startingSpeed = grid.getCellSize() / (startingTimer / 2);
		timer = startingTimer;
	}
	public static function picture(grid: Grid)
	{
		var image = new Sprite();
		image.graphics.beginFill(0x0000DD);
		image.graphics.drawRect(0, -grid.getCellSize() / 2, grid.getCellSize() / 2, grid.getCellSize());	
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect(0, -grid.getCellSize() / 2, grid.getCellSize() / 2, grid.getCellSize());
		for (angle in 0...direction)
		{
			icon.rotation += 90;
		}
		Lib.current.stage.addChild(icon);
	}
	function launch()
	{
		grid.spawnMinion(row, column, startingSpeed, direction);
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
	public override function update()
	{
		if (!launching) return;
		timer--;
		if (timer == 0)
		{
			timer = startingTimer;
			launch();
		}
	}
	public override function changeState()
	{
		launching = !launching;
	}
	public override function activate(minion: Minion)
	{
		if (minion.hasEquipment())
		{
			minion.buff(this);
		}
	}
}