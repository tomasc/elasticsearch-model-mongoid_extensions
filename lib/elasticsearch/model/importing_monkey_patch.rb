require 'elasticsearch/model/adapters/mongoid'
require 'elasticsearch/model/mongoid_extensions/importing'

module Elasticsearch::Model::Adapter::Mongoid::Importing
  prepend Elasticsearch::Model::MongoidExtensions::Importing
end
