package com.mthk.youtube.services {
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.upload.YoutubeUploadSend;
	import com.mthk.youtube.upload.YoutubeUploadUrl;
	import com.mthk.youtube.Youtube;
	import com.mthk.youtube.data.YoutubeTranslation
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeUploadService extends YoutubeService
	{
		private var _ytUrl:YoutubeUploadUrl
		private var _ytSend:YoutubeUploadSend
		public var steps:uint
		public function YoutubeUploadService(_yt:Youtube) 
		{
			super(_yt)
		}
		override public function dispose():void 
		{
			this.steps = NaN
			if ( this._ytUrl != null) { this._ytUrl.dispose(); }; this._ytUrl = null;
			super.dispose()
		}
		public function init():void 
		{
			if (super.yt.log.videoUrl == null) {
				this.geturl()
			}else {
				this.sendStart();
			}
		}
		private function geturl():void 
		{
			this._ytUrl = new YoutubeUploadUrl(super.yt);
			this._ytUrl.oncomplete = this.sendStart;
			this._ytUrl.onerror = super.onerror;
			this._ytUrl.geturl(super.yt.authorization.access, super.yt.video);
		}
		private function sendStart():void 
		{
			this._ytSend = new YoutubeUploadSend(super.yt);
			this._ytSend.oncomplete = this.oncomplete
			this._ytSend.onerror = this.onerror
			this._ytSend.upload(super.yt.video,super.yt.authorization.access);
		}
	}

}