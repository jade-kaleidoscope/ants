package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Switch extends Building
{
	/*
	 * Switches have the following features:

Can be placed on the board
Move from On to Off when pressed by a minion
Can be connected to any one game object
If it's set to Off, towers stop firing, launchers stop launching, arrows point the opposite direction
Shaped like a blue-green-gray triangle
Changes color when flipped

	 */
	var isOn: Bool;
	var target: Building;
	var lastTrigger: Minion;
	var wire: Sprite;
	
	public function new(grid: Grid, column: Int, row: Int)
	{
		super(grid, column, row);
		color = 0xFFFF44;
		isOn = true;
		draw();
		wire = new Sprite();
		wire.x = grid.xAt(column) + grid.getCellSize() / 2;
		wire.y = grid.yAt(row) + grid.getCellSize() / 2;
	}
	public function acquireTarget(target: Building)
	{
		this.target = target;
		var x = wire.x;
		var y = wire.y;
		wire.graphics.clear();
		wire.graphics.moveTo(0, 0);
		wire.graphics.lineStyle(1, 0x00FF00, 1, false);
		wire.graphics.lineTo(grid.xAt(target.getColumn()) + grid.getCellSize() / 2 - x, grid.yAt(target.getRow()) + grid.getCellSize() / 2 - y);
		Lib.current.stage.addChild(wire);
	}
	public static function picture(grid: Grid)
	{
		var image: Sprite;
		image = new Sprite();
		image.graphics.beginFill(0xFFFF44);
		image.graphics.drawRect( -grid.getCellSize() / 6, -3 * grid.getCellSize() / 7, grid.getCellSize() / 3, 2 * grid.getCellSize() / 5);
		return image;
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect( -grid.getCellSize() / 6, -3 * grid.getCellSize() / 7, grid.getCellSize() / 3, 2 * grid.getCellSize() / 5);
		Lib.current.stage.addChild(icon);
	}
	public override function update()
	{
		return;
	}
	public override function onSelect()
	{
		grid.activateSwitch(this);
	}
	public function targetAcquired()
	{
		return target != null;
	}
	function flip()
	{
		if (targetAcquired())
			target.changeState();
		isOn = !isOn;
		icon.rotation += 180;
	}
	public override function changeState()
	{
		flip();
	}
	public override function activate(minion: Minion)
	{
		if (okayToFlip(minion)) 
		{
			flip();
			lastTrigger = minion;
		}
	}
	function okayToFlip(minion: Minion)
	{
		if (lastTrigger == null) return true;
		if (lastTrigger == minion) return false;
		return true;
	}
}