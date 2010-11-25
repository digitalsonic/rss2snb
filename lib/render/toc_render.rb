#--
# Copyright (c) 2010 DigitalSonic
#++
require 'erb'

module Render
  class TocRender
    def render chapters
      template = %q{
<?xml version="1.0" encoding="UTF-8"?> 
<toc-snbf> 
    <head> 
       <chapters><%=chapters.size%></chapters>
    </head> 
    <body>
       <%chapters.each_index do |idx| %>
       <chapter src="<%=idx%>.snbc">
          <![CDATA[<%=chapters[idx].title%>]]>
       </chapter>
       <%end%>
    </body>
</toc-snbf>
      }

      ERB.new(template.gsub(/^\s+/, "")).result(binding)
    end
  end
end
