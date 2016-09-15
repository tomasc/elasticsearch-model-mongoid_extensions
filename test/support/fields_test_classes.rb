class MyDocFields
  include Mongoid::Document
  include Elasticsearch::Model

  field :field_1, type: String
  field :field_2, type: Integer

  mapping do
    indexes :field_1
    indexes :field_2 do
      indexes :number, type: :integer, index: :not_analyzed
      indexes :string, type: :string, index: :not_analyzed
    end
  end
end
