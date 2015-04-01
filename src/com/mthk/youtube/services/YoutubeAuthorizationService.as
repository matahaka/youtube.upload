package com.mthk.youtube.services {
	import com.mthk.youtube.authorization.YoutubeAccessToken;
	import com.mthk.youtube.authorization.YoutubeTokenData;
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.Youtube;
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeAuthorizationService extends YoutubeService
	{
		private var timeout:uint
		public var steps:uint
		public var jsonurl:String
		private var _ytTokenData:YoutubeTokenData
		private var _ytAccessToken:YoutubeAccessToken
		public function get access():YoutubeAccessToken { return this._ytAccessToken; }
		public function YoutubeAuthorizationService(_yt:Youtube)
		{
			super(_yt)
		};
		public function init():void 
		{
			if (this._ytTokenData == null) {
				this.load_tokendata()
			}else {
				if (this._ytAccessToken == null) {
					this.load_accessdata();
				}else {
					if (this._ytAccessToken != null &&this._ytAccessToken.token != null) {
						this._ytAccessToken.token(this.loaded_accessdata);
					}
				}
			}
		}
		override public function dispose():void 
		{
			this.jsonurl = undefined;
			this.steps = NaN
			if ( this._ytTokenData != null) { this._ytTokenData.dispose(); }; this._ytTokenData = null;
			if ( this._ytAccessToken != null) { this._ytAccessToken.dispose(); }; this._ytAccessToken = null;
			super.dispose()
		}
		private function load_tokendata():void 
		{
			this._ytTokenData = new YoutubeTokenData(super.yt);
			this._ytTokenData.onerror = super.onerror
			this._ytTokenData.oncomplete = this.loaded_tokendata
			this._ytTokenData.build(this.jsonurl);
		}
		private function loaded_tokendata():void 
		{
			this.load_accessdata()
		}
		private function load_accessdata():void 
		{
			this._ytAccessToken = new YoutubeAccessToken(super.yt);
			this._ytAccessToken.onerror = super.onerror
			this._ytAccessToken.oncomplete = this.loaded_accessdata
			this._ytAccessToken.tokenData = this._ytTokenData.data;
			this._ytAccessToken.init();
		}
		private function loaded_accessdata(_accessToken:String):void 
		{
			if (super.oncomplete != null) { super.oncomplete(); }; super.oncomplete = null;
		}
	}

}