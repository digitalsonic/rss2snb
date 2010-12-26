#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rss/plugin/high_scalability'

module Rss
  module Plugin
    # Plugin to fetch content from http://nosql.mypopescu.com .
    class MyNoSql < HighScalability
      def get_path url
        url.path
      end
      
      def post_process content
        Nokogiri::HTML(content).xpath('//div[contains(@class,"entrybody")]').first.to_html
      end
    end
  end
end
