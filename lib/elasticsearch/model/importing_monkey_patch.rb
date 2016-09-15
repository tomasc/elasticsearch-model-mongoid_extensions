# TODO: submit PR to https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model that would allow to specify criteria as illustrated below

require 'elasticsearch/model/adapters/mongoid'
require 'elasticsearch/model/mongoid_extensions/importing'

module Elasticsearch::Model::Adapter::Mongoid::Importing
  prepend Elasticsearch::Model::MongoidExtensions::Importing
end
