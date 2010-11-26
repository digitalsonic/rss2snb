#--
# Copyright (c) 2010 DigitalSonic
#++
require 'fileutils'
require 'iconv'
require 'rubygems'
require 'nokogiri'
require 'logger'
require 'java'

module Util
  def self.is_windows?
    !(java.lang.System.get_properties['os.name'] =~ /Windows/).nil?
  end

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
    FileUtils.makedirs "#{abs_path}/snbc/images"
    FileUtils.makedirs "#{abs_path}/snbf"
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
