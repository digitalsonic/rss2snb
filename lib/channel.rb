#--
# Copyright (c) 2010 DigitalSonic
#++

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

require 'convert_util'
require 'feed_item'

# Class for RSS Channel
class Channel
  include ConvertUtil
  attr_reader :url, :encode
  attr_reader :title, :link, :description, :date, :items

  def initialize url, max_items_count = 10, encode = 'UTF-8'
    @url, @encode = url, encode.upcase

    content = nil
    open(url) { |s| content = s.read }
    rss = RSS::Parser.parse content, false
    set_channel_info rss
    set_channel_items rss, max_items_count
  end

  def set_channel_info rss
    @title = encoding(html_to_txt(rss.channel.title), @encode)
    @link = rss.channel.link
    @description = encoding(html_to_txt(rss.channel.description), @encode)
    @date = rss.channel.date
  end

  def set_channel_items rss, count = 10
    @items = []
    (0...(count <= rss.items.size ? count : rss.items.size)).each do |idx|
      @items << FeedItem.new(rss.items[idx])
    end
  end
end
