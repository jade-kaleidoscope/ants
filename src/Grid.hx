package ;

import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.Lib;

/**
 * ...
 * @author Josh Eklund
 */

class Grid
{
	var rows: Int;
	var columns: Int;
	var backgroundColor: Int;
	var lineColor: Int;
	var icon: Sprite;
	var xOffset: Float;
	var yOffset: Float;
	var height: Float;
	var width: Float;
	var cellSize: Float;
	
	var population: List<Minion>;
	
	var buildings: List<Building>;
	var ordinance: List<Bullet>;
	var treasure: List<Loot>;
	var blueprints: List<Blueprint>;
	
	var minionLocations: Array<Array<Minion>>;
	var buildingLocations: Array<Array<Building>>;
	
	var pointing: Bool;
	var nextBuilding: Blueprint;
	var workInProgress: Construction;
	
	var activeSwitch: Switch;
	var switchSelect: Sprite;
	
	var populationLimit: Int;
	
	var nextTower: Int;
	var betweenTowers: Int;
	
	public function new(rows: Int, columns: Int)
	{
		backgroundColor = 0x000000;
		lineColor = 0x454500;
		this.rows = rows;
		this.columns = columns;
		icon = new Sprite();
		switchSelect = new Sprite();
		population = new List<Minion>();
		buildings = new List<Building>();
		ordinance = new List<Bullet>();
		treasure = new List<Loot>();
		blueprints = new List<Blueprint>();
		buildingLocations = new Array<Array<Building>>();
		minionLocations = new Array<Array<Minion>>();
		draw();
		populationLimit = 200;
		initializeBlueprints();
		var initialNumberOfTowers:Int = Math.floor(rows / 10) + 1;
		for (foo in 0...initialNumberOfTowers)
		{
			buildings.push(new Tower(this, Std.random(rows), Std.random(columns)));
		}
		//towers.push(new Tower(this, Std.random(rows), Std.random(columns)));
		
		treasure.push(new Loot(this, Std.random(rows), Std.random(columns)));
		betweenTowers = 4;
		nextTower = betweenTowers;
		pointing = false;
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, select);
	}
	
	function initializeBlueprints()
	{
		var x = getCellSize() * 0.5;
		var y = getCellSize() * 0.5;
		blueprints.push(new Blueprint(this, x, y, "Launcher", Launcher.picture(this)));
		y += getCellSize() * 2.5;
		blueprints.push(new Blueprint(this, x, y, "Tower", Tower.picture(this)));
		y += getCellSize() * 2.5;
		blueprints.push(new Blueprint(this, x, y, "Arrow", Arrow.picture(this)));
		y += getCellSize() * 2.5;
		blueprints.push(new Blueprint(this, x, y, "Switch", Switch.picture(this)));
		y += getCellSize() * 2.5;
		blueprints.push(new Blueprint(this, x, y, "Wall", Wall.picture(this)));
		y += getCellSize() * 2.5;
		blueprints.push(new Blueprint(this, x, y, "Tunnel", Tunnel.picture(this)));
		//firstPlan.chooseMe();
	}
	
	
	public function claimed(item: Loot)
	{
		treasure.remove(item);
	}
	public function dropped(item: Loot)
	{
		treasure.push(item);
	}
	
	public function putMinionIn(column: Int, row: Int, minion: Minion)
	{
		if (minionLocations[column] == null)
			minionLocations[column] = new Array<Minion>();
		minionLocations[column][row] = minion;
	}
	public function takeMinionOut(column: Int, row: Int)
	{
		if (!isMinionAt(column, row)) return;
		if (minionLocations[column] == null) minionLocations[column] = new Array<Minion>();
		minionLocations[column][row] = null;
	}
	public function isMinionAt(column: Int, row: Int)
	{
		if (minionLocations[column] == null)
			return false;
		if (minionLocations[column][row] == null)
			return false;
		return true;
	}
	public function minionAt(column: Int, row: Int)
	{
		if (minionLocations[column] == null) return null;
		return minionLocations[column][row];
	}
	public function placeBuilding(column: Int, row: Int, building: Building)
	{
		if (buildingLocations[column] == null)
			buildingLocations[column] = new Array<Building>();
		buildingLocations[column][row] = building;
	}
	public function demolishBuilding(column: Int, row: Int)
	{
		buildingLocations[column][row] = null;
	}
	public function isBuildingAt(column: Int, row: Int)
	{
		if (buildingLocations[column] == null) return false;
		if (buildingLocations[column][row] == null) return false;
		return true;
	}
	public function canEnter(column: Int, row: Int, minion: Minion)
	{
		if (isMinionAt(column, row)) return false;
		if (!isBuildingAt(column, row)) return true;
		return buildingLocations[column][row].canEnter(minion);
	}
	
	public function trigger(column: Int, row: Int, minion: Minion)
	{
		if (isBuildingAt(column, row)) buildingLocations[column][row].activate(minion);
		for (loot in treasure)
		{
			if (loot.getRow() == row)
				if (loot.getColumn() == column)
				{
					loot.activate(minion);
				}
		}
	}
	
	public function reduceTimeToNextTower()
	{
		nextTower--;
		if (nextTower == 0)
		{
			nextTower = betweenTowers;
			spawnTower(Std.random(columns), Std.random(rows));
		}
	}
	
	public function destroyed(item: Loot)
	{
		treasure.remove(item);
		spawnLoot();
	}
	
	function spawnLoot()
	{
		var column = Std.random(columns);
		var row = Std.random(rows);
		while (isBuildingAt(column, row))
		{
			column = Std.random(columns);
			row = Std.random(rows);
		}
		treasure.push(new Loot(this, column, row));
	}
	
	public function spawnTower(column: Int, row: Int)
	{
		buildings.push(new Tower(this, column, row));
	}
	
	public function spawnSwitch(column: Int, row: Int)
	{
		buildings.push(new Switch(this, column, row));
	}
	public function spawnWall(column: Int, row: Int)
	{
		buildings.push(new Wall(this, column, row));
	}
	public function spawnTunnel(column: Int, row: Int, direction: Int)
	{
		buildings.push(new Tunnel(this, column, row, direction));
	}
	
	public function findTargetWithinRange(x: Float, y: Float, tower: Tower)
	{
		var distance = 0.0;
		var minimumDistance = 100000.0;
		var nearestMinion = population.first();
		for (minion in population)
		{
			distance = Math.sqrt(Math.pow(minion.getX() - x, 2) + Math.pow(minion.getY() - y, 2));
			if (distance < tower.getRange())
			{
				if (distance < minimumDistance)
				{
					minimumDistance = distance;
					nearestMinion = minion;
				}
			}
		}
		if (minimumDistance < 100000.0)
		{
			spawnBullet(x, y, nearestMinion);
		}
	}
	
	function spawnBullet(x: Float, y: Float, target: Minion)
	{
		ordinance.push(new Bullet(this, x, y, target));
	}
	public function kill(target: Minion)
	{
		population.remove(target);
	}
	public function expire(bullet: Bullet)
	{
		ordinance.remove(bullet);
	}
	public function construct(plan: Blueprint, column: Int, row: Int)
	{
		if (plan == null) return;
		pointing = true;
		workInProgress = plan.build(column, row);
	}
	public function setNextBuilding(plan: Blueprint)
	{
		nextBuilding = plan;
		for (blueprint in blueprints)
		{
			if (blueprint != plan)
			{
				blueprint.deselect();
			}
		}
	}
	public function buildIfBuilding(column: Int, row: Int)
	{
		if (pointing)
		{
			var selectedColumn = workInProgress.getColumn();
			var selectedRow = workInProgress.getRow();
			if (column == selectedColumn + 1 && row == selectedRow)
			{
				workInProgress.build(0);
				return;
			}
			else if (column == selectedColumn && row == selectedRow + 1)
			{
				workInProgress.build(1);
				return;
			}
			else if (column == selectedColumn - 1 && row == selectedRow)
			{
				workInProgress.build(2);
				return;
			}
			else if (column == selectedColumn && row == selectedRow - 1)
			{
				workInProgress.build(3);
				return;
			}
			else
			{
				workInProgress.moveTo(column, row);
			}
		}
	}
	
	public function clearPointing()
	{
		pointing = false;
	}
	function select(event:flash.events.MouseEvent)
	{
		var row = rowAt(Lib.current.stage.mouseY);
		var column = columnAt(Lib.current.stage.mouseX);
		if (row < 0 || column < 0 || row > rows || column > columns) return;
		if (buildingAt(column, row)) return; //buildingAt activates selection code.
		if (pointing)
		{
			buildIfBuilding(column, row);
		}
		else
		{
			construct(nextBuilding, column, row);
		}
	}
	function buildingAt(column: Int, row: Int)
	{
		for (building in buildings)
		{
			if (building.getColumn() == column)
				if (building.getRow() == row)
				{
					selectBuilding(building);
					return true;
				}
		}
		return false;
	}
	function selectBuilding(building: Building)
	{
		if (activeSwitch != null)
		{
			activeSwitch.acquireTarget(building);
			deactivateSwitch();
			return;
		}
		building.onSelect();
	}
	public function activateSwitch(thisSwitch: Switch)
	{
		activeSwitch = thisSwitch;
		switchSelect.x = xAt(thisSwitch.getColumn()) + cellSize / 2;
		switchSelect.y = yAt(thisSwitch.getRow()) + cellSize / 2;
		Lib.current.stage.addChild(switchSelect);
	}
	function deactivateSwitch()
	{
		activeSwitch = null;
		Lib.current.stage.removeChild(switchSelect);
	}
	
	public function spawnMinion(row: Int, column: Int, speed: Float, direction: Int)
	{
		if (population.length < populationLimit)
			population.push(new Minion(this, row, column, speed, direction));
	}
	
	
	
	public function spawnArrow(column: Int, row: Int, direction: Int)
	{
		buildings.push(new Arrow(this, column, row, direction));
	}
	public function spawnLauncher(column: Int, row: Int, direction: Int)
	{
		buildings.push(new Launcher(this, row, column, direction));
	}
	public function getCellSize()
	{
		return cellSize;
	}
	
	function setOffsets()
	{
		var stage = Lib.current.stage;
		height = stage.stageHeight;
		width = stage.stageWidth;
		
		xOffset = 0.0; //Place the start of the grid differently
		yOffset = 0.0; //Depending on the shape of the stage (even the aspect ratio)
		
		if (height > width) 
		{
			yOffset = (height - width) / 2;
			height = width;
		}
		else 
		{
			xOffset = (width - height) / 2;
			width = height;
		}
	}
	
	public function update()
	{
		for (minion in population)
		{
			minion.update();
		}
		for (building in buildings)
		{
			building.update();
		}
		for (bullet in ordinance)
		{
			bullet.update();
		}
	}
	
	function draw()
	{
		var stage = Lib.current.stage;
		displayBackground();
		
		setOffsets();
		icon.graphics.lineStyle(1, lineColor, 1, false, LineScaleMode.NONE);
		for (row in 0...rows + 1)
		{
			icon.graphics.moveTo(xOffset, yAt(row));
			icon.graphics.lineTo(width + xOffset, yAt(row));
		}
		for (column in 0...columns + 1)
		{
			icon.graphics.moveTo(xAt(column), yOffset);
			icon.graphics.lineTo(xAt(column), height + yOffset);
		}
		stage.addChild(icon);
		cellSize = yAt(1) - yAt(0);
		switchSelect.graphics.lineStyle(1, 0x00FF00, 1, false, LineScaleMode.NONE);
		switchSelect.graphics.drawCircle(0, 0, cellSize * Math.sqrt(2) / 2);
	}
	function displayBackground()
	{
		var background: Sprite = new Sprite();
		background.graphics.beginFill(backgroundColor);
		background.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Lib.current.stage.addChild(background);
	}
	public function xAt(column: Int)
	{
		return column * height / columns + xOffset;
	}
	public function yAt(row: Int)
	{
		return row * width / rows + yOffset;
	}
	public function columnAt(x: Float)
	{
		return Math.round((x - xOffset) * columns / height - 1/2);
	}
	public function rowAt(y: Float)
	{
		return Math.round((y - yOffset) * rows / height - 1/2);
	}
	public function outOfBounds(x: Float, y: Float)
	{
		if (x < xOffset) return true;
		if (x > width + xOffset - cellSize) return true;
		if (y < yOffset) return true;
		if (y > height + yOffset - cellSize) return true;
		return false;
	}
}