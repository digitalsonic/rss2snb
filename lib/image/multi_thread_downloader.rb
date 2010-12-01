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
    
    def initialize
      @threads = []
      @image_list = []      
    end

    def start_download(uri, target)
      @threads << Thread.new(URI.parse(uri)) do |url|
        @image_list << download(url, target)
      end
    end

    def download(url, target)
      Net::HTTP.start(url.host, url.port) do |http|
        resp = http.get url.path
        open(target, "wb") {|file| file.write resp.body}
        fit_to_width target
      end
    end

    def wait_until_finish
      @threads.each do |thread|
        begin
          thread.join
        rescue e
          log_error "Download Error: #{e.message}"
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
      Image.new file, to_width, to_height
    end
  end
end