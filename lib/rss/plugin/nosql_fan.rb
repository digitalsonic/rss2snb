#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rss/plugin/feedproxy'

module Rss
  module Plugin
    # Plugin to fetch content from http://blog.nosqlfan.com/ .
    class NosqlFan < Feedproxy
      def post_process content
        node = Nokogiri::HTML(content)
	node.xpath('//div[@class="postauthor"]').first.remove
	node.xpath('//script').first.remove
	node.xpath('//span[@class="addthis_org_cn"]').first.remove
	node.xpath('//div[@class="singlepostmeta"]').first.remove
	node.xpath('//div[@class="postarea"]').first.to_html
      end
    end
  end
end


