require 'logger'
require 'rubygems'
gem 'rss2snb'
require 'rss2snb'



snb = Rss2Snb.new('config.yml').run
#pack_to_snb snb[:file], snb[:dir]
