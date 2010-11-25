#--
# Copyright (c) 2010 DigitalSonic
#++
require 'util'
require 'rss/channel'
require 'render/render'

require 'java'
require 'jna.jar'
require 'BambookJavaSDK.jar'

# Command-Line based runner
class Runner
  include Util
  
  def run
    config = {}
    config[:target] = 'd:/workspace/rss2snb/target'
    config[:channels] = [{
        :url => 'http://feedsky.blogbus.com/digitalsonic_blogbus_com',
        :max_items_count => 2
      }]
    config[:book] = {
      :name => 'My RSS Collection',
      :author => 'Rss2Snb',
      :language => 'zh-CN',
      :copyright => 'all rights reserved to the origin authors',
      :abstract => 'E-Book generated from RSS.',
      :created => Time.now.strftime("%Y-%m-%d %H:%M")
    }

    channels = fetch_channels config[:channels]
    generate_files config[:book], channels, config[:target]
    pack_to_snb 'rss.snb', config[:target]
  end

  def fetch_channels channel_sets
    channels = []
    threads = []
    channel_sets.each do |cfg|
      threads << Thread.new(cfg) do |ch_cfg|
        channels << Rss::Channel.new(ch_cfg[:url], ch_cfg[:max_items_count])
      end
    end
    threads.each do |thread|
      begin
        thread.join
      rescue e
        puts "Fetch channel error: #{e.message}"
      end
    end
    channels
  end

  def generate_files book_info, channels, target
    book_render = Render::BookRender.new
    toc_render = Render::TocRender.new
    snbc_render = Render::SnbcRender.new

    chapters = []
    channels.each {|channel| chapters = chapters + channel.items}
    
    write_to_file "#{target}/snbf/book.snbf", book_render.render(book_info)
    write_to_file "#{target}/snbf/toc.snbf", toc_render.render(chapters)
    chapters.each_index do |idx|
      content = snbc_render.render({:title => chapters[idx].title, :body => chapters[idx].description})
      write_to_file "#{target}/#{idx}.snbc", content
    end
  end

  def pack_to_snb snb_file, snb_dir
    com.sdo.bambooksdk.BambookCore.INSTANCE.BambookPackSnbFromDir(snb_file, snb_dir)
  end
end

Runner.new.run if $PROGRAM_NAME == __FILE__