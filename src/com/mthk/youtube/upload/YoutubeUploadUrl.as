package com.mthk.youtube.upload {
	import com.mthk.youtube.authorization.YoutubeAccessToken;
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.video.YoutubeVideoObject;
	import com.mthk.youtube.Youtube;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeUploadUrl extends YoutubeService
	{
		private var video:YoutubeVideoObject
		private var uploadUrl:String
		//private var url:String
		override public function dispose():void 
		{
			//this.url = undefined;
			this.video = null;
			this.uploadUrl = undefined;
			super.dispose();
		}
		public function YoutubeUploadUrl(_yt:Youtube)
		{
			//this.url = ;
			super(_yt)
			super.traceName = 'YoutubeUploadUrl';
		}
		public function geturl(_access:YoutubeAccessToken,_vid:YoutubeVideoObject):void 
		{
			this.video = _vid
			super.yt.progress(super.yt.vars.tr.YoutubeUploadUrl_get);
			_access.token(this.buildRequest);
		}
		private function buildRequest(_accesstoken:String):void 
		{
			trace(super.yt.vars.youtubeUploadUrl)
			var headers:Array = new Array(
				new URLRequestHeader("Authorization", _accesstoken),
				new URLRequestHeader("content-type", "application/json;charset=UTF-8"),
				new URLRequestHeader("content-length", this.video.json.length.toString()),
				new URLRequestHeader("x-upload-content-type", super.yt.vars.video.mimeType),
				new URLRequestHeader("x-upload-content-length", this.video.bytesAvailable.toString()),
				new URLRequestHeader("expect", "")
			);
			super.yt.request = new URLRequest(super.yt.vars.youtubeUploadUrl);
			super.yt.request.authenticate = true;
			super.yt.request.contentType = super.yt.vars.video.mimeType
			super.yt.request.followRedirects = false;
			super.yt.request.requestHeaders = headers
			super.yt.request.data = this.video.json;
			super.yt.request.method = URLRequestMethod.POST;
			headers = null;
			super.yt.onrecive = this._recive;
			super.yt.init();
		}
		private function _recive(e:Event):void 
		{
			if (super.yt.responseHeaders != null) {
				var h:URLRequestHeader;	
				for (var $i:uint = 0; $i < super.yt.responseHeaders.length; $i++ ) { 
					h = super.yt.responseHeaders[$i]; 
					trace(h.name,h.value)
					if ( h.name == 'Location') { this.uploadUrl = h.value; break; }}; $i = NaN; h = null;
				if (this.uploadUrl != null)	{
					if (super.oncomplete != null) {  
						super.yt.log.videoUrl = this.uploadUrl
						super.yt.progress(super.yt.vars.tr.YoutubeUploadUrl_set)
						super.oncomplete();
					};
				}else {
					if (super.onerror!=null) { super.onerror(super.traceName+'.recive', 'uploadUrl==null'); };
				}
			}else {
				if (super.onerror!=null) { super.onerror(super.traceName+'.recive', 'yt.responseHeaders==null'); };
			}
		}
	}

}