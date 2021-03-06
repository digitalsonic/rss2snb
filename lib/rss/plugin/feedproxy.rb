#--
# Copyright (c) 2010 DigitalSonic
#++
require 'rubygems'
require 'nokogiri'
require 'net/http'
require 'uri'

module Rss
  module Plugin
    # Parent class for the feeds from http://feedproxy.google.com .
    class Feedproxy
      def fetch rss_item, proxy
        url = URI.parse rss_item.link
        content, link = fetch_content url, proxy
        {:content => content, :link => link }
      end
	  
      def fetch_content url, proxy
        content = nil
        proxy.start(url.host, url.port) do |http|
          path = get_path url
          response = http.get(path)
          case response
          when Net::HTTPSuccess then content = post_process(response.body)
          when Net::HTTPRedirection then content, url = fetch_content(URI.parse(response['location']), proxy)
          else raise Exception.new "Fail to fetch #{url}!"
          end
        end
        [content, url.to_s]
      end
      
      def get_path url
        url.path
      end
    end
  end
end

