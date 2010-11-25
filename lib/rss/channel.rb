#--
# Copyright (c) 2010 DigitalSonic
#++

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

require 'util'
require 'rss/feed_item_parser'

module Rss
  # Class for RSS Channel
  class Channel
    include Util
    attr_reader :url
    attr_reader :title, :link, :description, :date, :copyright, :language, :items

    def initialize url, max_items_count = 10, item_parser = nil
      @url = url

      content = nil
      open(url) { |s| content = s.read }
      rss = RSS::Parser.parse content, false
      set_channel_info rss
      set_channel_items rss, max_items_count, item_parser
    end

    def set_channel_info rss
      @title = encoding(html_to_txt(rss.channel.title))
      @link = rss.channel.link
      @description = encoding(html_to_txt(rss.channel.description))
      @date = rss.channel.date
      @copyright = encoding(html_to_txt(rss.channel.copyright))
      @language = rss.channel.language || 'zh-CN'
    end

    def set_channel_items rss, count = 10, item_parser = nil
      @items = []
      item_parser ||= FeedItemParser.new
      (0...(count <= rss.items.size ? count : rss.items.size)).each do |idx|
        @items << item_parser.parse(rss.items[idx])
      end
    end
  end
end
