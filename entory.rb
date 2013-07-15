#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# entory.rb
#
# Copyright(C) 2013-, peisunstar@gmail.com
# You can redistribute it and/or modify it under GPL2
#
$:.unshift(File.dirname(__FILE__))

require 'time'
require 'fileutils'
require 'item.rb'

class Entory
  attr_reader :entory_date
  attr_reader :item
  attr_reader :i
  CHLOG_DATE_FORMAT = /^\d\d\d\d-\d\d-\d\d/
  CHLOG_HEADER_FORMAT = /^\s*\*/
  @entory_date = nil
  @item = nil
  @i = nil
  def date(d)
    @entory_date = Time::parse(d.slice(CHLOG_DATE_FORMAT))
    @item = Array.new
  end
  def entory(line)
    if(line =~ CHLOG_HEADER_FORMAT)
      @i = Item.new(line)
      @item.push(@i)
    else
      if(@i != nil)
        @i.add(line)
      end
    end
  end
  def entory_date_strftime(fmt)
    return @entory_date.strftime(fmt)
  end
  def entory_date
    return @entory_date.strftime("%Y%m%d")
  end
  def year
    return @entory_date.strftime("%Y")
  end
  def month
    return @entory_date.strftime("%m")
  end
  def day
    return @entory_date.strftime("%d")
  end
  def body
    body_line = ""
    @item.each { |i|
#      puts i.get
      body_line << i.get
    }
    return body_line
  end
  def print
    puts @entory_date.strftime("%Y-%m-%d")
    @item.each{ |i|
      i.print
    }
  end
end
