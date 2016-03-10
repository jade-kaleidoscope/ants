package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Construction extends Building
{
	//Version one: A green square that highlights where you've placed an arrow, 
	//before there's an arrow there.
	var project: Blueprint;
	
	public function new(grid: Grid, project: Blueprint, column: Int, row: Int)
	{
		super(grid, column, row);
		this.project = project;
		if (project.getPlan() == "Arrow")
			this.color = 0x00FF00;
		else if (project.getPlan() == "Launcher")
			this.color = 0x0000DD;
		else if (project.getPlan() == "Tower")
			this.color = 0xFF4400;
		else if (project.getPlan() == "Switch")
			this.color = 0xDDDD99;
		else if (project.getPlan() == "Wall")
			this.color = 0xCC2222;
		else if (project.getPlan() == "Tunnel")
			this.color = 0xCCCCCC;
		else
			this.color = 0x000000;
		draw();
		if (project.getPlan() == "Tower" || project.getPlan() == "Switch" || project.getPlan() == "Wall") build(0); //no need to wait
	}
	override function draw()
	{
		icon.x = grid.xAt(column) + grid.getCellSize() / 2;
		icon.y = grid.yAt(row) + grid.getCellSize() / 2;
		icon.graphics.beginFill(color);
		icon.alpha = 0.5;
		icon.graphics.drawRect(-grid.getCellSize() / 2, -grid.getCellSize() / 2, grid.getCellSize(), grid.getCellSize());
		Lib.current.stage.addChild(icon);
	}
	public function moveTo(column: Int, row: Int)
	{
		this.column = column;
		this.row = row;
		die();
		draw();
	}
	public function build(direction: Int)
	{
		if (project.getPlan() == "Arrow")
			grid.spawnArrow(column, row, direction);
		else if (project.getPlan() == "Launcher")
			grid.spawnLauncher(column, row, direction);
		else if (project.getPlan() == "Tower")
			grid.spawnTower(column, row);
		else if (project.getPlan() == "Switch")
			grid.spawnSwitch(column, row);
		else if (project.getPlan() == "Wall")
			grid.spawnWall(column, row);
		else if (project.getPlan() == "Tunnel")
			grid.spawnTunnel(column, row, direction);
		grid.clearPointing();
		die();
	}
}