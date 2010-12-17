#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rubygems'
require 'nokogiri'
require 'util'
require 'rss/feed_item'
require 'rss/plugin/default_content_plugin'
require 'rss/plugin/info_q'
require 'image/multi_thread_downloader'

module Rss
  # Default parser for feed item.
  class FeedItemParser
    include Util

    def initialize base_dir = ".", index = "", plugins = Hash.new, encode = 'UTF-8'
      @base_dir, @index, @plugins, @encode = base_dir, index, plugins, encode
    end

    # Parse the given rss item.
    # if parse_desc == true, also parse the description;
    # or you can parse it later yourself.
    def parse rss_item, index, proxy = nil, parse_desc = true
      item = FeedItem.new
      item.title = encoding(html_to_txt(rss_item.title), @encode)
      item.link = rss_item.link
      item.date = rss_item.date if rss_item.respond_to?(:date)
      item.date = rss_item.dc_date if rss_item.respond_to?(:dc_date)
      if parse_desc
        plugin = get_content_plugin(item.link)
        content = Nokogiri::HTML(plugin.fetch(rss_item, proxy))
        parsed = parse_html_and_download_images(item.link, content, index, proxy)
      	item.description = parse_description parsed[:doc], parsed[:images], index
      end
      item
    end

    def parse_description html, images, index
      text_start, text_end = "<text><![CDATA[", "]]></text>"
      desc = encoding(html_to_txt(html), @encode).strip
      desc = desc.gsub(/\r\n/, "\n")
      desc = desc.gsub(/^\s+$/, "\n")
      desc = desc.gsub(/\n+/, "#{text_end}\n#{text_start}")
      desc = "#{text_end}#{text_start}" + desc if desc.start_with? "#img["
      images.each_with_index { |image, idx| desc = desc.gsub("#{text_start}#img[#{idx}]##{text_end}", "<img width=\"#{image.width}\" height=\"#{image.height}\">#{@index}/#{index}/#{idx}#{image.suffix}</img>") }
      desc = desc + "#{text_start}" if desc.end_with? "</img>"
      text_start + desc + text_end
    end

    def parse_html_and_download_images link, doc, index, proxy
      downloader = Image::MultiThreadDownloader.new proxy
      inner_index = 0
      doc.xpath("//img").each do |node|
        src = node['src']
        unless src.start_with?('http://')
          url = URI.parse link
          if src.start_with? '/'
            src = "http://#{url.host}:#{url.port}#{src}" if src.start_with? '/'
          else
            src = "http://#{url.host}:#{url.port}#{url.path}/..#{src}" unless src.start_with? '/'
          end
        end

        if src.downcase.include?(".png") || src.downcase.include?(".jpg")
          suffix = src.downcase.include?(".png") ? ".png" : ".jpg"
          downloader.start_download(src, "#{get_download_path(@base_dir, @index, index)}/#{inner_index}#{suffix}")
          new_node = Nokogiri::XML::Node.new("p", node.parent)
          new_node.content = "#img[#{inner_index}]#"
          inner_index += 1
          node.replace(new_node)
        end
      end
      image_list = downloader.wait_until_finish
      {:doc => doc.to_html, :images => image_list}
    end

    def get_download_path base_dir, ch_index, article_index
      path = "#{base_dir}/snbc/images/"
      path += "#{ch_index}/" unless ch_index.empty?
      path += "#{article_index}"
    end

    def get_content_plugin link
      @plugins.each { |prefix, plugin|  return plugin if link.start_with? prefix }
      Rss::Plugin::DefaultContentPlugin.new
    end
  end
end