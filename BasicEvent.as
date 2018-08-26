/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for basic event
 * 
 */

package  
{
	import flash.events.Event;
	
	public class BasicEvent extends Event
	{
		public static const MESSAGE:String = "example";
		public var message:String;
		
		public function BasicEvent(message:String = "Default message") 
		{
			super(MESSAGE);
			this.message = message;
		}
		
	}
	
}