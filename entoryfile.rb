#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# entoryfile.rb
#
# Copyright(C) 2013-,peisunstar@gmail.com
# You can redistribute it and/or modify it under GPL2
#
require 'time'
require 'fileutils'
require 'cgi'

class TDiaryDir
  def initialize(path)
    if(path =~ /\/\/$/)
      path.chop!
    end
    @tdpath = path
  end
  def checkTdDir(date)
    chkdate = Time.new
    if(date.class == "string")
      chkdate = Time::parse(date)
    else
      chkdate = date
    end
    date_path = sprintf("%s/%s",@tdpath,chkdate.strftime("%Y/%m"))
    if(File.exists?(date_path)) then
      return true
    else
      return false
    end
  end
  def getTdDir(date)
    getdate = Time.new
    if(date.class == "string")
      getdate = Time::parse(date)
    else
      getdate = date
    end
    dir = sprintf("#{@tdpath}%s",getdate.strftime("%Y/%m"))
#    puts "dir:" + dir
    return dir
  end
  def makeTdDir(date)
    mkdate = Time.new
    if(date == "string")
      mkdate = Time::parse(date)
    else
      mkdate = date
    end
#    puts "#{@tdpath}#{mkdate.strftime("%Y/%m")}"
    FileUtils.mkdir_p(sprintf("%s/%s",@tdpath,mkdate.strftime("%Y/%m")))
  end
end

class TDiaryFile
  attr_reader :tdDir
  attr_reader :tddate
  attr_reader :tdfile
  def initialize(path)
    if(path =~ /\/\/$/)
      path.chop!
    end
    @tdDir = TDiaryDir.new(path)
    @tddate = nil
    @tdfile = nil
  end
  def putDate(date)
    if(@tddate != date)
      if(@tdfile != nil)
        @tdfile.close
      end
      if(@tdDir.checkTdDir(date) == false)
        @tdDir.makeTdDir(date)
      end
    end
    fname = sprintf("%s/%s.ctd",@tdDir.getTdDir(date),date.strftime("%Y%m%d"))
    @tdfile = File.open(fname,"w")
  end
  def putItemHeader(item)
    @tdfile.puts(item)
  end
  def putItemBody(body)
    @tdfile.puts(body)
  end
  def close
    @tdfile.close
    @tdfile = nil
    @tdDir = nil
  end
end
