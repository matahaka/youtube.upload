package com.mthk.youtube.data 
{
	/**
	 * ...
	 * @author mthk
	 */
	public class YoutubeTranslation 
	{
		public var Youtube_hl:String
		public var YoutubeVideoBrowser_getFile:String
		public var YoutubeVideoBrowser_getMetadata:String
		public var YoutubeTokenData_get:String
		public var YoutubeTokenData_set:String
		public var YoutubeAccessToken_get:String
		public var YoutubeAccessToken_set:String
		public var YoutubeUploadUrl_get:String
		public var YoutubeUploadUrl_set:String
		public var YoutubeUploadSend_upload:String
		public function YoutubeTranslation() 
		{
			this.Youtube_hl = 'pl_PL';
			this.YoutubeVideoBrowser_getFile = "Wybór pliku wideo"
			this.YoutubeVideoBrowser_getMetadata = 'Pobieranie informacji o pliku';
			this.YoutubeTokenData_get = 'Pobieranie pliku autoryzacji';
			this.YoutubeTokenData_set = 'Pobrano plik autoryzacji';
			this.YoutubeAccessToken_get = 'Łączenie z serwisem Youtube';
			this.YoutubeAccessToken_set = 'Połączono z serwisem Youtube';
			this.YoutubeUploadUrl_get = 'Pobieranie adresu wysyłki';
			this.YoutubeUploadUrl_set = 'Pobrano adres wysyłki';
			this.YoutubeUploadSend_upload = 'Wysyłanie pliku wideo do serwisu'
		}
		
	}

}