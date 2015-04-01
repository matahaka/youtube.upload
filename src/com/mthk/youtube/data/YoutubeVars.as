package com.mthk.youtube.data 
{
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeVars
	{
		public var tr:YoutubeTranslation
		public var mimeType:String;
		public var video:Object
		public var fileFormats:Array
		public var youtubeUploadUrl:String;
		public function YoutubeVars() 
		{
			this.tr = new YoutubeTranslation;
			this.mimeType = "video/*";
			this.video = { categoryId:"22", privacyStatus:"unlisted" };
			this.fileFormats = ["mov", "mpeg4", "mp4", "avi", "mwv", ".mpegps", "flv", "3gpp", "webm"];
			this.youtubeUploadUrl = "https://www.googleapis.com/upload/youtube/v3/videos?part=status,snippet&uploadType=resumable"
		}
		
	}

}