#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rss/plugin/feedproxy'

module Rss
  module Plugin
    # Plugin to fetch content from http://nosql.mypopescu.com .
    class MyNoSql < Feedproxy
      def post_process content
        Nokogiri::HTML(content).xpath('//div[contains(@class,"entrybody")]').first.to_html
      end
    end
  end
end
