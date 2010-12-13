#--
# Copyright (c) 2010 DigitalSonic
#++

require 'yaml'
require 'util'

# Class to load book config.
class ConfigLoader
  include Util
  attr_reader :config

  def initialize config_file = 'config.yml'
    file = File.open config_file
    @config = YAML.load(file)
    file.close
    encode_book_info
  end

  # If it's under windows, the default charset is GBK. Bambook needs UTF-8
  def encode_book_info
    @config['book'].each_pair { |key, val| @config['book'][key] = encoding(val, 'GBK') } if is_windows?
  end
end