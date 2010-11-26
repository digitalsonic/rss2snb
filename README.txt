RSS2SNB

用于将RSS转换为Bambook SNB自有格式的小工具。其实是做给程序员的一个小玩具:-)
可跨平台运行于Windows与Linux之上。基于JRuby开发。

遵循Apache License, Version 2.0。
源代码地址： https://github.com/digitalsonic/rss2snb


DigitalSonic


安装指南
===========================================
1. 安装JRuby
到 http://jruby.org/download 下载最新JRuby包，事先请安装JDK。
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
jruby -S gem install rss2snb-0.1.gem --no-ri --no-rdoc

随后会自动进行安装，如果事先安装过想卸载，运行：
jruby -S gem uninstall rss2snb

Ubuntu中，请在解压缩的目录中自行运行上面的两条jruby命令

3.执行生成snb文件
先修改config.yml，然后在rss2snb\bin目录中，运行：
run <回车>

Ubuntu中，运行run.sh

注意：
Ubuntu中运行时，可能会报几个so文件依赖不到，例如libxml2.so、libxslt.so和libexslt.so。
这些库其实是有的，在/usr/lib中可以找到几个同文件主名的文件，请自行按报错提示的so文件重行做下ln。
这个错是JRuby通过FFI来调用Nokogiri时报的，与程序本身没什么关系。


ChangeLog
===========================================
v0.1 
开始时间：2010-11-22
发布时间：2010-11-26

初始版本，使用JRuby开发，可运行于WinXP及Ubuntu，其他系统未做测试。
支持从配置文件（例如config.yml）中读取配置，多线程读取RSS，生成SNB。
本版本不支持图片，但图片功能已基本开发完成，下个版本将加入。

RoadMap
===========================================
v0.2
支持图片，多线程下载，图片优化

v0.3
支持代理服务器（有些RSS直接访问不到，原因你懂的）
支持Wifi上传

v0.4
支持自定义抓取插件，计划首批支持 http://highscalability.com/ ，如时间允许支持InfoQ中文站

v0.5
可能会考虑增加Swing GUI