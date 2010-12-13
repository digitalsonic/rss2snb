#--
# Copyright (c) 2010 DigitalSonic
#++
require 'util'
require 'java'
require 'jna.jar'
require 'BambookLib.jar'
import com.sun.jna.Native
import com.sun.jna.ptr.IntByReference
import com.sdo.bambooksdk.BambookCore
import com.sdo.bambooksdk.TransCallback

# Bambook related methods
class Bambook
  attr_accessor :progress
  include Util
  def initialize
    suffix = is_windows? ? "dll" : "so"
    @bambook_core = Native.loadLibrary("#{File.expand_path(File.dirname(__FILE__))}/BambookCore.#{suffix}".to_java, BambookCore.java_class)
    @progress = 0
  end

  def pack_snb_from_dir target_file, dir
    @bambook_core.BambookPackSnbFromDir target_file, dir
    log_info "Writing #{target_file}."
  end

  # Connect to bambook with a specific IP.
  def get_conn ip_addr = '192.168.250.2'
    conn = IntByReference.new
    begin
      log_info "Connecting to Bambook #{ip_addr}."
      result = @bambook_core.BambookConnect ip_addr, 0, conn
      raise Exception.new("ResultCode:#{result}") unless result == 0
    rescue Exception => e
      log_error "Can't connect to Bambook. #{e.message}"
    end
    conn.get_value
  end

  def close_conn conn
    @bambook_core.BambookDisconnect(conn) unless conn.nil?
  end

  def upload_to_bambook snb_path, conn
    @bambook_core.BambookAddPrivBook conn, snb_path, UploadCallBack.new(self), 0
    sleep(1) until @progress == 100
  end
end

# Callback class to deal with Upload action.
class UploadCallBack
  include Util
  import com.sdo.bambooksdk.TransCallback

  def initialize bambook
  	@bambook = bambook
  end

  def invoke status, progress, userData
    @bambook.progress = (status != 0 ? progress : 100)
    case status
      when 0 then log_info "Uploading! Progress: #{progress}"
      when 1 then log_info "Upload Success!"
      when 2 then log_error "Upload Failed!"
    end
  end
end