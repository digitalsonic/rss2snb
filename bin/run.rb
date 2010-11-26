require 'logger'
require 'rubygems'
gem 'rss2snb'
require 'rss2snb'

require 'java'
require 'jna.jar'
require 'BambookLib.jar'
import com.sun.jna.Native
import com.sdo.bambooksdk.BambookCoreJRubyHelper

def pack_to_snb snb_file, snb_dir
  suffix = Util::is_windows? ? "" : ".so"
  Native.loadLibrary("#{File.expand_path(File.dirname(__FILE__))}/BambookCore#{suffix}".to_java, BambookCoreJRubyHelper.getBambookCoreClass()).BambookPackSnbFromDir(snb_file, snb_dir)
  Logger.new(STDOUT).warn "Writing #{snb_file}. DONE!"
end

snb = Rss2Snb.new('config.yml').run
pack_to_snb snb[:file], snb[:dir]
