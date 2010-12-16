#--
# Copyright (c) 2010 DigitalSonic
#++

require 'yaml'
require 'util'

# Class to load book config.
class ConfigLoader
  include Util
  attr_reader :config, :plugins

  def initialize config_file = 'config.yml'
    file = File.open config_file
    @config = YAML.load(file)
    file.close
    encode_book_info
    parse_plugins
  end

  # If it's under windows, the default charset is GBK. Bambook needs UTF-8
  def encode_book_info
    @config['book'].each_pair { |key, val| @config['book'][key] = encoding(val, 'GBK') } if is_windows?
  end

  def parse_plugins
    @plugins = Hash.new
    @config['plugins'].each { |plugin| @plugins[plugin['url_prefix']] = eval("#{plugin['plugin']}.new") }
  end
end