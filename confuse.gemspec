# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confuse/version'

Gem::Specification.new do |spec|
  spec.name          = 'confuse'
  spec.version       = Confuse::VERSION
  spec.authors       = ['Tom Chipchase']
  spec.email         = ['tom@mediasp.com']
  spec.description   = 'Add nested configuration to an application'
  spec.summary       = 'A DSL for defining configuration options in classes'
  spec.homepage      = 'https://github.com/mediasp/confuse'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 1.9.0'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'inifile'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rake'
end
