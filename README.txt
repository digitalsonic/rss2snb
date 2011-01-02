RSS2SNB

用于将RSS转换为Bambook SNB自有格式的小工具。其实是做给程序员的一个小玩具:-)
可跨平台运行于Windows与Linux之上。基于JRuby开发。

遵循Apache License, Version 2.0。
源代码地址： https://github.com/digitalsonic/rss2snb


DigitalSonic


安装指南
===========================================
1. 安装JRuby
到 http://jruby.org/download 下载最新JRuby包，事先请安装JDK（版本>=1.5，建议使用1.6以上版本）。
如果是Windows，也可选择自带Java的exe安装包。
如果是Ubuntu，请自行选择apt方式或下载tar.gz包。

Windows中，打开“开始”菜单，点击“运行”，键入“CMD”，点击“确认”。
在弹出的命令行中输入：jruby --version
回车后如果显示JRuby版本则说明安装成功。

Ubuntu中，在终端中运行 jruby --version

2.安装gem
假设rss2snb.zip解压缩到了D盘rss2snb目录中，打开CMD命令行，运行：
d: <回车>
cd d:\rss2snb <回车>
jruby -S gem install rss2snb-0.6.gem --no-ri --no-rdoc

随后会自动进行安装，如果事先安装过想卸载，运行：
jruby -S gem uninstall rss2snb

Ubuntu中，请在解压缩的目录中自行运行上面的两条jruby命令

3.执行生成snb文件
首先修改config.yml配置生成文件路径等内容，各配置说明见文件内描述（一次性配置，一般情况下可跳过此步）。
然后在channels.yml中配置需要抓取的RSS内容。
最后在rss2snb\bin目录中，运行：
run <回车>

Ubuntu中，运行run.sh

注意：
Ubuntu中运行时，可能会报几个so文件依赖不到，例如libxml2.so、libxslt.so和libexslt.so。
这些库其实是有的，在/usr/lib中可以找到几个同文件主名的文件，请自行按报错提示的so文件重行做下ln。
这个错是JRuby通过FFI来调用Nokogiri时报的，与程序本身没什么关系。


ChangeLog
===========================================
v0.6
发布时间：2010-01-04
除png、jpg之外，支持更多图片类型，自动将所有图片转换为jpg格式。

v0.5
发布时间：2010-12-27
增加myNoSQL（ http://nosql.mypopescu.com/ ）和Scalable Web Architectures（ http://www.royans.net/arch/ ）全文抓取支持。
分离配置文件，独立RSS Channel至channels.yml中。明确区分需要用户配置的项。
默认使用JRuby的1.9模式运行。

v0.4
发布时间：2010-12-18
支持自定义全文抓取插件，提供InfoQ（ http://www.infoq.com ）和 High Scalability（ http://highscalability.com ）的支持。

v0.3
发布时间：2010-12-14

支持代理服务器（有些RSS直接访问不到，原因你懂的）
支持自动上传
根据操作系统判断配置文件中图书信息（book段）的字符集，Windows为GBK，Ubuntu为UTF-8

v0.2
发布时间：2010-12-03

支持图片多线程下载，图片优化

v0.1 
发布时间：2010-11-26

初始版本，使用JRuby开发，可运行于WinXP及Ubuntu，其他系统未做测试
支持从配置文件（例如config.yml）中读取配置，多线程读取RSS，生成SNB


Future RoadMap
===========================================
v0.7
可能会考虑增加图形化配置界面，目前有打算尝试HTML5。
