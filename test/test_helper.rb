$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/around'
require 'minitest/spec'

require 'mongoid'
require 'elasticsearch/model'
require 'elasticsearch/rails'

require 'elasticsearch/model/mongoid_sci'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class MyDoc
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::MongoidSci

  index_name_template -> (cls) { ['elasticsearch-model-mongoid_sci', cls.model_name.plural].join('-') }
  settings index: { number_of_shards: 1 }

  field :field_1, type: String

  mapping do
    indexes :field_1
  end
end

class MyDoc1 < MyDoc
  field :field_2, type: String

  mapping do
    indexes :field_2
  end
end

class MyDoc2 < MyDoc1
  field :field_3, type: String

  mapping do
    indexes :field_3
  end
end
