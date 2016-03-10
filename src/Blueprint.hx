package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.remoting.FlashJsConnection;

/**
 * ...
 * @author Josh Eklund
 */

class Blueprint
{
	//A button
	var plan: String; //What to build next, e.g. "Arrow" or "Launcher"
	var grid: Grid;
	var icon: Sprite;
	var image: Sprite;
	var color: Int;
	var selected: Bool;
	var x: Float;
	var y: Float;
	
	public function new(grid: Grid, x: Float, y: Float, plan: String, image: Sprite)
	{
		this.grid = grid;
		this.x = x;
		this.y = y;
		this.plan = plan;
		this.image = image;
		this.color = 0xFFDDAA;
		icon = new Sprite();
		selected = false;
		draw();
	}
	function draw()
	{
		var size = grid.getCellSize() * 2;
		image.x = x + size / 2;
		image.y = y + size / 2;
		icon.x = x;
		icon.y = y;
		icon.graphics.beginFill(color);
		icon.graphics.drawRect(0, 0, size, size);
		Lib.current.stage.addChild(icon);
		Lib.current.stage.addChild(image);
		icon.buttonMode = true;
		icon.addEventListener(MouseEvent.MOUSE_DOWN, select);
	}
	function select(event: MouseEvent)
	{
		chooseMe();
	}
	public function getPlan()
	{
		return plan;
	}
	public function chooseMe()
	{
		if (!selected)
		{
			icon.alpha = .5;
			grid.setNextBuilding(this);
		}
		else
		{
			icon.alpha = 1;
			grid.setNextBuilding(null);
		}
		selected = !selected;
	}
	public function deselect()
	{
		icon.alpha = 1;
		selected = false;
	}
	public function build(column: Int, row: Int)
	{
		return new Construction(grid, this, column, row);
	}
}