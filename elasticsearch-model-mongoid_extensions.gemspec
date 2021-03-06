# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/model/mongoid_extensions/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-model-mongoid_extensions'
  spec.version       = Elasticsearch::Model::MongoidExtensions::VERSION
  spec.authors       = ['Tomas Celizna']
  spec.email         = ['tomas.celizna@gmail.com']

  spec.summary       = 'Elasticsearch::Model extensions for Mongoid adding support of single collection inheritance (by the way of multiple indexes), localized fields and mapped fields extraction.'
  spec.homepage      = 'https://github.com/tomasc/elasticsearch-model-mongoid_extensions'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4'
  spec.add_dependency 'elasticsearch-model', '~> 5.0'
  spec.add_dependency 'elasticsearch-rails', '~> 5.0'
  spec.add_dependency 'mongoid', '>= 5', '< 8'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-around'
  spec.add_development_dependency 'rake', '~> 10.0'
end
