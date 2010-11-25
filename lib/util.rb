#--
# Copyright (c) 2010 DigitalSonic
#++
require 'iconv'
require 'rubygems'
require 'nokogiri'

module Util
  def html_to_txt html
    Nokogiri::HTML(html).text
  end

  def encoding str, from = 'UTF-8', to = 'UTF-8'
    from == to ? str : Iconv.iconv(to, from, str).to_s
  end

  def write_to_file path, content
    file = File.open(path, 'wb')
    file << content
    file.close
  end
end
