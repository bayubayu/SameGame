/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for animated text score
 * 
 */

package {
    import flash.display.Sprite;
    import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class PopText extends MovieClip {
		private static var num:Number = 0;
		private var _startTime:Number;
		private var _currentDate:Date		
				
		public function PopText() {
			num++;
		}
		
		public function show(container:Sprite,cX:Number,cY:Number,messageString:String) {
			this._startTime = new Date().getTime();
			this.x = cX;
			this.y = cY+num*12;
			message.text = messageString;
			if (this.parent == null) { 
				container.addChild(this); 
				this.addEventListener(Event.ENTER_FRAME, enterFrame);
			}			
		}
						
		public function enterFrame(event:Event) {
			_currentDate = new Date();
			if ((_currentDate.getTime() - this._startTime) >= 3000) {
				if (this.parent != null) { 
					num--;
					this.parent.removeChild(this); 
				}
			} else { 
				this.y--; 
				this.alpha -= 0.012;
			}
			_currentDate = null;
		}
		
	}
	
}