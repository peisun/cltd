#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# cltd.rb
#
# Copyright(C) 2013-, Kenichi KTAZAWA <peisunstar@gmail.com>
# You can redistribute it and/or modify it under GPL2
#
$:.unshift(File.dirname(__FILE__))
config = ENV["HOME"] + "/.cltd.conf"
MissingOption = "sorry. missing option"
NoFoundConf = "sorry. no found config file."

require 'net/http'
require 'optparse'
require 'inifile.rb'
require 'changelog.rb'
require 'puttdiary.rb'

class Option
  @params 
  @days
  def initialize
    @params = { }
    @days = []
  end
  def optionParse
    opt = OptionParser.new
    opt.on("-c config file") { |v| @params[:c] = v }
    opt.on("-f changlog file") { |v| @params[:f] = v}
    opt.on("-l the lastest days",Integer) { |v| @params[:l] = v}
    opt.on("-d the date YYYY-MM-DD,..") { |v|
      @params[:d] = true
      @days << v
    }

    begin
      @params[:l] = 1
      #params = ARGV.getopts("c:l:t:d:")
      opt.parse!(ARGV)
      ARGV.each { |d|
        if(d =~ /\d\d\d\d-\d\d-\d\d/)
          @days << d
        end
      }

    rescue OptionParser::MissingArgument
      puts MissingOption
      opt.parse("-help")
      exit
    end
  end
  def print
    puts "optionParse:print>>"
    puts @params
    puts @days
    puts "<<"
  end
  def getlogfile
    return @params[:f]
  end
  def getconf
    return @params[:c]
  end
  def getLastest
    if(@params[:l] == false)
      return 1
    else
      return @params[:l]
    end
  end
  def getDays
    if(@params[:d] == true)
#      puts "@days"
      return @days
    else
#      puts "@days nil"
      return nil
    end
  end
end

params  = Option.new
params.optionParse()
#params.print
if(params.getconf() != nil)
  config = params.getconf
end
print("Config: ",config,"\n")

ini = IniFile.new(config)
if(ini == nil)
  puts NoFoundConf
  exit
end

if(params.getlogfile == nil)
  $log = ini.get(IniFile::Diary)
else
  $log = params.getlogfile
end
print("Diary: ",$log,"\n")

#puts params.print
chlg = Changelog.new
entory = chlg.load($log)

if(entory != nil)
  td = Puttdiary.new(ini.get(IniFile::Server))
  if(td.authorization(ini.get(IniFile::User)) != Net::HTTPOK)
    puts "認証できませんでした。"
    exit
  end
#  params.print
  if(params.getDays != nil)
    td.entory_post_days(entory,params.getDays)
  else
    td.entory_post_lastest(entory,params.getLastest)
  end
end

