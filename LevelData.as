/**
 * ...
 * @author     : Bayu Rizaldhan Rayes
 * web         : http://www.bayubayu.com
 * email       : rizald_ray@yahoo.com
 * 
 * Description : Class for level data
 * 
 */

package  
{
	public class LevelData 
	{		
		public var minScore:Number;
		public var maxTime:Number;
		public var maxMissed:uint;
		public var min1:uint;
		public var min2:uint;
		public var min3:uint;
		public var min4:uint;
		public var min5:uint;
		public function LevelData(minScore,maxTime,maxMissed,min1,min2,min3,min4,min5:Number) 
		{
			this.minScore = minScore;
			this.maxTime = maxTime;
			this.maxMissed = maxMissed;
			this.min1 = min1;
			this.min2 = min2;
			this.min3 = min3;
			this.min4 = min4;
			this.min5 = min5;
		}
		
	}
	
}