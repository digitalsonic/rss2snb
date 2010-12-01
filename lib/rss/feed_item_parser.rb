#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rubygems'
require 'nokogiri'
require 'util'
require 'rss/feed_item'
require 'image/multi_thread_downloader'

module Rss
  # Default parser for feed item.
  class FeedItemParser
    include Util
  
    def initialize temp_dir = ".", encode = 'UTF-8'
      @temp_dir, @encode = temp_dir, encode
    end

    # Parse the given rss item.
    # if parse_desc == true, also parse the description;
    # or you can parse it later yourself.
    def parse rss_item, parse_desc = true
      item = FeedItem.new
      item.title = encoding(html_to_txt(rss_item.title), @encode)
      item.link = rss_item.link
      item.date =  rss_item.date
      if parse_desc
        parsed = parse_html_and_download_images(Nokogiri::HTML(rss_item))
        html = parsed[:doc]
        images = parsed[:images]
      	item.description = parse_description html, images
      end
      item
    end

    def parse_description html, images
      text_start, text_end = "<text><![CDATA[", "]]></text>"
      desc = encoding(html_to_txt(html), @encode).strip
      images.each_with_index { |image, idx| desc = desc.gsub("#img[#{idx}]#", "<img width='#{image.width}' height='#{image.height}'>#{idx}.#{image.suffix}</img>") }
      desc = desc.gsub("\n", "#{text_end}\n#{text_start}")
      text_start + desc + text_end
    end
    
    def parse_html_and_download_images doc
      downloader = Image::MultiThreadDownloader.new
      index = 0
      doc.xpath("//img").each do |node|
        src = node['src']
        if src.downcase.include?(".png") || src.downcase.include?(".jpg")
          suffix = src.downcase.include?(".png") ? ".png" : ".jpg"
          downloader.start_download(src, "#{@temp_dir}/images/#{index}#{suffix}")
          node.replace(Nokogiri::XML::Node.new("<p>#img[#{index}]#</p>"))
        end
      end
      image_list = downloader.wait_util_finish
      {:doc => doc, :images => image_list}
    end
  end
end