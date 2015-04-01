package com.mthk.youtube.core {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author mthk
	 */
	public class YouTubeLoader extends URLLoader
	{
		public var onrecive:Function
		public var responseHeaders:Array
		public var responseStatus:int
		public var ontrace:Function
		public var onerror:Function;
		public var step:String
		private var timeout:uint
		private var timer:uint
		private var time:uint
		public var isopen:Boolean
		public var request:URLRequest
		protected var traceColor:uint
		protected var traceName:String
		public function YouTubeLoader(request:URLRequest=null) 
		{
			this.isopen = false;
			super(request);
			super.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, this._httpresponsestatus, false, 0, true);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._securityerror, false, 0, true);
			super.addEventListener(IOErrorEvent.IO_ERROR, this._ioerror, false, 0, true);
			super.addEventListener(Event.OPEN, this._open, false, 0, true);
		}
		private function _open(e:Event):void { 
			this.responseHeaders = null;
			this.isopen = true;
		};
		override public function close():void 
		{
			if (super.hasEventListener(Event.COMPLETE) == true) { super.removeEventListener(Event.COMPLETE, this._recive); };
			this.isopen = false
			super.close();
		}
		public function init():void 
		{
			clearTimeout(this.timeout); this.timeout = NaN;
			if (this.isopen == false) { this.load(this.request); }
			else {
				this.timeout = setTimeout(this.init, 1000);
			}
		}
		override public function load(request:URLRequest):void 
		{
			if (this.onrecive != null) { super.addEventListener(Event.COMPLETE, this._recive, false, 0, true); };
			try { super.load(request); } catch (e:Error) { if (this.onerror != null) { this.onerror(this.traceName+'.load error', '' + e); }; };
		}
		private function _recive(e:Event):void { 
			clearInterval(this.timer); this.timer = NaN;
			this.isopen = false;
			this.close();
			if (super.hasEventListener(Event.COMPLETE) == true) { super.removeEventListener(Event.COMPLETE, this._recive); };
			if (this.onrecive != null) { this.onrecive(e); };// this.onrecive = null;
		};
		private function _httpresponsestatus(e:HTTPStatusEvent):void 
		{ 
			this.responseStatus = e.status
			this.responseHeaders = e.responseHeaders
			e.stopImmediatePropagation(); e.stopPropagation(); e.preventDefault();
		};
		public function dispose():void 
		{
			if (super.hasEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS) == true) { super.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, this._httpresponsestatus); };
			if (super.hasEventListener(SecurityErrorEvent.SECURITY_ERROR) == true) { super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this._securityerror); };
			if (super.hasEventListener(IOErrorEvent.IO_ERROR) == true) { super.removeEventListener(IOErrorEvent.IO_ERROR, this._ioerror); };
			if (super.hasEventListener(Event.OPEN) == true) { super.removeEventListener(Event.OPEN, this._open); };
			this.step = undefined;
			clearTimeout(this.timeout); this.timeout = NaN;
			clearInterval(this.timer); this.timer = NaN;
			this.time = NaN;
			this.responseHeaders = null;
			this.responseStatus = NaN;
			this.request = null
			this.onrecive = null
			this.ontrace = null
			this.onerror = null
			if (this.isopen == true) { this.close(); }; this.isopen = undefined;
			this.traceColor = NaN;
			this.traceName = undefined
		}
		private function _securityerror( e:SecurityErrorEvent ):void {
			e.preventDefault(); e.stopImmediatePropagation(); e.stopPropagation();
			if (this.onerror!=null) { this.onerror('YouTubeLoader.security error', '' + e); };
		}
		private function _ioerror( e:IOErrorEvent ):void {
			e.preventDefault(); e.stopImmediatePropagation();e.stopPropagation();
			if (this.onerror!=null) { this.onerror('YouTubeLoader.io error', '' + e); };
		}
		private function _trace_headers( a:Array ):String {
			var tr:String = '';
			for (var $i:uint = 0; $i < a.length; $i++ ) {
				tr += '[' + URLRequestHeader(a[$i]).name+':' + URLRequestHeader(a[$i]).value+']';
			};$i = NaN; return tr;
		}
		//private function convertToHHMMSS($seconds:Number):String
		//{
			//var s:Number = $seconds % 60;
			//var m:Number = Math.floor(($seconds % 3600 ) / 60);
			//var h:Number = Math.floor($seconds / (60 * 60));
			//////////////////////////////////////////////////////////////////
			//var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
			//var minuteStr:String = doubleDigitFormat(m) + ":";
			//var secondsStr:String = doubleDigitFormat(s);
			//////////////////////////////////////////////////////////////////
			//return hourStr + minuteStr + secondsStr;
		//}
		//private function doubleDigitFormat($num:uint):String { if ($num < 10) { return ("0" + $num); }; return String($num); };
		/////////////////////////////////
	}

}