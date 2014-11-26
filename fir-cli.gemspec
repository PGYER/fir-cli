# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name          = 'fir-cli'
  s.version       = '0.1.3'
  s.date          = '2014-11-20'
  s.summary       = 'FIR.im 命令行工具'
  s.description   = 'FIR.im 命令行工具，支持 ios 和 android'
  s.homepage      = 'http://blog.fir.im/2014/fir-cli'
  s.author        = 'FIR.im'
  s.email         = 'fir-cli@fir.im'
  s.license       = 'GPLv3'
  s.files         = `git ls-files -z`.split("\x0")
  s.executables   << 'fir'
  s.require_paths << './'

  s.add_dependency 'lagunitas', '0.0.1'
  s.add_dependency 'user_config', '0.0.4'
  s.add_dependency 'pngdefry', '0.1.1'
  s.add_dependency 'rest_client', '~> 1.8.2'
  s.add_dependency 'paint', '~> 0.9.0'
  s.add_dependency 'thor', '~> 0.19.1'
  s.add_dependency 'ruby_apk', '~> 0.7.1'
  s.add_dependency 'highline', '~> 1.6.21'
end
