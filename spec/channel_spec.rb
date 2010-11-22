require 'channel'

describe Channel do
  before(:each) do
    url = 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'
    @channel = Channel.new url, 5
  end

  it "should parse the right channel infomation" do
    @channel.url.should == 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'
    @channel.encode.should == 'UTF-8'
    @channel.title.should == 'DigitalSonic的自留地'
    @channel.link.should == 'http://digitalsonic.blogbus.com/'
    @channel.description.should == '希望这里能成为见证我成长的地方。'
  end

  it "should parse the specified number of items" do
    @channel.items.size.should == 5
  end
end

