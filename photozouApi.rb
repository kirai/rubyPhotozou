# -*- coding: utf-8 -*-

require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'net/http'
require 'base64'
require 'pp'
require "uri"

Net::HTTP.version_1_2
AGENT = 'photozouapi.rb/ruby/#{RUBY_VERSION}'
USERID = '2507715'
API_URI_BASE = 'http://api.photozou.jp/rest/'

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
class Photozou
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

