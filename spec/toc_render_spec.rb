#--
# Copyright (c) 2010 DigitalSonic
#++

require 'render/toc_render'
require 'channel'

module Render
  describe TocRender do
    before(:each) do
      @toc_render = TocRender.new
    end

    it "should generate the right content" do
      url = 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'
      channel = Rss::Channel.new(url)
      content = @toc_render.render channel.items
      content.should_not be_nil
      puts content
    end
  end
end
