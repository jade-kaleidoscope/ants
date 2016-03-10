package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Minion
{
	var grid: Grid;
	var row: Int;
	var column: Int;
	var size: Float;
	var icon: Sprite;
	
	var speed: Float;
	var direction: Int;
	
	var desiredRow: Int;
	var desiredColumn: Int;
	var waiting: Bool;
	
	var equipment: List<Loot>;
	
	public function new(grid: Grid, row: Int, column: Int, speed: Float, direction: Int)
	{
		this.grid = grid;
		this.row = row;
		this.column = column;
		size = grid.getCellSize();
		icon = new Sprite();
		this.speed = speed;
		this.direction = direction;
		waiting = false;
		draw();
		equipment = new List<Loot>();
		pickDestination();
	}
	public function getSpeed()
	{
		return speed;
	}
	public function getDirection()
	{
		return direction;
	}
	public function getX()
	{
		return icon.x + size / 2;
	}
	public function getY()
	{
		return icon.y + size / 2;
	}
	public function getRow()
	{
		return row;
	}
	public function getColumn()
	{
		return column;
	}
	public function draw()
	{
		icon.x = grid.xAt(column);
		icon.y = grid.yAt(row);
		icon.graphics.beginFill(0xFF0000);
		icon.graphics.drawCircle(size / 2, size / 2, size / 2); 
		Lib.current.stage.addChild(icon);
	}
	public function die()
	{
		if (icon.alpha == 1)
		{
			dropEverything();
			grid.takeMinionOut(desiredColumn, desiredRow);
			icon.alpha = 0.01;
			grid.kill(this);
		}
	}
	function pickDestination()
	{
		desiredRow = row;
		desiredColumn = column;
		switch (direction)
		{
			case 0: desiredColumn += 1;
			case 1: desiredRow += 1;
			case 2: desiredColumn -= 1;
			case 3: desiredRow -= 1;
		}
		if (grid.outOfBounds(grid.xAt(desiredColumn), grid.yAt(desiredRow)))
		{
			changeDirectionRandomly();
			pickDestination();
			return;
		}
		if (!grid.canEnter(desiredColumn, desiredRow, this)) wait();
		grid.putMinionIn(desiredColumn, desiredRow, this);
	}
	public function pickUp(item: Loot)
	{
		equipment.push(item);
		grid.claimed(item);
		Lib.current.stage.setChildIndex(icon, Lib.current.stage.getChildIndex(item.getIcon()) - 1);
	}
	function wait()
	{
		desiredColumn = column;
		desiredRow = row;
	}
	function approachDestination()
	{
		
		var areWeThereYet = false;
		var dx = grid.xAt(desiredColumn) - icon.x;
		if (Math.abs(dx) < speed)
		{
			icon.x = grid.xAt(desiredColumn);
			areWeThereYet = true;
		}
		else if (dx < 0)
		{
			icon.x -= speed;
		}
		else
		{
			icon.x += speed;
		}
		var dy = grid.yAt(desiredRow) - icon.y;
		if (Math.abs(dy) < speed)
		{
			icon.y = grid.yAt(desiredRow);
		}
		else if (dy < 0)
		{
			icon.y -= speed;
			areWeThereYet = false;
		}
		else
		{
			icon.y += speed;
			areWeThereYet = false;
		}
		if (areWeThereYet)
		{
			row = desiredRow;
			column = desiredColumn;
			grid.takeMinionOut(column, row);
			grid.trigger(column, row, this);
			pickDestination();
		}
	}
	public function update()
	{
		approachDestination();
		for (item in equipment)
		{
			carry(item);
		}
	}
	function carry(item: Loot)
	{
		item.comeAlong(icon.x + size / 2, icon.y + size / 2);
	}
	function dropEverything()
	{
		for (item in equipment)
		{
			grid.dropped(item);
			equipment.remove(item);
		}
	}
	public function hasEquipment()
	{
		return equipment.length > 0;
	}
	public function buff(launcher: Launcher)
	{
		for (item in equipment)
		{
			equipment.remove(item);
			item.die();
			launcher.buffStartingSpeed();
			launcher.buffSpawnTime();
		}
		grid.reduceTimeToNextTower();
	}
	public function changeDirection(newDirection: Int)
	{
		direction = newDirection;
	}
	function changeDirectionRandomly()
	{
		direction = Std.random(4);
	}
	
}