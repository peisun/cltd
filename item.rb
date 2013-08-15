#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# item.rb
#
# Copyright(C) 2013-, peisunstar@gmail.com
# You can redistribute it and/or modify it under GPL2
#
require 'time'
require 'fileutils'


class Item
  CITATION_ON = 1
  CITATION_OFF = 0
  CITATION_SRC= /^\s*\[src\]/
  UNCITATION_SRC = /^\s*\[\/src\]/
  CITATION_DOUBLE_GREATER = /^\s*>>/
  UNCITATION_DOUBLE_GREATER = /^\s*<</
  CITATION_GREATER_THAN = /^\s*>\s*/
  CARRIAGE_RETURN = /^\s*$/
  ITEMIZE = /^\s*-\s*/
  PLG_AMAZON=/^\s*amazon\:\s*\d*-\d*/
#  PLG_DETAIL="{{isbn_detail #{isdn} }}\n"

  HEADER = "header: "
  BODY = "body: "
  attr_reader :header
  attr_reader :body
  @header = nil
  @body = nil
  @quo = CITATION_OFF
  def initialize(item_header)
    @quo = CITATION_OFF
    @header = nil
    @body = nil
    i_header(item_header)
  end
  def i_header(ih)
    @header = ih
  end
  def add(item)
    if(@body == nil)
      @body = String::new(item)
    else
      @body << item
    end
  end
  TITLE_REGREXP = /^\s*\*\s*/
  TITLE_GSUB = "!"
  def get
    item = @header.gsub(TITLE_REGREXP,TITLE_GSUB)
    @body.each_line { |l|
      item << citation(l)
    }
    return item
  end
  def print
    puts @header
    if(@body != nil)
      @body.each { |l|
        puts l
      }
    end
  end
  def isQuo
    return @quo
  end
  def citation(line)
#    if(line =~ /^\s*$/)
#      line.gsub!(/^\s*$/,"\n\n")
    if((line =~ CITATION_SRC) || (line =~CITATION_DOUBLE_GREATER) ) then
      @quo = CITATION_ON
      line = "\n"
      return line
    elsif((line =~ UNCITATION_SRC) || (line =~ UNCITATION_DOUBLE_GREATER)) then
      @quo = CITATION_OFF
      line = "\n"
      return line
    end
    if(@quo == CITATION_ON)
      line.gsub!(/^\s*/,"\t")
      return line
    end
    if(line =~ CITATION_GREATER_THAN)
      line.gsub!(/^\s*>\s*/,"\t")
      return line
    elsif(line =~ CARRIAGE_RETURN)
      line.gsub!(CARRIAGE_RETURN,"\n")
      return line
    elsif(line =~ ITEMIZE)
      line.gsub!(ITEMIZE,"*")
      return line
    elsif(line =~ PLG_AMAZON)
      line.chop!.slice(/:/)
      isdn = $'
      line = "{{isbn_detail \"#{isdn}\"}}\n"
      return line
    else
      line.gsub!(/^\s*/,"")
    end
    return line
  end
end
