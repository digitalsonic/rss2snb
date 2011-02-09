#--
# Copyright (c) 2010 DigitalSonic
#++
require 'logger'
require 'net/http'
require 'util'
require 'bambook'
require 'rss/channel'
require 'rss/feed_item_parser'
require 'render/render'
require 'config_loader'

# Command-Line based runner
class Rss2Snb
  include Util
  
  def initialize config_file = 'config.yml'
    config_loader = ConfigLoader.new(config_file)
    @config = config_loader.config
    @plugins = config_loader.plugins
    @bambook = Bambook.new 
  end

  # main entrance
  def run
    channels = fetch_channels @config['channels'], @config['general']['temp']
    generate_files @config['book'], channels, @config['general']['temp']
    pack_to_snb @config['general']['target'], @config['general']['temp']
    upload_to_bb @config['general']['target'], @config['general']['bb_address'] if @bambook.verify(@config['general']['target']) && @config['general']['auto_upload']
    log_info "DONE!!!!"
  end

  def fetch_channels channel_sets, temp_dir
    channels = []
    threads = []
    channel_sets.each_with_index do |cfg, idx|
      parser = Rss::FeedItemParser.new temp_dir, "#{idx}", @plugins
      threads << Thread.new(cfg) do |ch_cfg|
        proxy_setting = ch_cfg['use_proxy'] ? @config['proxy'] : Hash.new
        proxy = create_proxy_or_direct_http(proxy_setting, ch_cfg['url'])
        channels << Rss::Channel.new(ch_cfg['url'], ch_cfg['max'], parser, proxy)
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

  def pack_to_snb snb_file, snb_dir
    @bambook.pack_snb_from_dir snb_file, snb_dir
  end

  def upload_to_bb snb_file, bb_addr
    log_info "Start uploading to Bambook..."
    conn = @bambook.get_conn bb_addr
    @bambook.upload_to_bambook snb_file, conn
    @bambook.close_conn conn
  end
end
