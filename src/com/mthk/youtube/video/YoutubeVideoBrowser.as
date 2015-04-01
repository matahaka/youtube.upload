package com.mthk.youtube.video {
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.Youtube;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeVideoBrowser extends YoutubeService
	{
		public var max15min:Boolean
		private var file:File
		private var path:String
		private var bytes:uint
		private var netconnection:NetConnection
		private var netstream:NetStream
		private var client:Object
		private var defaultDirectory:File
		override public function dispose():void 
		{
			this.max15min = undefined
			this.path = undefined
			this.bytes = NaN;
			if (this.file != null) { this.file.cancel(); }; this.file = null;
			this.defaultDirectory = null;
			if (this.netconnection != null) { this.netconnection.close(); }; this.netconnection = null;
			if (this.netstream != null) { this.netstream.close();this.netstream.dispose(); }; this.netstream = null;
			if (this.client != null) { this.client.onMetaData = null; }; this.client = null;
			super.dispose();
		}
		public function YoutubeVideoBrowser(_yt:Youtube) 
		{
			super(_yt);
			super.traceName = 'YoutubeVideoBrowser';
		}
		public function open(_dir:File):void
		{
			this.defaultDirectory = _dir;
			this.air_browser();
		}
		private function air_browser():void 
		{
			var fileFormatString:String = '*.' + super.yt.vars.fileFormats.join(';*.');
			var fileFilter0:FileFilter = new FileFilter("Video", fileFormatString);
			var fileFilters:Array = [fileFilter0];
			this.file = (this.defaultDirectory != null?this.defaultDirectory:File.userDirectory);//documentsDirectory;
			this.file.addEventListener(Event.SELECT, this.fileSelected);
			try {
				this.file.browseForOpen(super.yt.vars.tr.YoutubeVideoBrowser_getFile, fileFilters);
			}catch (e:Error) {
				if (super.onerror!=null) { super.onerror(super.traceName+'.browseForOpen', ''+e.message); };
			}
		}
		private function fileSelected(e:Event):void 
		{ 
			if (this.file!=null && this.file.exists==true && this.file.nativePath != null)
			{
				super.yt.log.browseDir = this.file.parent.url
				this.path = this.file.url//.nativePath
				this.bytes = this.file.size
				this.file.cancel()
				this.file = null;
				if (this.path != null) { 
					if (this.max15min == true) { this.getMetaData(); } else { this.finish(); };
				
				} else { if (super.onerror != null) { super.onerror(super.traceName+'.fileSelected', 'this.path==null:' + e); }; }
			}else {
				if (super.onerror!=null) { super.onerror(super.traceName+'.fileSelected', 'this.file==null:'+e); };
			}
		}
		private function getMetaData():void
		{
			this.netconnection = new NetConnection();
			this.netconnection.connect(null)
			this.netstream = new NetStream(this.netconnection);
			//this.netstream.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStreamStatus);
			this.netstream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onNetStreamAsyncError);
			this.client = new Object();
			this.client.onMetaData = this.onNetStreamMetaData
			this.netstream.client = this.client;
			this.netstream.play(this.path); 
			this.netstream.pause();
		}
		//private function onNetStreamStatus(event:NetStatusEvent):void { if (this.ontrace != null) { this.ontrace(this.traceColor, '[|]', this.traceName, '.onNetStreamStatus:'+Main.otr(event.info) ) };}
		private function onNetStreamAsyncError(event:AsyncErrorEvent):void 
		{ 
			if (this.onerror!=null) { this.onerror(this.traceName+'.ASYNC_ERROR', ''+event); };
		}
		private function onNetStreamMetaData(metadata:Object):void 
		{
			var maxduration:uint = (15 * 60) - 1;// '15 min.'
			var isAcceptable:Boolean = Boolean(metadata.duration < maxduration);
			this.netconnection.close();	this.netconnection = null;
			this.netstream.close(); this.netstream.dispose(); this.netstream = null;
			this.client.onMetaData = null; this.client = null;
			if (isAcceptable) { this.finish(); } else { if (this.onerror != null) { this.onerror(this.traceName+'.duration', 'metadata.duration bigger than 15 min'); }; };
			maxduration = NaN
			isAcceptable = undefined
		};
		private function finish():void 
		{
			
			if (this.oncomplete != null) { 
				super.yt.log.video = { path:this.path, bytes:this.bytes };
				this.oncomplete();
			};
		}
	}

}