#--
# Copyright (c) 2010 DigitalSonic
#++
require 'iconv'
require 'rubygems'
require 'nokogiri'
require 'logger'


module Util
  def create_logger
    @@logger ||= Logger.new(STDOUT)
    @@logger.level = Logger::INFO
  end

  def log_info message
    create_logger
    @@logger.info message
  end

  def log_error message
    create_logger
    @@logger.error message
  end

  def html_to_txt html
    Nokogiri::HTML(html).text
  end

  def encoding str, from = 'UTF-8', to = 'UTF-8'
    from == to ? str : Iconv.iconv(to, from, str).to_s
  end

  def create_dir_struct path
    abs_path= File.expand_path(path)
    Dir.mkdir abs_path unless File.exist? abs_path
    Dir.mkdir "#{abs_path}/snbc" unless File.exist? "#{abs_path}/snbc"
    Dir.mkdir "#{abs_path}/snbc/images" unless File.exist? "#{abs_path}/snbc/images"
    Dir.mkdir "#{abs_path}/snbf" unless File.exist? "#{abs_path}/snbf"
  end

  def write_to_file path, content
    file = File.open(path, 'wb')
    log_info "Writing #{path}"
    file << content
    file.close
  end

  def join_multi_threads threads
    threads.each do |thread|
      begin
        thread.join
      rescue Exception => e
        log_error "Error: #{e.message}"
      end
    end
  end
end
