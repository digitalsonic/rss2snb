require 'rss/channel'
require 'rss/feed_item_parser'

module Rss
  describe Channel do
    before(:each) do
      url = 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'
      parser = Rss::FeedItemParser.new "#{File.expand_path(File.dirname(__FILE__))}", "0"
      @channel = Channel.new url, 2, parser
    end

    it "should parse the right channel infomation" do
      @channel.url.should == 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'
      @channel.title.should == 'DigitalSonic的自留地'
      @channel.link.should == 'http://digitalsonic.blogbus.com/'
      @channel.description.should == '希望这里能成为见证我成长的地方。'
    end


  end
end