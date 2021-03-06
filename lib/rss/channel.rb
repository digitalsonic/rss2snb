#--
# Copyright (c) 2010 DigitalSonic
#++

require 'rss/1.0'
require 'rss/2.0'
require 'rss/dublincore'
require 'net/http'
require 'uri'

require 'util'
require 'rss/feed_item_parser'

module Rss
  # Class for RSS Channel
  class Channel
    include Util
    attr_reader :url, :title, :link, :description, :date, :copyright, :language, :items

    def initialize url, max_items_count, item_parser, proxy = Net::HTTP
      @url= url
      @proxy = proxy

      content = read_channel url
      rss = RSS::Parser.parse content, false
      set_channel_info rss
      set_channel_items rss, item_parser, max_items_count unless item_parser.nil?
    end

    def read_channel uri
      content = nil
      url = URI.parse(uri)
      @proxy.start(url.host, url.port) do |http|
        path = url.path
        path += "?#{url.query}" unless url.query.nil?
        response = http.get(path)
        case response
        when Net::HTTPSuccess then content = response.body
        when Net::HTTPRedirection, Net::HTTPFound then content = read_channel(response['location'])
        else raise Exception.new "Fail to fetch RSS #{url}!"
	end
        log_info "Successed reading RSS channel #{uri}"
      end
      content
    end

    def set_channel_info rss
      @title = encoding(html_to_txt(rss.channel.title))
      @link = rss.channel.link
      @description = encoding(html_to_txt(rss.channel.description))
      @date = rss.channel.date if rss.channel.respond_to?(:date)
      @date = rss.channel.dc_date if rss.channel.respond_to?(:dc_date)
      @copyright = rss.channel.respond_to?(:copyright) ? encoding(html_to_txt(rss.channel.copyright)) : nil
      @language = rss.channel.respond_to?(:language) ? rss.channel.language : 'zh-CN'
    end

    def set_channel_items rss, item_parser, count = 10
      @items = []
      (0...(count <= rss.items.size ? count : rss.items.size)).each do |idx|
        begin
          @items << item_parser.parse(rss.items[idx], idx, @proxy)
        rescue Exception => e
          log_error "Can't parse #{rss.items[idx].link}, skipped. Message: #{e.message}"
	  log_debug e
        end
      end
    end
  end
end
