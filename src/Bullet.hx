package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Bullet
{
	var grid: Grid;
	var icon: Sprite;
	
	var speed: Float;
	var target: Minion;
	var size: Float;
	
	public function new(grid: Grid, x: Float, y: Float, target: Minion)
	{
		this.grid = grid;
		
		size = grid.getCellSize() / 8;
		icon = new Sprite();
		icon.x = x;
		icon.y = y;
		this.target = target;
		speed = grid.getCellSize() / 4;
		draw();
	}
	public function draw()
	{
		icon.graphics.beginFill(0xAAAA55);
		icon.graphics.drawCircle(0, 0, size);
		Lib.current.stage.addChild(icon);
	}
	public function update()
	{
		var x = icon.x;
		var y = icon.y;
		var distance = Math.sqrt(Math.pow(target.getX() - x, 2) + Math.pow(target.getY() - y, 2));
		if (distance < grid.getCellSize() / 4)
		{
			target.die();
			grid.expire(this);
			Lib.current.stage.removeChild(icon);
			return;
		}
		var dy = target.getY() - y;
		var dx = target.getX() - x;
		if (dx == 0)
		{
			if (dy > 0)
			{
				y += speed;
			}
			else
			{
				y -= speed;
			}
			return;
		}
		var angle = Math.atan2(dy, dx);
		y += speed * Math.sin(angle);
		x += speed * Math.cos(angle);
		icon.x = x;
		icon.y = y;
	}
	
}