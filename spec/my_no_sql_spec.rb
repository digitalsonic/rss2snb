require 'rss/plugin/my_no_sql'

module Rss
  module Plugin
    describe MyNoSql do
      before(:each) do
        @my_no_sql = MyNoSql.new
        @rss_item = RssItem.new
        @rss_item.link = 'http://feedproxy.google.com/~r/nosql/~3/TcRnaKjF_BA/2402557779'
        @proxy = Net::HTTP::Proxy('localhost', 8580)
      end

      it "should desc get the full text" do
        result = @my_no_sql.fetch(@rss_item, @proxy)
        result[:link].should == 'http://nosql.mypopescu.com/post/2402557779/mongodb-replica-sets-and-sharding-question-list'
        puts result[:content]
      end
    end

    class RssItem
      attr_accessor :link
    end
  end
end

