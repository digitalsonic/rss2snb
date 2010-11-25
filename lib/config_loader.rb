#--
# Copyright (c) 2010 DigitalSonic
#++

require 'yaml'

# Class to load book config.
class ConfigLoader
  attr_reader :config
  def initialize config_file = 'config.yml'
    file = File.open config_file
    @config = YAML.load(file)
    file.close
  end
end