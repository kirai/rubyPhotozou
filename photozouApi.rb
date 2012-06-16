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

# photo_infoで遊んでみる

def readPhotozou
  begin
    src = open("http://photozou.jp/feed/photo_list/2507715/all.xml",
               "User-Agent" => AGENT) {|f| f.read }
  rescue
    return $false
  end
  
  doc = REXML::Document::new(src).root
  if doc.nil?
    return $false
  end
  doc.elements.to_a('//item').reverse.each {|item|
    if (item.nil? || item.elements['link'].nil? || item.elements['link'].text.nil?)
      next
    end
    if /.*\/(.*)$/ =~ item.elements['link'].text
      id = $1
      begin
        photo_src = open("http://api.photozou.jp/rest/photo_info?photo_id=#{id}") {|f| f.read }
      rescue
        return $false
      end
      
      photo = REXML::Document::new(photo_src).root
      if photo.nil?
        return $false
      end
      puts(photo.elements.to_a('//original_image_url')[0].text)
    end
  }
end

if !readPhotozou
  puts "error"
end

def query_to_uri(hash)
  return hash.map{ |k,v| "#{k.to_s}=#{v}"}.join("&") 
end

def doHttpRequest(q,type)
  uri = URI.parse(API_URI_BASE + type +"?#{query_to_uri(q)}")
  req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")

  Net::HTTP.start(uri.host){ |http|
    response = http.request(req)
    puts response.body
  }
end

# photo_listで遊んでみる！
q = { "type" => "album", "user_id" => USERID, "album_id" => '6712980', "limit" => 5 }
#doHttpRequest(q, 'photo_list_public')

# photo_infoで遊んでみる

q = { "photo_id" => 139348548 }
#doHttpRequest(q, 'photo_info')

#
# Photozou Wrapper Class
#
class Photozou
  def photo_list(q, type)
    doHttpRequest(q, type)
  end
end

