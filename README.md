# youtube.upload
YouTube Data API (v3) upload

# Usage  
    
    var yt = new Youtube("http://your.url/yt.json");
        yt.onerror = function (_from:String,_msg:String):void{};
        yt.onprogress = function(_msg:String):void{};
        yt.oncomplete = function():void {  };
        yt.max15min = true;
        yt.browse();
        
        yt.log.videoData.id - store YouTube video id
        https://www.youtube.com/watch?v={yt.log.videoData.id}
# yt.json

    {
        "installed":
        {
            "refresh_token":"your refresh_token",
            "auth_uri":"https://accounts.google.com/o/oauth2/auth",
            "client_secret":"your client_secret",
            "token_uri":"https://accounts.google.com/o/oauth2/token",
            "client_email":"",
            "redirect_uris":["your redirect_uri","your redirect_uri"],
            "client_x509_cert_url":"",
            "client_id":"your client_id",
            "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs"
        }
    }
