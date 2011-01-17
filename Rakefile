require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'rss2snb'
  s.version = '0.7'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.txt', 'LICENSE-2.0.txt']
  s.summary = 'A simple tool which converts RSS to SNB file.'
  s.description = "A simple tool which converts RSS to SNB file."
  s.author = 'DigitalSonic'
  s.email = 'digitalsonic.dxf@gmail.com'
  s.homepage = 'https://github.com/digitalsonic/rss2snb'
  s.files = %w(README.txt LICENSE-2.0.txt Rakefile) + Dir.glob("lib/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
  s.add_dependency('rmagick4j', '~> 0.3.7')
  s.add_dependency('nokogiri', '~> 1.4')
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README.txt', 'LICENSE-2.0.txt', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.txt" # page to start on
  rdoc.title = "rss2snb docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset' << 'utf-8'
end
