#--
# Copyright (c) 2010 DigitalSonic
#++

module Rss
  # Class for Item of RSS Channel.
  # It can be parsed by a FeedItemParser.
  class FeedItem
    attr_accessor :title, :link, :description, :date
  end
end