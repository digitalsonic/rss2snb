#--
# Copyright (c) 2010 DigitalSonic
#++
require 'erb'

module Render
  class SnbcRender
    def render snbc
      title = snbc[:title]
      body = snbc[:body]
      
      template = %q{
<?xml version="1.0" encoding="UTF-8"?>
<snbc>
    <head>
       <title><![CDATA[<%=title%>]]></title>
    </head>
    <body>
       <%=body%>
    </body>
</snbc>
      }
      
      ERB.new(template.gsub(/^\s+/, "")).result(binding)
    end
  end
end
