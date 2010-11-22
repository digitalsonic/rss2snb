#--
# Copyright (c) 2010 DigitalSonic
#++
require 'convert_util'

# Class for Item of RSS Channel
class FeedItem
  include ConvertUtil
  
  attr_reader :encode
  attr_reader :title, :link, :description, :date

  def initialize rss_item, encode = 'UTF-8'
    @encode = encode
    @title = encoding(html_to_txt(rss_item.title), @encode)
    @link = rss_item.link
    @description = encoding(html_to_txt(rss_item.description), @encode)
    @date = rss_item.date
  end
end
