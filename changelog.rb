#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# changlog.rb
#
# Copyright(C) 2013-, Kenichi KTAZAWA <peisunstar@gmail.com>
# You can redistribute it and/or modify it under GPL2
#
$:.unshift(File.dirname(__FILE__))
require 'pathname'
require 'entory.rb'

class Changelog
  @entory = nil
  def load(changelog_file)
#    puts Pathname(changelog_file).expand_path
    @entory = Array.new
    e = nil
    begin
      file = open(Pathname(changelog_file).expand_path)
      file.each_line { |line|
      if(line =~ Entory::CHLOG_DATE_FORMAT)
        e = Entory.new()
        e.date(line.slice(Entory::CHLOG_DATE_FORMAT))
        @entory << e
#        puts e.entory_date
      else
        e.entory(line)
      end
      }

    rescue
      puts "Can't open Diary file."
      return nil
    end
    return @entory
  end
end

