package com.mthk.youtube.video
{
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.Youtube;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeVideoObject extends YoutubeService
	{
		public var fs:FileStream;
		//public var mimeType:String = "video/*";
		public var bytesAvailable:uint;
		public var bytesPortion:uint;
		public var bytesPortionNumber:uint;
		public var bytesStart:Number;
		public var bytesMax:Number;
		private var path:String = "";
		private var f:File;
		public function get json():String
		{
			var data:Object = {}
				data.snippet = {};
				data.snippet.title = super.yt.log.videoTitle
				data.snippet.description = super.yt.log.videoDescription
				data.snippet.categoryId = super.yt.vars.video.categoryId//"22"; //this.categoryId
				data.status = {};
				data.status.privacyStatus = super.yt.vars.video.privacyStatus//"unlisted"; //this.privacyStatus
			var zw:String = JSON.stringify(data);data = null;
			return zw
		}
		public function YoutubeVideoObject(_yt:Youtube, _url:String, _bytes:uint, _bytesPortion:uint)
		{
			this.path = _url
			this.bytesAvailable = _bytes
			this.bytesPortion = _bytesPortion
			this.traceName = 'YoutubeVideoObject'
			super(_yt)
		}
		public function read(_oncomplete:Function, _bytesPosition:Number, _bytesPortion:Number = NaN):void
		{
			this.oncomplete = _oncomplete;
			if (this.f == null) { this.f = new File(this.path); };
			if (this.fs == null) { this.fs = new FileStream; };
			if (isNaN(_bytesPortion) != true) { this.bytesPortion = _bytesPortion; };
			this.fs.addEventListener(ProgressEvent.PROGRESS, this.progress);
			this.fs.addEventListener(IOErrorEvent.IO_ERROR, this.error);
			this.fs.readAhead = this.bytesPortion;
			this.fs.openAsync(this.f, FileMode.READ);
			this.fs.position = _bytesPosition;
			this.bytesStart = this.fs.position;
			var _m:Number = (this.bytesAvailable - this.bytesStart);
			if (this.bytesPortion > _m) { this.bytesPortion = _m; }; _m = NaN;
			this.bytesMax = (this.bytesStart + this.bytesPortion);
		}
		private function progress(e:ProgressEvent):void	{ if (e.bytesLoaded >= this.bytesMax) { this.finish(); }; };
		private function error(e:IOErrorEvent):void	{ if (this.onerror != null) { this.onerror(this.traceName + '.errorHandler', '' + e); }; };
		private function finish():void{
			if (this.oncomplete != null){
				var data:ByteArray = new ByteArray
				this.fs.readBytes(data, 0, this.fs.bytesAvailable);
				this.oncomplete(data);
				this.oncomplete = null;
				data = null;
			};
			this.fs.close();
		}
		override public function dispose():void
		{
			this.path = undefined
			this.bytesPortion = NaN;
			this.bytesPortionNumber = NaN;
			this.bytesStart = NaN;
			this.bytesAvailable = NaN;
			if (this.f != null){this.f.cancel();};this.f = null;
			if (this.fs != null){this.fs.close();};this.fs = null;
			super.dispose();
		}
/////////////////////////////
	}

}