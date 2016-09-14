# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/model/mongoid_sci/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-model-mongoid_sci'
  spec.version       = Elasticsearch::Model::MongoidSci::VERSION
  spec.authors       = ['Tomas Celizna']
  spec.email         = ['tomas.celizna@gmail.com']

  spec.summary       = 'Elasticsearch::Model mixin that adds support for importing, indexing & search of Mongoid single collection inheritance classes by the way of separate indexes.'
  spec.homepage      = 'https://github.com/tomasc/elasticsearch-model-mongoid_sci'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4', '< 6'
  spec.add_dependency 'elasticsearch-model', '~> 0.1'
  spec.add_dependency 'elasticsearch-rails', '~> 0.1'
  spec.add_dependency 'mongoid', '~> 5'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-around'
  spec.add_development_dependency 'rake', '~> 10.0'
end
