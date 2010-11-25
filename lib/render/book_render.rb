#--
# Copyright (c) 2010 DigitalSonic
#++
require 'erb'

module Render
  # Render for book.snbf
  class BookRender
    def render book
      name = book[:name]
      author = book[:author]
      language = book[:language]
      copyright = book[:copyright]
      abstract = book[:abstract]
      created = book[:created]

      template = %q{
<?xml version="1.0" encoding="UTF-8"?>
<book-snbf version="1.0">
    <head>
       <name><![CDATA[<%=name%>]]></name>
       <author><![CDATA[<%=author%>]]></author>
       <language><%=language%></language>
       <rights><![CDATA[<%=copyright%>]]></rights>
       <publisher>None</publisher>
       <generator>Rss2Snb</generator>
       <created><%=created%></created>
       <abstract><![CDATA[<%=abstract%>]]></abstract>
       <cover></cover>
    </head>
</book-snbf>
      }

      ERB.new(template.gsub(/^\s+/, "")).result(binding)
    end
  end
end
