# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fir/version'

Gem::Specification.new do |spec|
  spec.name          = 'fir-cli'
  spec.version       = FIR::VERSION
  spec.date          = '2014-11-20'
  spec.summary       = 'FIR.im command tool'
  spec.description   = 'FIR.im command tool, support iOS and Android'
  spec.homepage      = 'http://blog.fir.im/2014/fir_cli'
  spec.authors       = ['FIR.im']
  spec.email         = 'dev@fir.im'
  spec.license       = 'GPLv3'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'lagunitas', '~> 0.0.2'
  spec.add_dependency 'rest-client', '~> 1.7'
  spec.add_dependency 'ruby_android', '~> 0.7'
end
