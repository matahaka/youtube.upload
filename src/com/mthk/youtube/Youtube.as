package com.mthk.youtube 
{
	import com.mthk.youtube.core.YouTubeLoader;
	import com.mthk.youtube.data.YoutubeTranslation;
	import com.mthk.youtube.data.YoutubeVars
	import com.mthk.youtube.services.YoutubeAuthorizationService;
	import com.mthk.youtube.services.YoutubeLogService;
	import com.mthk.youtube.services.YoutubeUploadService;
	import com.mthk.youtube.video.YoutubeVideoBrowser;
	import com.mthk.youtube.video.YoutubeVideoObject;
	import flash.filesystem.File;
	/**
	 * ...
	 * @author mthk
	 */
	public class Youtube extends YouTubeLoader
	{
		public var vars:YoutubeVars
		public var log:YoutubeLogService
		public var authorization:YoutubeAuthorizationService 
		public var video:YoutubeVideoObject
		
		private var bytesPortion:uint
		public var max15min:Boolean;
		public var oncomplete:Function;
		public var onprogress:Function;
		
		private var videoDescriptionForm:Function
		private var browser:YoutubeVideoBrowser
		private var upload:YoutubeUploadService
		private var authjsonurl:String
		private var browse_dir:File
		
		public function Youtube(_setupjsonurl:String) 
		{
			this.authjsonurl = _setupjsonurl;
			this.vars = new YoutubeVars
			super(null)
			this.bytesPortion = ((this.bytesPortion==0)?(1 * 1024 * 1024):this.bytesPortion);
		}
		
		public function progress(_txt:String):void { if (this.onprogress != null) { this.onprogress(_txt); }; };
		public function browse():void 
		{
			this.log = new YoutubeLogService()
			this.log.init(this.browse_start)
		}
		private function browse_start():void 
		{
			if (this.log.browseDir == null)	{ this.browse_dir = File.desktopDirectory; } else { this.browse_dir = new File(this.log.browseDir); };
			this.browser = new YoutubeVideoBrowser(this);
			this.browser.max15min = this.max15min
			this.browser.onerror = this.onerror;
			this.browser.oncomplete = this.initvideo;
			this.browser.open(this.browse_dir)
		}
		public function initvideo():void
		{
			if ( this.browser != null) { this.browser.dispose(); }; this.browser = null;
			if(this.log.videoData==null){
				this.video = new YoutubeVideoObject(this,this.log.video.path,this.log.video.bytes,this.bytesPortion);
				this.video.onerror = this.onerror;
				if (this.log.videoTitle == null || this.log.videoDescription == null) {
					this.videoDescriptionInput('title', 'description');
					//if(this.videoDescriptionForm!=null){this.videoDescriptionForm('', '');}
				} else { this.authorization_service(); };
			}else {this.oncomplete();}
		}
		public function videoDescriptionInput(_title:String,_descryption:String):void
		{
			this.log.videoTitle = _title;
			this.log.videoDescription = _descryption
			this.authorization_service();
		}
		public function authorization_service():void 
		{
			this.authorization = new YoutubeAuthorizationService(this);
			this.authorization.jsonurl = this.authjsonurl
			this.authorization.onerror = this.onerror;
			this.authorization.oncomplete = this.upload_service;
			this.authorization.init();
		}
		private function upload_service():void 
		{
			this.upload = new YoutubeUploadService(this);
			this.upload.onerror = this.onerror
			this.upload.oncomplete = this.oncomplete
			this.upload.init();
		}
		override public function dispose():void 
		{
			if ( this.browser != null) { this.browser.dispose(); }; this.browser = null;
			if ( this.authorization != null) { this.authorization.dispose(); }; this.authorization = null;
			if ( this.video != null) { this.video.dispose(); }; this.video = null;
			if ( this.upload != null) { this.upload.dispose(); }; this.upload = null;
			if ( this.log != null) { this.log.dispose(); }; this.log = null;
			this.max15min = undefined
			this.oncomplete = null;
			this.onprogress = null;
			this.videoDescriptionForm = null;
			super.dispose()
		}
	}

}