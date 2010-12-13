#--
# Copyright (c) 2010 DigitalSonic
#++

require 'render/book_render'
require 'rss/channel'

module Render
  describe BookRender do
    before(:each) do
      @book_render = BookRender.new
    end

    it "should genrate the book.sndf file content" do
      url = 'http://feedsky.blogbus.com/digitalsonic_blogbus_com'

      channel = Rss::Channel.new(url, 1, nil)
      book = Hash.new
      book[:name] = channel.title
      book[:author] = channel.title
      book[:language] = channel.language
      book[:copyright] = 'all rights reserved to the origin authors'
      book[:abstract] = channel.description
      book[:created] = Time.now.strftime("%Y-%m-%d %H:%M")
      content = @book_render.render book
      content.should_not be_nil
      puts content
    end
  end
end

