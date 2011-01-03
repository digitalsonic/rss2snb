# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
gem PLATFORM == 'java' ? 'rmagick4j' : 'rmagick'
require 'RMagick'

require 'net/http'
require 'uri'
require 'util'
require 'image/image'

module Image
  class MultiThreadDownloader
    include Util
    
    def initialize proxy = Net::HTTP
      @threads = []
      @image_list = []
      @proxy = proxy
    end

    def start_download(uri, target)
      @threads << Thread.new(URI.parse(uri)) do |url|
        @image_list << download(url, target)
      end
    end

    def download(url, target)
      @proxy.start(url.host, url.port) do |http|
        response = http.get url.path
        log_info "Downloading #{url}."
        create_dir target[0...target.rindex("/")]

        case response
        when Net::HTTPSuccess then write_bin_file(target, response.body)
        when Net::HTTPRedirection, Net::HTTPFound then download(URI.parse(response['location']), target)
        else raise Exception.new "Fail to fetch RSS #{url}!"
	end
        fit_to_width target
      end
    end

    def wait_until_finish
      @threads.each do |thread|
        begin
          thread.join
        rescue Exception => e
          log_error e.message
	  log_debug e
        end
      end
      @image_list
    end

    def fit_to_width file, width = 600
      img =  Magick::Image.read(file).first
      old_width, old_height = img.columns, img.rows
      to_width, to_height = old_width, old_height
      if (old_width >= width)
        to_width, to_height = width, (old_height * (width / old_width.to_f)).to_i
        img.resize(to_width, to_height).write(file)
      end
      Image.new file, get_suffix(file), to_width, to_height
    end
    
    def get_suffix file
      file[file.rindex(".")...file.length]
    end
  end
end
