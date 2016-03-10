package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.external.ExternalInterface;
import flash.Lib;
import flash.Memory;
import flash.text.GridFitType;
import flash.utils.IDataInput;
import flash.utils.ObjectInput;
import haxe.Resource;

/**
 * ...
 * @author Josh Eklund
 */

class Main 
{
	//Okay. So.
	//The entire point of this is to have a lot of pretty loops 
	//running about making interesting things happen.
	
	//It's a game about recursion, in the same way as Portal is about momentum.
	//Recursion in the service of VIOLENCE.
	//But I'm getting ahead of myself.
	
	//Challenge One is due 12/6/12.
	//We need a grid, with little circles moving around.
	//We need signs and arrows that can direct those poor little circles
	//And we need some reason to do so - a goal of some kind
	
	//Ultimately we wanna have whole recursing ant lines
	//And like, Towers that you build up by putting a bunch of troops in there for a while
	//And armories that troops can walk through to get powered up
	//And battering rams that troops can use to destroy towers
	//And roads that can make them move faster
	//And on and on
	
	//For right now.......
	//Let's just have you build a base?
	//I mean there should be hazards of some kind, hmm...
	//Let's have you INFILTRATE a base, and there are guard towers shooting at you
	//Inverse tower defense, essentially
	
	static var grid: Grid;
	static function main() 
	{
		var stage = Lib.current.stage;
		var test: String = Resource.getString("levelData");
		//trace(test);
		
		trace(Std.random(38013));
		trace(Std.random(42));
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		grid = new Grid(19,19);
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, function(_) onEnterFrame());
		
	}
	static function onEnterFrame()
	{
		grid.update();
	}
	
}