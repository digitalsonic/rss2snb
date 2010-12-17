#--
# Copyright (c) 2010 DigitalSonic
#++
require 'net/http'
require 'uri'
require 'util'

module Rss
  module Plugin
    # Fetch content from highscalability.com
    class HighScalability
      include Util

      def fetch rss_item, proxy
	    url = URI.parse rss_item.link
        content, link = fetch_content url, proxy
		{:content => content, :link => link }
      end
	  
	  def fetch_content url, proxy
	    content = nil
        proxy.start(url.host, url.port) do |http|
          path = url.path + "?printerFriendly=true"
          log_info "Fetch #{path}"
		  response = http.get(path)
          case response
          when Net::HTTPSuccess then content = response.body
          when Net::HTTPRedirection then content, url = fetch_content(URI.parse(response['location']), proxy)
          else raise Exception.new "Fail to fetch #{url}!"
          end
        end
		[content, url]
	  end
    end
  end
end
