#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rss/plugin/feedproxy'

module Rss
  module Plugin
    # Plugin to fetch content from http://blog.springsource.com .
    class SpringsourceTeamBlog < Feedproxy
      def get_path url
        url.path
      end

      def post_process content
        Nokogiri::HTML(content).xpath('//div[@id="lead"]').first.to_html
      end
    end
  end
end

