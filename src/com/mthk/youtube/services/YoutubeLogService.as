package com.mthk.youtube.services 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeLogService
	{
		public var onerror:Function
		private var traceName:String
		private var file:File
		private var fs:FileStream
		private var json:Object
		private var onOpenComplete:Function;
		private var write_timeout:uint
		private var emptyba:ByteArray
		public function dispose():void	
		{
			this.onerror = null;
			this.emptyba = null;
			this.file.cancel()
			this.file = null;
			if (this.fs.hasEventListener(IOErrorEvent.IO_ERROR)) { this.fs.removeEventListener(IOErrorEvent.IO_ERROR, this.error); }
			this.fs.close();
			this.fs = null;
			this.json = null;
			this.onOpenComplete = null;
			clearTimeout(this.write_timeout);
			this.write_timeout = NaN;
		}
		public function YoutubeLogService() 
		{
			this.emptyba = new ByteArray
			this.traceName = 'YoutubeLogService';
			this.file = File.applicationStorageDirectory.resolvePath('youtube.data.json')
		}
		public function init(_onComplete:Function):void 
		{
			this.open(_onComplete);
		}
		public function set browseDir(s:String):void { this.json.browse_dir = s; this.write(); };
		public function get browseDir():String { return this.json.browse_dir; };
		private var _video_id:int
		private function find_video_id(o:Object):void
		{ 
			var $t:uint = this.json.videos.length; var $i:uint; var $o:Object;
			this._video_id = -1;
			for ($i = 0; $i < $t; $i++ ) {
				$o = this.json.videos[$i];	if ($o.path == o.path && $o.bytes == o.bytes) { this._video_id = $i; break; };
			};
			if (this._video_id == -1) { this._video_id = $t; };
			$t = $i = NaN; $o = null;
		};
		public function set video(o:Object):void 
		{ 
			if (this.json.videos == null) { this.json.videos = new Array; };
			this.find_video_id(o)
			var $o:Object = this.json.videos[this._video_id];
			if ($o == null) { $o = { }; };
			for (var key:String in o) { $o[key] = o[key]; };
			key = undefined; o = null;
			this.json.videos[this._video_id] = $o;
			$o = null;
			this.write();
		};
		public function get video():Object { return this.json.videos[this._video_id]; };
		public function set videoUrl(s:String):void { this.video.upload_url = s; this.write(); };
		public function get videoUrl():String { return this.video.upload_url; }
		public function set videoTitle(s:String):void { this.video.title = s; this.write(); };
		public function get videoTitle():String { return this.video.title; }
		public function set videoDescription(s:String):void { this.video.description = s; this.write(); };
		public function get videoDescription():String { return this.video.description; }
		public function set videoUploadedBytes(i:uint):void { this.video.uploaded_bytes = i; this.write(); };
		public function get videoUploadedBytes():uint { return this.video.uploaded_bytes; };
		public function set videoData(o:Object):void {
			delete(this.video.upload_url);
			delete(this.video.uploaded_bytes);
			delete(this.video.uploaded_id);
			this.video.data = o;
			this.write();
		};
		public function get videoData():Object { return this.video.data; };
		private function open(_onOpenComplete:Function):void {
			this.onOpenComplete = _onOpenComplete
			this.fs = new FileStream;
			this.fs.addEventListener(IOErrorEvent.IO_ERROR, this.error);
			this.fs.addEventListener(Event.COMPLETE, this.open_complete);
			this.fs.openAsync(this.file, FileMode.UPDATE);
		}
		private function open_complete(e:Event):void { 
			this.fs.removeEventListener(Event.COMPLETE, this.open_complete);
			var str:String = this.fs.readUTFBytes( this.fs.bytesAvailable );
			if (str) { this.json = JSON.parse(str);	} else { this.json = { }; };
			str = undefined;
			this.onOpenComplete();
		}
		private function write():void 
		{
			this.fs.position = 0;
			this.fs.truncate();
			this.fs.writeUTFBytes(JSON.stringify(this.json));
		}
		private function error(e:IOErrorEvent):void { if (this.onerror != null) { this.onerror(this.traceName+'.errorHandler', '' + e); };	};
	}

}