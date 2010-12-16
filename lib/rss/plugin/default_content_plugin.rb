#--
# Copyright (c) 2010 DigitalSonic
#++

module Rss
  module Plugin
    # Default feed item parser which parses the feed's description
    class DefaultContentPlugin
      def fetch rss_item, proxy
        rss_item.description
      end
    end
  end
end
