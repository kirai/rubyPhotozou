# -*- coding: utf-8 -*-
#
# TODO 改善 cache 304: http://d.hatena.ne.jp/kitamomonga/20080314/openuriwith304
# Inspire: http://rbc-incubator.googlecode.com/svn/jmurabe/plugins/trunk/photozou_api_helper/lib/photozou_api.rb
# Inspire Python: http://weboo-returns.com/blog/photozou-api-library-for-python/

require 'rubygems'
require 'open-uri'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'rest_client'
require 'net/http/post/multipart'
require 'pp'
require 'active_support/dependencies'
require 'active_support'
require 'active_support/core_ext'
require 'yaml'

Net::HTTP.version_1_2
AGENT = 'photozouapi.rb/ruby/#{RUBY_VERSION}'

begin
  settings = YAML::load_file('../settings.yaml')
rescue Exception => e
  puts "Could not parse YAML: #{e.message}"
  exit
end

USERID = settings['api_testing']['user_id'] 
PHOTOID = settings['api_testing']['photo_id'] 
ALBUMID = settings['api_testing']['album_id']
NEEDS_BASIC_AUTH_FOR_ALL_REQUESTS = settings['api_testing']['needs_basic_auth_for_all_requests'] 

API_URI_BASE =  settings['photozou']['api_uri_base']
USER = settings['photozou']['user']
PASSWD = settings['photozou']['passwd']

class PhotozouHelper
  def self.hashToHttpStr hash
    return hash.map{ |k,v| "#{k.to_s}=#{v}"}.join("&")
  end

  def self.getCurrentMethodName
   caller[0][/`([^']*)'/, 1]
  end
  
  def self.printError(type, args, error)
     puts 'Error while trying to use:' + type 
     puts 'with parameters ' + args
     puts error
  end

  def self.needsAutentification(endpointName)
    if endpointName == 'photo_add'
      return true
    else
      return false
    end
  end

end

class Photozou

  def self.callApi(endpointName, args)
    #TODO: handle the correct content_types for the photo upload
    #画像をアップロードする場合は、次のいずれかを指定します。
    #image/gif
    #image/jpeg
    #image/pjpeg
    #image/png
    #image/x-png http://d.hatena.ne.jp/hygeta/20111105/1320494187
    begin
      if PhotozouHelper.needsAutentification(endpointName) # POST Requests
        uri    = API_URI_BASE + endpointName
        params = args
        
        url = URI.parse(uri)
        File.open(args['photo'], "rb") do |jpg|
          req = Net::HTTP::Post::Multipart.new(url.path, {"photo" => UploadIO.new(jpg, "image/jpeg", args['photo']), "album_id" => args['album_id']})
          req.basic_auth USER, PASSWD
          res = Net::HTTP.start(url.host, url.port) do |http|
            http.request(req)
          end
                 
          case res
            when Net::HTTPSuccess, Net::HTTPRedirectionspec/photozouApi_spec.rb
              return Nokogiri::XML(res.body)
            else
              res.value  # TODO Handle response Error codes http://jp.rubyist.net/magazine/?0013-BundledLibraries
          end
        end

#       Basic autentification for a GET request (Works for "nop"
#        return Nokogiri::XML open(uri, {:http_basic_authentication => [USER, PASSWD], 
#                                        "User-Agent" => AGENT}) 
      
      else # GET Requests
        uri = API_URI_BASE + endpointName + "?" + PhotozouHelper.hashToHttpStr(args)
        
        if NEEDS_BASIC_AUTH_FOR_ALL_REQUESTS
          return Nokogiri::XML open(uri, {:http_basic_authentication => [USER, PASSWD], 
                                          "User-Agent" => AGENT})
        else
          return Nokogiri::XML open(uri, "User-Agent" => AGENT)
        end
      end
    rescue OpenURI::HTTPError => error
      PhotozouHelper.printError(endpointName, PhotozouHelper.hashToHttpStr(args), error)
      return false
    rescue Timeout::Error => error
      PhotozouHelper.printError(endpointName, PhotozouHelper.hashToHttpStr(args), error)
      return false
    end
  end

  # Endpoint: http://api.photozou.jp/rest/user_info
  # 概要: インターネットに公開されている写真の詳細情報を取得します。
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET/POST

  def self.user_info args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)
    return Hash.from_xml(response.to_s)
  end

  # Endpoint: http://api.photozou.jp/rest/photo_info
  # 概要: インターネットに公開されている写真の詳細情報を取得します。
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET/POST

  def self.photo_info args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)
    return Hash.from_xml(response.to_s)
  end

  # Endpoint: http://api.photozou.jp/rest/photo_list_public  
  # 概要: インターネットに公開されている写真の一覧を取得します
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET

  def self.photo_list_public args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)     
    return Hash.from_xml(response.to_s)
  end

  # Endpoint: http://api.photozou.jp/rest/search_public  
  # 概要: インターネットに公開されている写真を検索します。
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET/POST

  def self.search_public args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)     
    return Hash.from_xml(response.to_s)    
  end

  # Endpoint: http://api.photozou.jp/rest/photo_add  
  # 概要: 写真を追加します。
  #       データはPOSTメソッドでContent-Typeをすべて小文字で設定して
  #       送信する必要があります。データの最大サイズは、写真10MBです。
  # 認証: このメソッドは、認証が必要です。
  # HTTPメソッド: POST
  # CURL: curl -X POST --user username:password 
  #       -F "album_id=アルバムID" -F "photo=@photo.jpg" 
  #       http://api.photozou.jp/rest/photo_add

  def self.photo_add args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args) 
    return Hash.from_xml(response.to_s) 
  end

  # Endpoint: http://api.photozou.jp/rest/nop  
  # 概要: 何もしません。ユーザー認証のテストをしたい時に使用して下さい。
  # 認証: 認証の必要が必要です。
  # HTTPメソッド: GET/POST

  def self.nop
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, {})         
    return Hash.from_xml(response.to_s)
  end

  # Endpoint: http://api.photozou.jp/rest/user_group  
  # 概要: 友達グループの一覧を取得します。
  # 認証: 認証の必要が必要です。
  # HTTPメソッド: GET/POST

  def self.user_group
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, {})         
    return Hash.from_xml(response.to_s)
  end
  
end
