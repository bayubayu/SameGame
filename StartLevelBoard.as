/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for start level display
 * 
 */

package  
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
	import flash.text.*;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class StartLevelBoard extends MovieClip
	{
		private static var startLevelBoard:StartLevelBoard = null;
		private static var displayed:Boolean = false;
		private static var num:Number = 0;
		private static var parentBC:ClassicSameGame;
				
		public function StartLevelBoard() 
		{
		}
		
		public static function show(parent:ClassicSameGame) {
			if (startLevelBoard == null) {
				parentBC = parent;
				startLevelBoard = new StartLevelBoard();
				num++;
			}
			startLevelBoard.x = 291;
			startLevelBoard.y = 192;
			if (startLevelBoard.parent == null) { 
				parentBC.container.addChild(startLevelBoard); 
				displayed = true;
				startLevelBoard.startButton.addEventListener(MouseEvent.MOUSE_UP,startButtonClick);			
			}						
		}
		
		public static function hide() {
			if (startLevelBoard.parent != null) { 
				startLevelBoard.parent.removeChild(startLevelBoard); 
				displayed = false;
				startLevelBoard.startButton.removeEventListener(MouseEvent.MOUSE_UP,startButtonClick);
			}						
		}
		
		public static function isDisplayed():Boolean {
			return displayed;
		}
		
		public static function startButtonClick(mouseEvent:MouseEvent) {
			hide();
			parentBC.setMainGameState(parentBC.GAME_STATE_PLAY);
		}
		
		
	}
	
}