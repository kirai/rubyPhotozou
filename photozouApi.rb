# -*- coding: utf-8 -*-

require 'rubygems'
require 'open-uri'
require 'rexml/document'
require 'net/http'
require 'base64'
require 'pp'

Net::HTTP.version_1_2
AGENT = 'photozouapi.rb/ruby/#{RUBY_VERSION}'

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

