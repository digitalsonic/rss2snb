#--
# Copyright (c) 2010 DigitalSonic
#++

module Image
  # Class for image
  class Image
    attr_accessor :path, :width, :heigth
    def initialize path, suffix, width, height
      @path, @suffix, @width, @height = path, suffix, width, height
    end
  end
end
