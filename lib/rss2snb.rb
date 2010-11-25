#--
# Copyright (c) 2010 DigitalSonic
#++
require 'util'
require 'rss/channel'
require 'render/render'
require 'config_loader'
require 'logger'


# Command-Line based runner
class Rss2Snb
  include Util
  
  def initialize config_file = 'config.yml'
    @config = ConfigLoader.new(config_file).config
  end

  def run
    channels = fetch_channels @config['channels']
    generate_files @config['book'], channels, @config['general']['temp']
    {:file => @config['general']['target'], :dir => @config['general']['temp']}
  end

  def fetch_channels channel_sets
    channels = []
    threads = []
    channel_sets.each do |cfg|
      threads << Thread.new(cfg) do |ch_cfg|
        channels << Rss::Channel.new(ch_cfg['url'], ch_cfg['max'])
      end
    end
    join_multi_threads threads
    log_info "#{channels.size} Channel(s) Fetched."
    channels
  end

  def generate_files book_info, channels, target
    book_render = Render::BookRender.new
    toc_render = Render::TocRender.new
    snbc_render = Render::SnbcRender.new

    chapters = []
    channels.each {|channel| chapters = chapters + channel.items}

    create_dir_struct target
    write_to_file "#{target}/snbf/book.snbf", book_render.render(book_info)
    write_to_file "#{target}/snbf/toc.snbf", toc_render.render(chapters)
    chapters.each_index do |idx|
      content = snbc_render.render({:title => chapters[idx].title, :body => chapters[idx].description})
      write_to_file "#{target}/snbc/#{idx}.snbc", content
    end
  end
end