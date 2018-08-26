/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Game Main Class
 * 
 */

package {
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.*;
	import flash.display.SimpleButton;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.events.ProgressEvent;
	
	/* 
	 * Game main class
	 * */
	public class ClassicSameGame extends MovieClip {
		// Ball objects is arranged as array of tiles
		// mapData variable contains data representation of tiles
		// tileObj variable is contains array of Movieclips based on MapData values
		public var container:Sprite;			// Main game container
		private var mapData = Array[10];		// Data representation of tiles
		private var tileObj = new Array;		// MovieClips representation of tiles
		
		// Constants used in game
		private const TILE_SIZE = 20;			// Tile size (width and height)
		private const EMPTY_TILE = 14;			// Flag indicates empty tile, used as value in mapData item
		private const STATE_REARRANGE = 8;		// State when arrange tiles animation playes
		private const STATE_FADE_IN = 36;		// State when fade-in tiles animation plays
		public const GAME_STATE_PLAY = 1;		// Game state for play state
		public const GAME_STATE_STARTLEVEL = 2;	// Game state for starting level (game paused until user click play button)
		public const GAME_STATE_GAMEOVER = 3;	// Game state for game over		
				
		// Maps dimension, value will be assigned at init game function
		private	var map_height:Number;
		private	var map_width:Number;
		
		// Tile arrangement at screen
		private	var start_x:Number;				// x coordinate (left) for array of tiles
		private	var start_y:Number;				// y coordinate (top) for array of tiles
		private	var padding:Number;				// padding between tiles
		private var gameState:Number = 0;		// Stores current game state
		private var mainGameState = 0;			// Stores current main game state
		
		// store previous hovered tile point (prev_i,prev_j)
		private var prev_i:Number = 0;
		private var prev_j:Number = 0;
		
		// Game Score
		private var score:Number = 0;			// game's total score
		private var currentScore:Number = 0;	// current score
		
		// selected tiles's stack
		var stack:Array = null;					// Array of selected tiles
		var pt:Point;
		var clickedPoint:Point = new Point();
		
		// Animated tiles
		var animatedTiles:Array = new Array;			// Array of animated tiles
		var animatedDestroyedTiles:Array = new Array;	// Array of animated destroyed tiles
		
		// Options
		private var optionEnableSelectFirst:Boolean = false;	// enable select balls before destroyed (needs 2x click to destroy)
		private var optionEnableHoverSelect:Boolean = true;		// enable hover select
		
		/*
		 * Set main game state
		 * */
		public function setMainGameState(mainGameState:Number) {
			this.mainGameState = mainGameState;
		}
		
		/*
		 * Start Game
		 * */
		public function startGame():void {
			// Build dummy maps
			mapData = new Array(10);
            mapData[0] = new Array(1, 3, 1, 3, 5, 1, 1, 1, 1, 1, 1, 1, 5, 4, 3, 1);
            mapData[1] = new Array(1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 5, 5);
            mapData[2] = new Array(1, 5, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 4, 5, 2, 1);
            mapData[3] = new Array(1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 3);
            mapData[4] = new Array(1, 1, 5, 4, 1, 3, 1, 1, 1, 1, 1, 1, 3, 5, 5, 4);
            mapData[5] = new Array(1, 1, 5, 5, 1, 1, 5, 1, 1, 1, 1, 1, 1, 1, 5, 4);
            mapData[6] = new Array(1, 3, 1, 5, 1, 4, 5, 3, 2, 1, 1, 1, 5, 1, 5, 4);
            mapData[7] = new Array(1, 1, 1, 3, 3, 1, 5, 5, 5, 1, 5, 1, 2, 1, 1, 3);
            mapData[8] = new Array(4, 1, 4, 1, 1, 3, 5, 3, 3, 5, 5, 1, 3, 4, 5, 2);
            mapData[9] = new Array(5, 1, 2, 1, 5, 1, 5, 2, 2, 3, 3, 3, 5, 4, 3, 1);			
			
			// Tiles layout settings
			map_height = 10;			// Set Tiles height
			map_width  = 16;			// Set Tiles width	
			start_x= 33;				// Set tiles left
			start_y= 79;				// Set tiles top
			padding= 12;				// Set tiles padding
			
			// Build tiles based on settings
			buildMap();
			
			// Event listener
            addEventListener(Event.ENTER_FRAME,onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp1);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseClick1);
			
			// Set initial score
			score = 0;
			
			// Set initial game state
			mainGameState = GAME_STATE_STARTLEVEL;
			
			// Show startlevel board
			StartLevelBoard.show(this);
		}
		
		/*
		 * Build ball's map
		 * Set random mapData, and then build tile object to screen based on mapData
		 * */
		private function buildMap() {
			// Prepare container
			container = new Sprite();
			addChild(container);
			for (var j:Number = 0; j<map_height; j++) {
				tileObj[j] = new Array();
				for (var i:Number = 0; i < map_width; i++) {
					// random map data item
					mapData[j][i] = Math.round(Math.random() * 4) + 1;
					
					// prepare new tile item
					var tile:Tile = new Tile();					
					tile.x = start_x + i * (TILE_SIZE + padding);
					tile.y = start_y + j * (TILE_SIZE + padding);
					
					// Set tile appereance
					if (mapData[j][i]== 0)
						tile.gotoAndStop(EMPTY_TILE);					
					else
						tile.gotoAndStop(mapData[j][i]);
					
					var dropShadow:DropShadowFilter = new DropShadowFilter();
					dropShadow.strength = 0.3;
					dropShadow.blurX = 6;
					dropShadow.blurY = 6;
					//dropShadow.distance = 2;
					//dropShadow.color = 0xffffff;
					tile.filters = new Array(dropShadow);
						
					tileObj[j][i] = tile;
					tileObj[j][i].cx = i;
					tileObj[j][i].cy = j;
					tileObj[j][i].ballSelector.visible = false;
					container.addChild(tileObj[j][i]);
				}
			}		
		}
		
		/*
		 * rearrange balls after popped
		 * */
		private function rearrange() {
			//trace("rearrange");
			gameState = STATE_REARRANGE;
			for (var j:Number = map_height-1; j>=0; j--) {
				for (var i:Number = map_width-1; i>=0; i--) {
					
					if (j<map_height-1 && (tileObj[j+1][i].currentFrame == EMPTY_TILE) && tileObj[j][i].currentFrame != EMPTY_TILE) {
						// shift Down						
						// create temporary animated tile object
						var tileTemp:MovieClip = new Tile();
						tileTemp.ballSelector.visible = false;
								
						for (var j2:Number = j; j2 < map_height; j2++) {
							if (j2 + 1 == map_height) {
								tileTemp.x = tileObj[j][i].x;
								tileTemp.y = tileObj[j][i].y;
								tileTemp.cx = i;
								tileTemp.cy = map_height-1;
								tileTemp.cy1 = j;
								tileTemp.gotoAndStop(tileObj[j][i].currentFrame);
								tileTemp.nextY = tileObj[map_height-1][i].y;//j2;
								tileTemp.moveState = true;			
								container.addChild(tileTemp);
								animatedTiles.push(tileTemp);
								tileObj[j][i].gotoAndStop(EMPTY_TILE);
								tileObj[j2][i].gotoAndStop(15);
								break;
							}
							else
							if (tileObj[j2+1][i].currentFrame == EMPTY_TILE) {
							} else { 
								tileTemp.x = tileObj[j][i].x;
								tileTemp.y = tileObj[j][i].y;
								tileTemp.cx = i;
								tileTemp.cy = j2;
								tileTemp.cy1 = j;
								tileTemp.gotoAndStop(tileObj[j][i].currentFrame);
								tileTemp.nextY = tileObj[j2][i].y;
								tileTemp.moveState = true;
								container.addChild(tileTemp);
								animatedTiles.push(tileTemp);
							
								tileObj[j][i].gotoAndStop(EMPTY_TILE); 
								
								tileObj[j2][i].gotoAndStop(15); 
								break; 							
							}
						}																								
					}
				}
			}		
			
			// place animated destroyed tiles to stage
			for each (var adt in animatedDestroyedTiles) {
				addChild(adt);
			}
						
			if (stack == null) return;
			
			// display pop text			
			var popText:PopText = new PopText();			
			popText.show(container,clickedPoint.x+25,clickedPoint.y-45,this.currentScore.toString());
		}
		
		// shift horizontal
		private function shiftHorizontal() {
			for (var i3:Number = map_width - 1; i3 >= 0; i3--) {
				var flag_gap:Boolean = true;
				for (var j3:Number = map_height - 1; j3 >= 0; j3--) {
					if (tileObj[j3][i3].currentFrame != EMPTY_TILE) { 
						flag_gap = false; 
						break;
					}
				}
				
				if (flag_gap) {
					for (var j5:Number = 0; j5 < map_height; j5++ ) {
						for (var i5:Number = i3; i5 < map_width-1; i5++ ) {
							tileObj[j5][i5].gotoAndStop(tileObj[j5][i5 + 1].currentFrame);
							tileObj[j5][i5+1].gotoAndStop(EMPTY_TILE);
						}
					}										
				}
			}			
		}

		/*
		 * check no more move
		 * */
		private function checkStuck():Boolean {
			for (var i:Number = 0; i < map_width; i++) {
				for (var j:Number = 0; j < map_height; j++) {
					if (tileObj[j][i].currentFrame != EMPTY_TILE) {
						if (
						(i<map_width-1 && tileObj[j][i].currentFrame == tileObj[j][i+1].currentFrame) ||
						(i>0 && tileObj[j][i].currentFrame == tileObj[j][i-1].currentFrame) ||
						(j<map_height-1 && tileObj[j][i].currentFrame == tileObj[j+1][i].currentFrame) ||
						(j>0 && tileObj[j][i].currentFrame == tileObj[j-1][i].currentFrame)
						) {
							return false;
							break; 
						}
					}
				}				
			}
			return true;
		}
		
		/*
		 * Select balls and fill in stack
		 * */
		private function selectBalls(ti:Number, tj:Number) {
			//trace("select-mode-"+Math.random());
			// save current selected
			prev_i = ti;
			prev_j = tj;
			
			if (gameState == STATE_REARRANGE) { return; }
			// remove all ball selector
			for (var j:Number = 0; j<map_height; j++) {
				for (var i:Number = 0; i < map_width; i++) {
					tileObj[j][i].ballSelector.visible = false;
				}
			}					
			
			if (tileObj[tj][ti].currentFrame == EMPTY_TILE) { return; }
			
			stack = new Array();
			pt = new Point(ti,tj);
			stack.push(pt);
			
			clickedPoint = new Point(tileObj[tj][ti].x,tileObj[tj][ti].y);
						
			getSurrounding(ti,tj);
			if (stack.length == 1) { 
				stack = null;
				return; 
			}
			
			var stack2:Array = new Array;
			
			for (var ii = 1; ii<24; ii++) {
				stack2 = new Array();
				for each (var lpt1 in stack) {
					stack2.push(lpt1);
				}				
				for each (var lpt2 in stack2) {
					getSurrounding(lpt2.x,lpt2.y);
				}				
			}
			
			// activate ball selector
			for each (var lpt in stack) {				
				tileObj[lpt.y][lpt.x].ballSelector.visible = true;
			}
		}		
		
		/*
		 * Destroy balls at stack
		 * */
		private function executeDestroy():void {						
			// remove stack			
			if (stack == null) return;
			for each (var lpt in stack) {
				// destroy animation
				var tileTemp:MovieClip = new Tile();
				tileTemp.x = tileObj[lpt.y][lpt.x].x;
				tileTemp.y = tileObj[lpt.y][lpt.x].y;
				tileTemp.ballSelector.visible = false;
				tileTemp.speedY = 8;
				
				tileTemp.gotoAndStop(tileObj[lpt.y][lpt.x].currentFrame);
				animatedDestroyedTiles.push(tileTemp);
				
				// end create animation				
				//trace(lpt);
				tileObj[lpt.y][lpt.x].gotoAndStop(EMPTY_TILE);
				tileObj[lpt.y][lpt.x].ballSelector.visible = false;
			}	
						
			// check points
			this.currentScore = stack.length * (stack.length - 1);
			this.score += currentScore;
			
			//trace("balls popped = ", stack.length, " score = ", this.score);
			scoreDisplay.text = this.score.toString();
						
			// reset prev_i and prev_j since its probably already filled with other balls (not same ball anymore)
			prev_i = 0;
			prev_j = 0;
		}
		
		/*
		 * Get surrounding tiles with same color and push it to stack
		 * */
		private function getSurrounding(ti:Number,tj:Number) {
			//check surrounding
			if (ti>0)
			if (tileObj[tj][ti-1].currentFrame == tileObj[tj][ti].currentFrame) { //left
				pt = new Point(ti - 1, tj); 
				
				// check for duplicate
				var flag_duplicate:Boolean = false;
				for each (var lptx in stack) {
					if (lptx.x == pt.x && lptx.y == pt.y) flag_duplicate = true;
				}
				
				if (!flag_duplicate)
					stack.push(pt); 
			}
			if (ti<map_width-1)
			if (tileObj[tj][ti+1].currentFrame == tileObj[tj][ti].currentFrame) { //right
				pt = new Point(ti + 1, tj); 
				
				// check for duplicate
				var flag_duplicate2:Boolean = false;
				for each (var lptx2 in stack) {
					if (lptx2.x == pt.x && lptx2.y == pt.y) flag_duplicate2 = true;
				}
				
				if (!flag_duplicate2)
				stack.push(pt); 
			}
			if (tj >0)
			if (tileObj[tj-1][ti].currentFrame == tileObj[tj][ti].currentFrame) { //up
				pt = new Point(ti, tj - 1); 
				
				// check for duplicate
				var flag_duplicate3:Boolean = false;
				for each (var lptx3 in stack) {
					if (lptx3.x == pt.x && lptx3.y == pt.y) flag_duplicate3 = true;
				}
				
				if (!flag_duplicate3)
				stack.push(pt); 
			}
			if (tj<map_height-1)
			if (tileObj[tj+1][ti].currentFrame == tileObj[tj][ti].currentFrame) { //down
				pt = new Point(ti, tj + 1); 
				
				// check for duplicate
				var flag_duplicate4:Boolean = false;
				for each (var lptx4 in stack) {
					if (lptx4.x == pt.x && lptx4.y == pt.y) flag_duplicate4 = true;
				}
				
				if (!flag_duplicate4)
				stack.push(pt); 
			}
		}
		
		/*
		 * On enter frame
		 * */
		private function onEnterFrame(event:Event) {
			if (mainGameState == GAME_STATE_PLAY) {				
				playGame();
			}
		}
		
		/*
		 * Play game
		 * */
		private function playGame() {
			
			for (var j:Number = 0; j<map_height; j++) {
				for (var i:Number = 0; i<map_width; i++) {
					
					if (tileObj[j][i].hitTestPoint(mouseX, mouseY, true) && gameState != STATE_REARRANGE && optionEnableHoverSelect) {
						if (!(prev_i == i && prev_j == j)) {
						if (!tileObj[j][i].ballSelector.visible)
							selectBalls(i, j);
						}
					}
					
				}
			}					
			
		// animate the animatedTiles
		if (gameState == STATE_REARRANGE) {	
			for (var ii:Number = 0; ii < animatedTiles.length; ii++) {				
				if (animatedTiles[ii].y < animatedTiles[ii].nextY) {
					animatedTiles[ii].y+=7;
				} else {
					tileObj[animatedTiles[ii].cy][animatedTiles[ii].cx].gotoAndStop(animatedTiles[ii].currentFrame);					
					if (animatedTiles[ii].parent != null) {
						container.removeChild(animatedTiles[ii]);						
					}
				}
			}
		}
		
		if (gameState == STATE_FADE_IN) {
			//trace("fade in", gameState);
				for (var j3:Number = 0; j3<map_height; j3++) {
					for (var i3:Number = 0; i3 < map_width; i3++) {
							if (tileObj[j3][i3].fadeIn) {
								if (tileObj[j3][i3].scaleY < 1) {
								tileObj[j3][i3].scaleX += 0.15;
								tileObj[j3][i3].scaleY += 0.15;
								gameState = STATE_FADE_IN;
								} else {
								tileObj[j3][i3].scaleX = 1;
								tileObj[j3][i3].scaleY = 1;
								tileObj[j3][i3].fadeIn = false;
								gameState = 1;
								}
								
							}
						}
					}
		}
		
		// destroyed balls animation
		for each (var adt in animatedDestroyedTiles) {
			adt.y += adt.speedY;
			adt.x += adt.speedX;
			adt.speedY++;
			if (adt.speedX > 0) adt.rotation += 15; else adt.rotation -= 15;
			
			if (adt.y > 450) { 
				if (adt.parent != null) {
					removeChild(adt); 
					adt = null;
				}
			}
		}
		
		var xx:Number = 0;
		for (var ia:Number = 0; ia<animatedTiles.length; ia++) {
			if (animatedTiles[ia].parent != null) xx++;
		}
		
		if (xx == 0) { 
			animatedTiles = new Array(); // destroy all animatedTiles
			
			gameState = 1;
			shiftHorizontal();			
			
			if (checkStuck()) { 
				//trace("GameOver"); 
				GameOverBoard.show(container, this.score);
				GameOverBoard.addEventListener(BasicEvent.MESSAGE, menuButtonClick2, false, 0, true);
			}
		}
		
		}
		
		public function menuButtonClick2(basicEvent:BasicEvent):void {			
			GameOverBoard.removeEventListener(BasicEvent.MESSAGE, menuButtonClick2);
			GameOverBoard.hide();
			gotoMainMenu();
			//trace("menu button clicked2", basicEvent.message);	
			
		}		
		
		private function gotoMainMenu() {
			//mainGameState = GAME_STATE_MAINMENU;
			removeChild(container);
			container = null;
			gotoAndStop("titleScreen");
		}
		
						
		private function onMouseClick1(mouseEvent:MouseEvent) {
			if (mainGameState == GAME_STATE_PLAY)
			for (var j:Number = 0; j<map_height; j++) {
				for (var i:Number = 0; i<map_width; i++) {		
					if (tileObj[j][i].hitTestPoint(mouseX, mouseY, true)) {
						// select option
						if (optionEnableSelectFirst) {
							if (tileObj[j][i].ballSelector.visible) {
								//trace("j = ", j, " i =  ", i);
								executeDestroy();
								rearrange();
								stack = null;
								//trace(stack);
							}
							else {
								selectBalls(i, j);
							}
						} else {
							// direct mode
							selectBalls(i, j);
							executeDestroy();
							rearrange();
							stack = null;
						}
						
						break;
					}
				}
			}					
			
		}
		
		private function onKeyUp1(keyboardEvent:KeyboardEvent) {
			if (keyboardEvent.keyCode == Keyboard.SPACE) {				
				//rearrange();
				//trace(checkStuck());
			}
			if (keyboardEvent.keyCode == Keyboard.UP) {
				for (var j:Number = 0; j<map_height; j++) {
					for (var i:Number = 0; i<map_width; i++) {
						if (tileObj[j][i].currentFrame == 3) { 
							tileObj[j][i].gotoAndStop(EMPTY_TILE);
						}
					}
				}					
			}
		}
	}	
}