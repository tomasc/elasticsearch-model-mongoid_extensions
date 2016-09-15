require 'test_helper'

describe Elasticsearch::Model::MongoidExtensions::Fields do
  subject { MyDocFields }

  describe '#to_fields' do
    let(:to_fields) { MyDocFields.mapping.to_fields }

    it 'maps simple mappings' do
      to_fields.must_include 'field_1'
    end

    it 'maps nested mappings' do
      to_fields.must_include 'field_2'
      to_fields.must_include 'field_2.number'
      to_fields.must_include 'field_2.string'
    end
  end
end
