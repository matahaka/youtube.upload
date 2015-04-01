package com.mthk.youtube.upload {
	import com.mthk.youtube.authorization.YoutubeAccessToken;
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.video.YoutubeVideoObject;
	import com.mthk.youtube.Youtube;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeUploadSend extends YoutubeService
	{
		private var access:YoutubeAccessToken
		private var video:YoutubeVideoObject
		private var _accessToken:String
		private var data:ByteArray
		override public function dispose():void {
			this.access = null;
			this.video = null;
			if (this.data != null) { this.data.clear(); }; this.data = null;
			super.dispose();
		}
		public function YoutubeUploadSend(_yt:Youtube)
		{
			super(_yt);
			super.traceName = 'YoutubeUploadSend';
		}
		public function upload( _vid:YoutubeVideoObject,_access:YoutubeAccessToken):void 
		{
			this.access = _access
			this.video = _vid
			this.access.token(this.signed);
		}
		private function signed(_accessToken:String):void {
			this._accessToken = _accessToken;
			this._send();
		}
		public function _send():void 
		{
			this.video.read(this._send_request, super.yt.log.videoUploadedBytes);
		}
		private function _send_request(_data:ByteArray):void 
		{
			this.data = _data
			var headers:Array = new Array(
				new URLRequestHeader('Authorization', this._accessToken),
				new URLRequestHeader('content-type', 'application/json;charset=UTF-8'),
				new URLRequestHeader('content-range', 'bytes '+this.video.bytesStart+'-' +(this.video.bytesStart+this.data.bytesAvailable-1)+'/'+this.video.bytesAvailable),
				new URLRequestHeader('content-length', this.data.bytesAvailable.toString() ),
				new URLRequestHeader('expect', '')
			);
			super.yt.request = new URLRequest(super.yt.log.videoUrl);
			super.yt.request.authenticate = true;
			super.yt.request.contentType = super.yt.vars.video.mimeType
			super.yt.request.followRedirects = false;
			super.yt.request.requestHeaders = headers
			super.yt.request.data =  this.data
			super.yt.request.method = URLRequestMethod.PUT
			super.yt.onrecive = this._send_recive;
			super.yt.progress(super.yt.vars.tr.YoutubeUploadSend_upload)
			super.yt.init();
		}
		private function _send_recive(e:Event):void 
		{
			this.data.clear();this.data = null;
			if (super.yt.responseStatus == 308)	{ 
				super.yt.progress(super.yt.vars.tr.YoutubeUploadSend_upload)
				this._check_headers();
			}
			else 
			if (super.yt.responseStatus == 200)	{
				var jsonO:Object;
				try { jsonO = JSON.parse(e.target.data); } 
				catch (e:Error) { if (super.onerror != null) { super.onerror(super.traceName+'.parsejson', '' + e); }; };
				if (jsonO != null) {
					super.yt.log.videoData = jsonO;
					if (super.oncomplete != null) { super.oncomplete(); };
				}
				jsonO = null;
			}
			else { if (super.onerror != null) { super.onerror(super.traceName+'.send_recive', 'yt.responseStatus==' + super.yt.responseStatus + ''); }; };
		}
		private function _resume():void
		{
			var headers:Array = new Array(
				new URLRequestHeader('Authorization', this._accessToken),
				new URLRequestHeader('content-range', 'bytes */'+this.video.bytesAvailable),
				new URLRequestHeader('content-length', '0' ),
				new URLRequestHeader('expect', '')
			);
			super.yt.request = new URLRequest(super.yt.log.videoUrl);
			super.yt.request.authenticate = true;
			super.yt.request.contentType = super.yt.vars.video.mimeType
			super.yt.request.followRedirects = false;
			super.yt.request.requestHeaders = headers
			super.yt.request.method = URLRequestMethod.PUT
			super.yt.onrecive = this._resume_recive;
			super.yt.init();
		}
		private function _resume_recive(e:Event):void 
		{
			if (super.yt.responseStatus == 308)	{ this._check_headers(); }
			else { if (super.onerror != null) { super.onerror(super.traceName+'.resume_recive', 'yt.responseStatus==' + super.yt.responseStatus + ''); }; };
		}
		private function _check_headers():void 
		{
			if (super.yt.responseHeaders != null) {
				var uploadedrange:String='';var urh:URLRequestHeader
				for (var $i:uint = 0; $i < super.yt.responseHeaders.length; $i++ ) { 
					urh = URLRequestHeader(super.yt.responseHeaders[$i])
					if (urh.name == 'Range') { uploadedrange = urh.value; }
				}; $i = NaN; urh = null;
				if (uploadedrange != ''){
					var uploadedrangearray:Array = uploadedrange.split('bytes=').join('').split('-')
					if (uploadedrangearray != null && uploadedrangearray.length > 1) {
						super.yt.log.videoUploadedBytes = uint(uploadedrangearray[1]);
						this._send()
					}else { if (super.onerror != null) { super.onerror(super.traceName+'.resume_recive', 'RangeArray==null'); }; };
					uploadedrangearray = null;
				}else { if (super.onerror != null) { super.onerror(super.traceName+'.resume_recive', 'Range==null'); }; };
				uploadedrange = undefined;
				
			}else {
				if (super.onerror!=null) { super.onerror(super.traceName+'.recive', 'yt.responseHeaders==null'); };
			}
		}
	}
}