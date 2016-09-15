class MyDoc
  include Mongoid::Document
  include Elasticsearch::Model::MongoidExtensions::SCI

  index_name_template -> (cls) { ['elasticsearch-model-mongoid_extensions', cls.model_name.plural].join('-') }
  document_type_template -> (cls) { ['test', cls.model_name.singular].join('_') }

  settings index: { number_of_shards: 1 }

  field :field_1, type: String

  mapping do
    indexes :field_1
  end

  def as_indexed_json(options = {})
    as_json(only: %i(field_1))
  end
end

class MyDoc1 < MyDoc
  field :field_2, type: String

  mapping do
    indexes :field_2
  end

  def as_indexed_json(options = {})
    as_json(only: %i(field_1 field_2))
  end
end

class MyDoc2 < MyDoc1
  field :field_3, type: String

  mapping do
    indexes :field_3
  end

  def as_indexed_json(options = {})
    as_json(only: %i(field_1 field_2 field_3))
  end
end
