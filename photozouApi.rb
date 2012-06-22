# -*- coding: utf-8 -*-

#
# TODO 改善: http://d.hatena.ne.jp/kitamomonga/20080314/openuriwith304
#

require 'rubygems'
require 'open-uri'
require 'uri'
require 'nokogiri'

AGENT = 'photozouapi.rb/ruby/#{RUBY_VERSION}'
USERID = '2507715'
API_URI_BASE = 'http://api.photozou.jp/rest/'

USER   = ''
PASSWD = ''

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
    if endpointName == 'photo_add' || 
       endpointName == 'nop'
      return true
    else
      return false
    end
  end
end

class Photozou

  def self.callApi(endpointName, args)
    begin
      uri = API_URI_BASE + endpointName + "?" + PhotozouHelper.hashToHttpStr(args)

      if PhotozouHelper.needsAutentification(endpointName)
        return Nokogiri::XML open(uri, {:http_basic_authentication => [USER, PASSWD], 
                                     "User-Agent" => AGENT}) 
      else
        return Nokogiri::XML open(uri, "User-Agent" => AGENT)
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
    if response
      response.at_xpath("//rsp//info//user").children.inject({}) {|h, e| h[e.name.to_sym] = e.text if e.name != 'text'; h}
    end
  end

  # Endpoint: http://api.photozou.jp/rest/photo_info
  # 概要: インターネットに公開されている写真の詳細情報を取得します。
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET/POST

  def self.photo_info args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)
    if response
      response.at_xpath("//rsp//info//photo").children.inject({}) {|h, e| h[e.name.to_sym] = e.text; h}
    end  
  end

  # Endpoint: http://api.photozou.jp/rest/photo_list_public  
  # 概要: インターネットに公開されている写真の一覧を取得します
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET

  def self.photo_list_public args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)     
     
    photos = []
    response.at_xpath("//rsp//info").children.each do |x|
      photo = x.at_xpath("//photo").children.inject({}) {|h, e| h[e.name.to_sym] = e.text; h}
      photos << photo
    end
    photos
  end

  # Endpoint: http://api.photozou.jp/rest/search_public  
  # 概要: インターネットに公開されている写真を検索します。
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET/POST

  def self.search_public args
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, args)     
        
    photos = []
    response.at_xpath("//rsp//info").children.each do |x|
      photo = x.at_xpath("//photo").children.inject({}) {|h, e| h[e.name.to_sym] = e.text; h}
      photos << photo
    end
    photos
  end


  # Endpoint: http://api.photozou.jp/rest/photo_add  
  # 概要: 写真を追加します。
  #       データはPOSTメソッドでContent-Typeをすべて小文字で設定して
  #       送信する必要があります。データの最大サイズは、写真10MBです。
  # 認証: このメソッドは、認証が必要です。
  # HTTPメソッド: POST

  def self.photo_add args
    
    return false 
  end


  # Endpoint: http://api.photozou.jp/rest/nop  
  # 概要: 何もしません。ユーザー認証のテストをしたい時に使用して下さい。
  # 認証: 認証の必要が必要です。
  # HTTPメソッド: GET/POST

  def self.nop
    response = Photozou.callApi(PhotozouHelper.getCurrentMethodName, {})         
    
    if response.at_xpath("//rsp//info/user_id")
      return response.at_xpath("//rsp//info/user_id").children  
    else
      return false
    end
  end
  
end


#$photozouApiLambda = lambda { |methodName, q| doHttpRequest(q, methodName)}

#$photozouApiLambdaHash = { 'user_info'         => lambda { |q| doHttpRequest(q, 'user_info')},
#                           'photo_list_public' => lambda { |q| doHttpRequest(q, 'photo_list_public')}}



