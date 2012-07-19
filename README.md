rubyPhotozou
============

Photozou API interface written in Ruby

http://photozou.jp/basic/api

フォト蔵APIは、メソッドごとにURLが決まっていて、
それぞれのURLに対してHTTP GET/POSTリクエストを使用してアクセスします。 
メソッドによっては、HTTP POSTリクエストしか受けないメソッドがあります。

ころRuby wrapperを利用するとPOSTかGETを気にしなくてもいいです。

## settings.yaml設定

サンプルsettings.yaml⬇
    api_testing:
     user_id: ''
     photo_id: ''
     album_id: ''
     needs_basic_auth_for_all_requests: FALSE 
    photozou:
     api_uri_base: 'http://api.photozou.jp/rest/'
     user: ''
     passwd: ''

## Rubyからの使いかた

