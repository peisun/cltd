#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#require 'fileutils'
class IniFile
  Server = "server"
  User = "user"
  Diary = "diary"
  def initialize(inifile)
    @ini = Hash.new()
    begin
      file = File.open(inifile)
      File.open(inifile){  file
        while line = file.gets.chop.gsub(/\s/,"")

          item = line.split(/\=/)

          if(item[0] =~ /#{Server}/)
            @ini[Server] = item[1]
          elsif(item[0] =~ /#{User}/)
            @ini[User] = item[1]
          elsif(item[0] =~ /#{Diary}/)
            @ini[Diary] = item[1]
          end
        end
      }
      p @ini
    rescue
      return nil
    end

  end
  def get(key)
    return @ini[key]
  end
end



