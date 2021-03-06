#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# changlog.rb
#
# Copyright(C) 2013-, Kenichi KTAZAWA <peisunstar@gmail.com>
# You can redistribute it and/or modify it under GPL2
#
$:.unshift(File.dirname(__FILE__))

require 'time'
require 'fileutils'
require 'net/http'
require 'cgi'
require 'io/console'
require 'entory.rb'


class Puttdiary
  POST_ERROR_MSG="postできませんでした。"
  POST_OK = 200
  POST_NG = 400
  AUTH_OK = 300
  AUTH_NG = 500
  @server = nil
  @user = nil
  @auth = nil
  @cgi=nil
  def initialize(srvr)
    @server = srvr
  end
  def authorization(usr)
    @csrf_protection_key = nil
    @user = usr
    puts "tDiary URL = " + @server
    puts "User ID = " + @user
    print "Please passwd:".gsub(/\n/,'')
    @passwd = STDIN.noecho(&:gets)
    @passwd.gsub!(/\n/,'')
    puts ""

    @auth = ["#{@user}:#{@passwd}"].pack('m').gsub(/\n/,'')

    Net::HTTP.version_1_2
    url = URI.parse(@server)


    res = Net::HTTP.start(url.host,url.port){ |http|
      req = Net::HTTP::Get.new(url.path)
      req.basic_auth(@user,@passwd)
      res = http.request(req)

      # csrf_protection_keyの抽出
      if(%r!<input type="hidden" name="csrf_protection_key" value="([^"]+)"! =~ res.body)
        @csrf_protection_key = $1
      else
#        puts "Not able to pickup csrf_protection_key"
#        puts "#{res.code}: #{res.message}"
      end
#      puts res.body
#      puts res.class
        return res.class
    }
  end
  def entory_post_lastest(entory,lastest_day)
    Net::HTTP.version_1_2
    url = URI.parse(@server)
    res = Net::HTTP.start(url.host,url.port){ |http|
      (1..lastest_day).each do
        if((e = entory.shift) == nil) 
          return 
        end
        if(post(http,e) == POST_OK)
          puts "posted lastest #{e.entory_date_strftime("%Y-%m-%d")}"
        else
          puts POST_ERROR_MSG
          return
        end

      end
    }
  end
  def entory_post_days(entory,days)
    Net::HTTP.version_1_2
    url = URI.parse(@server)
    res = Net::HTTP.start(url.host,url.port){ |http|
      entory.each { |e|
        days.each { |d|
          if(e.entory_date_strftime("%Y-%m-%d") == d)
            if(post(http,e) == POST_OK)
              puts "posted day #{e.entory_date_strftime("%Y-%m-%d")}"
            else
              puts POST_ERROR_MSG
              return
            end
        end
        }
      }
    }


  end
  def post(http,e)
    data = "&old="
    data << e.entory_date
    if(@csrf_protection_key != nil)
      data << "&csrf_protection_key=#{CGI::escape( CGI::unescapeHTML(@csrf_protection_key))}"
    end
    data << "&year=#{e.year}"
    data << "&month=#{e.month}"
    data << "&day=#{e.day}"
    data << "&body=#{CGI::escape( CGI::unescapeHTML(e.body ))}"
    data << "&replace=+%E7%99%BB%E9%8C%B2+"
    data << "&makerss_update=true"

    #    puts data
    res = http.post( @server,data,
                     'Authorization' => "Basic #{@auth}",
                     'Referer' => "#{@server}")
    
#        puts res.body
    if(res.class == Net::HTTPOK)
      return POST_OK
    else
      puts "#{res.code}: #{res.message}"
      return POST_NG
    end

  end
end
