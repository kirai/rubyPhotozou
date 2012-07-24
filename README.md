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

基本の形は⬇
Photozou.method_name(arguments)

method_nameはhttp://photozou.jp/basic/apiの通りにないります。
argumentsはhttp://photozou.jp/basic/apiの客メゾッドの仕様通となります。

例：

  * キーワード検索：

          require 'photozouAPI.rb'
          args = { "keyword" => "tokyo" }
          response = Photozou.search_public(args)
          p response
     
