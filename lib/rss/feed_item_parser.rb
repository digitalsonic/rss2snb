#--
# Copyright (c) 2010 DigitalSonic
#++

require 'util'
require 'rss/feed_item'

module Rss
  # Default parser for feed item.
  class FeedItemParser
    include Util
  
    def initialize encode = 'UTF-8'
      @encode = encode
    end

    # Parse the given rss item.
    # if parse_desc == true, also parse the description;
    # or you can parse it later yourself.
    def parse rss_item, parse_desc = true
      item = FeedItem.new
      item.title = encoding(html_to_txt(rss_item.title), @encode)
      item.link = rss_item.link
      item.date =  rss_item.date
      item.description = parse_description rss_item if parse_desc
      item
    end

    def parse_description rss_item
      text_start, text_end = "<text><![CDATA[", "]]></text>"
      desc = encoding(html_to_txt(rss_item.description), @encode).strip.gsub("\n", "#{text_end}\n#{text_start}")
      text_start + desc + text_end
    end
  end
end