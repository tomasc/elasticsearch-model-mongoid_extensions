# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/model/mongoid/sti/version'

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-model-mongoid-sti'
  spec.version       = Elasticsearch::Model::Mongoid::Sti::VERSION
  spec.authors       = ['Tomas Celizna']
  spec.email         = ['tomas.celizna@gmail.com']

  spec.summary       = 'Set of Elasticsearch::Model mixins for support of STI of Mongoid classes.'
  spec.homepage      = 'https://github.com/tomasc/elasticsearch-model-mongoid-sti'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
