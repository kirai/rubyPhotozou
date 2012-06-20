# -*- coding: utf-8 -*-

require 'rubygems'
require 'open-uri'
require 'net/http'
require 'base64'
require 'pp'
require 'uri'
require 'nokogiri'

Net::HTTP.version_1_2
AGENT = 'photozouapi.rb/ruby/#{RUBY_VERSION}'
USERID = '2507715'
API_URI_BASE = 'http://api.photozou.jp/rest/'

class PhotozouHelper
  def self.hashToHttpStr hash
    return hash.map{ |k,v| "#{k.to_s}=#{v}"}.join("&")
  end
end

class Photozou
  def self.user_info args
    begin
      response = Nokogiri::XML open(API_URI_BASE + "user_info?user_id=#{args[:user_id]}", 
                                    "User-Agent" => AGENT)
    rescue
       return false
    end

    response.at_xpath("//rsp//info//user").children.inject({}) {|h, e| h[e.name.to_sym] = e.text if e.name != 'text'; h}
  end

  def self.photo_info args
     response = Nokogiri::XML open(API_URI_BASE + "photo_info?photo_id=#{args[:photo_id]}",
                                   "User-Agent" => AGENT)
     response.at_xpath("//rsp//info//photo").children.inject({}) {|h, e| h[e.name.to_sym] = e.text; h}
  end

  # Endpoint: http://api.photozou.jp/rest/photo_list_public  
  # 概要: インターネットに公開されている写真の一覧を取得します
  # 認証: 認証の必要はありません。
  # HTTPメソッド: GET

  def self.photo_list_public args
     response = Nokogiri::XML open(API_URI_BASE + "photo_list_public?" + PhotozouHelper.hashToHttpStr(args),
                                   "User-Agent" => AGENT)
     photos = []
     response.at_xpath("//rsp//info").children.each do |x|
        photo = x.at_xpath("//photo").children.inject({}) {|h, e| h[e.name.to_sym] = e.text; h}
        photos << photo
     end
     photos
  end

end

def query_to_uri(hash)
  return hash.map{ |k,v| "#{k.to_s}=#{v}"}.join("&") 
end

def doHttpRequest(q, type)
  uri = URI.parse(API_URI_BASE + type +"?#{query_to_uri(q)}")
  req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
  begin
    Net::HTTP.start(uri.host){ |http|
      response = http.request(req)
      return response.body
    }
  rescue Timeout::Error => e
    return nil
  end
end

#
# Photozou Wrapper Class
#
class PhotozouB
  def generic_call(q, type)
    response = doHttpRequest(q, type)
    return response
  end

  def getCurrentMethodName
   caller[0][/`([^']*)'/, 1]
  end

  # Photozou API Methods
  def photo_info(q)
    return self.generic_call(q, self.getCurrentMethodName)
  end

  def photo_list_public(q)
    return self.generic_call(q,self.getCurrentMethodName)
  end
 
  def user_info(q)
    return self.generic_call(q, self.getCurrentMethodName)
  end

end

$photozouApiLambda = lambda { |methodName, q| doHttpRequest(q, methodName)}

$photozouApiLambdaHash = { 'user_info'         => lambda { |q| doHttpRequest(q, 'user_info')},
                           'photo_list_public' => lambda { |q| doHttpRequest(q, 'photo_list_public')}}


#q = { "user_id" => USERID }
#$user_info = lambda { |q| doHttpRequest(q, caller[0][/`([^']*)'/, 1])}
#puts user_info.call(q)

