#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'
require 'rss/plugin/feedproxy'

module Rss
  module Plugin
    # Fetch content from highscalability.com
    class HighScalability < Feedproxy
      def get_path url
        url.path + "?printerFriendly=true"
      end

      def post_process content
        node = Nokogiri::HTML(content)
        node.xpath('//head').each { |n| n.remove }
        node.xpath('//div').first.remove
        node.to_html
      end
    end
  end
end
