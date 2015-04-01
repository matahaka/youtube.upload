package com.mthk.youtube.authorization {
	import com.mthk.youtube.authorization.YoutubeAccessToken;
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.Youtube;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeAccessToken extends YoutubeService
	{
		private function get now():Number {	return new Date().getTime(); };
		private function getExpireMs(_s:uint):uint { return uint(_s * 1000); };
		public var tokenData:Object
		public var accessData:Object
		private var expires_time:Number
		private var url:String
		public function YoutubeAccessToken(_yt:Youtube)
		{
			super(_yt);
			super.traceName = 'YoutubeAccessToken';
		}
		public function init():void 
		{
			this.url = this.tokenData.token_uri;//"https://accounts.google.com/o/oauth2/token";
			if (this.accessData == null) {
				var requestVars:URLVariables = new URLVariables();
					requestVars.hl =  super.yt.vars.tr.Youtube_hl;//'pl_PL';
					requestVars.client_id = this.tokenData.client_id;
					requestVars.client_secret = this.tokenData.client_secret;
					requestVars.refresh_token = this.tokenData.refresh_token;
					requestVars.grant_type = 'refresh_token';
				super.yt.request = new URLRequest(this.url);
				super.yt.request.data = requestVars;
				super.yt.request.method = URLRequestMethod.POST;
				super.yt.dataFormat = URLLoaderDataFormat.TEXT
				super.yt.onrecive = this._recive
				requestVars = null;
				super.yt.progress(super.yt.vars.tr.YoutubeAccessToken_get)
				super.yt.init();
			}else {
				this._return_json();
			}
		}
		private function _recive(e:Event):void 
		{
			try { 
				this.accessData = JSON.parse(e.target.data);
				this._return_json();
			}
			catch (e:Error) { if (super.onerror != null) { super.onerror(super.traceName+'.parsejson', '' + e); }; }
		}
		public function token(_oncomplete:Function):void 
		{ 
			var n:Number = this.now;
			var isTokenActual:Boolean = this.expires_time > n;
			var t:String = this.accessData.token_type+' ' + this.accessData.access_token; n = NaN;
			if (isTokenActual == true) { _oncomplete(t); }
			else { this.oncomplete = _oncomplete; this.init(); };
			t = undefined;
			isTokenActual = undefined;
		};
		private function _return_json():void 
		{
			if (this.accessData != null) {
				this.expires_time = this.now + this.getExpireMs(uint(this.accessData.expires_in));
				var t:String = this.accessData.token_type+' ' + this.accessData.access_token;
				if (this.oncomplete != null) { 
					super.yt.progress(super.yt.vars.tr.YoutubeAccessToken_set)
					this.oncomplete(t);
				};
				t = undefined;
			}else {
				if (super.onerror!=null) { super.onerror(super.traceName+'.recive', 'json==null'); };
			}
		}
		override public function dispose():void 
		{
			this.url = undefined;
			this.tokenData = null;
			this.expires_time = NaN;
			super.dispose();
		}
	}

}