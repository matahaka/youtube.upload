package com.mthk.youtube.core 
{
	import com.mthk.youtube.Youtube;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeService 
	{
		public var yt:Youtube
		public var onerror:Function;
		public var oncomplete:Function;
		protected var traceName:String
		public function YoutubeService(_yt:Youtube) 
		{
			this.yt = _yt
		}
		public function dispose():void 
		{
			this.yt = null;
			this.onerror = null;
			this.oncomplete = null;
			this.traceName = undefined
		}
	}

}