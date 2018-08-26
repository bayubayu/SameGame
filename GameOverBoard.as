/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for game over display
 * 
 */

package {
    import flash.display.Sprite;
    import flash.display.MovieClip;
	import flash.text.*;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	
	
	public class GameOverBoard extends MovieClip {
		
		/* Initial Position, set here */
		private const X_POSITION:int = 130;
		private const Y_POSITION:int = 120;
		/*  */
		
		private static var gameOverBoard:GameOverBoard = null;
		private static var displayed:Boolean = false;
		private static var num:Number = 0;
		protected static var dis:EventDispatcher;
		
		public function GameOverBoard() {		
		}
		
		// Show Game Over Board
		public static function show(container:Sprite,score:Number) {
			
			if (gameOverBoard == null) {
				gameOverBoard = new GameOverBoard();
				num++;
			}
			gameOverBoard.x = gameOverBoard.X_POSITION;
			gameOverBoard.y = gameOverBoard.Y_POSITION;
			gameOverBoard.scoreDisplay.text = score.toString();
			if (gameOverBoard.parent == null && container != null) { 
				container.addChild(gameOverBoard); 
				displayed = true;
				gameOverBoard.menuButton.addEventListener(MouseEvent.CLICK,menuButtonClick);			
				
				gameOverBoard.playerName.type = TextFieldType.INPUT;
				gameOverBoard.submitScoreButton.addEventListener(MouseEvent.CLICK,submitScoreButtonClick);
			}						
		}
		
		// Hide Game Over Board
		public static function hide() {
			if (gameOverBoard.parent != null) { 
				gameOverBoard.parent.removeChild(gameOverBoard); 
				displayed = false;
				gameOverBoard.menuButton.removeEventListener(MouseEvent.CLICK,menuButtonClick);
			}
		}
		
		public static function isDisplayed():Boolean {
			return displayed;
		}
    		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void {
      			if (dis == null) { dis = new EventDispatcher(); }
      			dis.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
      		}
			
    		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void {
      			if (dis == null) { return; }
      			dis.removeEventListener(p_type, p_listener, p_useCapture);
      		}
			
		
		public static function dispatchEvent(p_event:Event):void {
			if (dis == null) { return; }
			dis.dispatchEvent(p_event);
		}		
		
		// menu button
		public static function menuButtonClick(mouseEvent:MouseEvent) {
			hide();
			dispatchEvent(new BasicEvent("gotomenu"));	
		}
		
		// submit score button
		public static function submitScoreButtonClick(mouseEvent:MouseEvent) {
			var highscoreURL:String = 'http://localhost/flashhighscore/highscores.php';
			var highscoreGameName:String = 'ClassicSameGame';
			var highscoreScore:Number = int(gameOverBoard.scoreDisplay.text); 
			var highscorePlayerName:String = gameOverBoard.playerName.text; 
			var highscoreKey:Number = ((highscoreScore+12)*0.6)+(((highscorePlayerName+highscoreGameName).length*12));
			
			var highscoreURLVariables:URLVariables = new URLVariables();
			highscoreURLVariables.gamename = highscoreGameName;
			highscoreURLVariables.score = highscoreScore.toString();
			highscoreURLVariables.playername = highscorePlayerName;
			highscoreURLVariables.key = highscoreKey;
			highscoreURLVariables.action = "insert";
			var highscoreRequest:URLRequest = new URLRequest(highscoreURL);
			highscoreRequest.data = highscoreURLVariables;
			navigateToURL(highscoreRequest,"_self");
			
			gameOverBoard.playerName.type= TextFieldType.DYNAMIC;
			
			// back to main menu
			hide();
			dispatchEvent(new BasicEvent("gotomenu"));
		}
	}
	
}