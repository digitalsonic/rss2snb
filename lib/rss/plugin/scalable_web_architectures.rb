#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rss/plugin/feedproxy'

module Rss
  module Plugin
    # Plugin to fetch content from http://www.royans.net/arch .
    class ScalableWebArchitectures < Feedproxy
      def post_process content
        node = Nokogiri::HTML(content)
        node.xpath('//div[@class="translate_block"]').first.remove
        node.xpath('//div[@class="sociable"]').first.remove
        node.xpath('//div[@class="entry"]').first.to_html
      end
    end
  end
end
