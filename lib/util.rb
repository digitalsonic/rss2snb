#--
# Copyright (c) 2010 DigitalSonic
#++
require 'fileutils'
require 'iconv'
require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'logger'
require 'java'

module Util
  def is_windows?
    !(java.lang.System.get_properties['os.name'] =~ /Windows/).nil?
  end

  def create_proxy_or_direct_http proxy, url = nil
    url_for_log = url.nil? ? '' : url
    if proxy['proxy_host'].nil?
      log_info "Connecting #{url_for_log} Directly."
    else
      log_info "Connecting #{url_for_log} with Proxy(#{proxy['proxy_host']}:#{proxy['proxy_port']})."
    end
    Net::HTTP::Proxy(proxy['proxy_host'], proxy['proxy_port'], proxy['proxy_user'], proxy['proxy_password'])
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

  def log_debug message
    create_logger
    @@logger.debug message
  end

  def html_to_txt html
    Nokogiri::HTML(html).text
  end

  def encoding str, from = 'UTF-8', to = 'UTF-8'
    from == to ? str : Iconv.iconv(to, from, str).to_s
  end

  def create_dir_struct path
    abs_path= File.expand_path(path)
    create_dir "#{abs_path}/snbc/images"
    create_dir "#{abs_path}/snbf"
  end

  def create_dir path
    FileUtils.makedirs File.expand_path(path)
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
        log_error e.message
        log_debug e
      end
    end
  end

  def write_bin_file target, content
     open(target, "wb") {|file| file.write content}
  end
end
