/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for ball
 * 
 */

package {
    import flash.display.Sprite;
    import flash.display.MovieClip;
	
	public class Tile extends MovieClip {
		public var cx:Number;
		public var cy:Number;
		public var cy1:Number;
		public var moveState:Boolean = false;
		public var nextY:Number;
		public var enable:Boolean = true;
		public var fadeIn:Boolean = false;
		public var speedX:Number = 0;
		public var speedY:Number = 0;
	}
}