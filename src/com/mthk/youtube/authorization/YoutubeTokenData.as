package com.mthk.youtube.authorization {
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import com.mthk.youtube.core.YoutubeService;
	import com.mthk.youtube.Youtube;
	import com.mthk.youtube.data.YoutubeTranslation
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeTokenData extends YoutubeService
	{
		public var data:Object
		//public var name:String
		public function YoutubeTokenData(_yt:Youtube) 
		{
			super(_yt);
			//super.traceColor = 3;
			super.traceName = 'YoutubeTokenData';
		}
		public function build(_url:String):void 
		{
			if (this.data == null) {
				super.yt.request = new URLRequest(_url);
				super.yt.dataFormat = URLLoaderDataFormat.TEXT
				super.yt.onrecive = this._recive
				//super.yt.onprogress = super.onprogress;
				//if (super.onprogress != null) { super.onprogress(this.step, '0%', 'wczytuje dane'); };
				//super.yt.progress()
				//super.yt.step = this.step
				super.yt.progress(super.yt.vars.tr.YoutubeTokenData_get)
				super.yt.init();
			}else {
				this._return_json();
			}
		}
//////////
		override public function dispose():void 
		{
			//this.name = undefined;
			this.data = null;
			super.dispose();
		}
//////////
		private function _recive(e:Event):void 
		{
			//super.yt.close();
			//if (super.onprogress != null) { super.onprogress(this.step, Math.round(((1 / 2) * 100) / 2) + '%', this.name); };
			
			try { 
				this.data = JSON.parse(e.target.data);
				this._return_json();
			}
			catch (e:Error) { if (super.onerror != null) { super.onerror(super.traceName+'.parsejson', '' + e); }; }
			//////////
			//if (super.yt.hasEventListener(Event.COMPLETE) == true) { super.yt.removeEventListener(Event.ACTIVATE, this._recive); };
			
		}
//////////
		private function _return_json():void 
		{
			if (this.data != null) {
				this.data = this.data.installed;
				if (this.data != null) {
					if (super.oncomplete != null) { 
						super.yt.progress(super.yt.vars.tr.YoutubeTokenData_set)
						//if (super.onprogress != null) { super.onprogress(this.step,Math.round(((2/2)*100)/2)+'%', this.name); };
						//if (super.ontrace != null) { super.ontrace(super.traceColor, '[|]', super.traceName, '.oncomplete:' + JSON.stringify(this.data)) };
						super.oncomplete();
					};
				}
			}
			else  { 
				if (super.onerror!=null) { super.onerror(super.traceName+'._return_json', 'json==null'); };
			}
		}
//////////
	}

}