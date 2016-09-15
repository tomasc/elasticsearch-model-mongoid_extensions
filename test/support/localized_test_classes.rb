class MyDocLoc
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::MongoidExtensions::Localized

  field :field_1, type: String, localize: true
  field :field_2, type: String, localize: true, as: :f2

  mapping do
    indexes :field_1
    indexes :f2
  end

  def as_indexed_json(options = {})
    super(only: %i(field_1), methods: %i(f2))
  end
end
