#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'

module Rss
  module Plugin
    # Fetch content from infoq.com
    class InfoQ
      def fetch rss_item, proxy
        url = URI.parse(rss_item.link)
        link = rss_item.link
        content = rss_item.description
        proxy.start(url.host, url.port) do |http|
          path = url.path
          path += "?#{url.query}" unless url.query.nil?
          body = http.get(path).body
          content = get_content rss_item, body
        end
        {:content => content, :link => link}
      end

      # get content from the body(news, articles and interviews have their own methods)
      def get_content rss_item, body
        case rss_item.link
        when /\/news\// then content = get_news_and_articles(body)
        when /\/articles\// then content = get_news_and_articles(body)
        when /\/interviews\// then content = get_interviews(body)
        else content = rss_item.description
        end
        content
      end

      def get_news_and_articles body
        node = Nokogiri::HTML(body).at_css('div.box-content-5')
        node.xpath('./h1').each { |n| n.remove }
        node.xpath('./p[@class="info"]').each { |n| n.remove }
        node.xpath('./dl[@class="tags2"]').each { |n| n.remove }
        node.xpath('./div[@class="addthis_toolbox addthis_default_style"]').each { |n| n.remove }
        node.xpath('./div[@class="vendor-content-box-float"]').each { |n| n.remove }
        node.xpath('./div[@class="article_moreinfo_box"]').each { |n| n.remove }
        node.xpath('./div[@class="vendor-content-box"]').each { |n| n.remove }
        node.xpath('./script').each { |n| n.remove }
        node.xpath('./div[@class="comments-header"]').each { |n| n.remove }
        node.xpath('./div[@class="comments-sort"]').each { |n| n.remove }
        node.xpath('./ol[@class="comments"]').each { |n| n.remove }
        node.xpath('./div[@class="box-bottom"]').each { |n| n.remove }
        node.xpath('./div[@class="forum-list-tree"]').each { |n| n.remove }
        node.xpath('./div[@class="comments-sort"]').each { |n| n.remove }
        node.xpath('./span').each { |n| n.remove }
        node.to_html
      end

      def get_interviews body
        Nokogiri::HTML(body).xpath('//div[@id="intTranscript"]').first.to_html
      end
    end
  end
end
