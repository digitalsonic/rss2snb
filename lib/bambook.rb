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
import com.sdo.bambooksdk.Const
import com.sdo.bambooksdk.TransCallback

# Bambook related methods
class Bambook
  attr_accessor :upload_progress, :upload_status
  include Util
  
  def initialize
    suffix = is_windows? ? "dll" : "so"
    @bambook_core = Native.loadLibrary("#{File.expand_path(File.dirname(__FILE__))}/BambookCore.#{suffix}".to_java, BambookCore.java_class)
  end

  def pack_snb_from_dir target_file, dir
    @bambook_core.BambookPackSnbFromDir target_file, dir
    log_info "Writing #{target_file}."
  end

  def verify snb_file
    result = @bambook_core.BambookVerifySnbFile snb_file
    if result == Const.BR_SUCC
      log_info "#{snb_file} is a valid SNB file."
    else
      log_error "#{snb_file} is invalid!! ResultCode=#{result}"
    end
    result == Const.BR_SUCC
  end

  # Connect to bambook with a specific IP.
  def get_conn ip_addr = '192.168.250.2'
    conn = IntByReference.new
    begin
      log_info "Connecting to Bambook #{ip_addr}."
      result = @bambook_core.BambookConnect ip_addr, 0, conn
      raise Exception.new("ResultCode:#{result}") unless result == Const.BR_SUCC
    rescue Exception => e
      log_error "Can't connect to Bambook. #{e.message}"
    end
    conn.get_value
  end

  def close_conn conn
    @bambook_core.BambookDisconnect(conn) unless conn.nil?
  end

  def upload_to_bambook snb_path, conn
    @upload_progress = 0
    @upload_status = "Uploading"
    log_info "Start Uploading..."
    result = @bambook_core.BambookAddPrivBook conn, snb_path, UploadCallBack.new(self), 0
    if result == Const.BR_SUCC
      hold_times = 0
      last_progress = 0
      until @upload_progress == 100 || @upload_status != "Uploading"
        sleep(5)
        log_info "#{@upload_status} - Progress: #{@upload_progress}%"
        hold_times = last_progress == @upload_progress ? (hold_times + 1) : 0
        last_progress = @upload_progress
        if (hold_times == 5)
          log_error "Upload Aborted! Maybe snb file has already been uploaded."
          break
        end
      end
    else
      log_error "Upload Failed!"
    end
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
    case status
    when Const.TRANS_STATUS_TRANS
      @bambook.upload_progress = progress
    when Const.TRANS_STATUS_DONE
      @bambook.upload_progress = 100
      @bambook.upload_status = "Upload Success!"
    when Const.TRANS_STATUS_ERR
      log_error "Upload Failed!"
      @bambook.upload_progress = progress
      @bambook.upload_status = "Upload Failed!"
    end
  end
end