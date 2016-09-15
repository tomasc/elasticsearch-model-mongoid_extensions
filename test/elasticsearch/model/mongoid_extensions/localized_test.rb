require 'test_helper'

describe Elasticsearch::Model::MongoidExtensions::Localized do
  let(:field_1_en) { 'ONE' }
  let(:field_1_cs) { 'JEDNA' }

  let(:field_2_en) { 'TWO' }
  let(:field_2_cs) { 'DVA' }

  let(:field_1_translations) { { 'en' => field_1_en, 'cs' => field_1_cs } }
  let(:field_2_translations) { { 'en' => field_2_en, 'cs' => field_2_cs } }

  let(:my_doc_loc) { MyDocLoc.new(field_1_translations: field_1_translations, field_2_translations: field_2_translations) }

  describe '.mapping' do
    let(:mapping) { MyDocLoc.mapping.to_hash[MyDocLoc.document_type.to_sym][:properties] }

    it 'converts the default mappings into objects' do
      mapping[:field_1].must_equal(type: 'object', properties: { en: { type: 'string' } })
    end

    it 'works with aliased fields' do
      mapping[:f2].must_equal(type: 'object', properties: { en: { type: 'string' } })
    end
  end

  describe '#as_indexed_json' do
    it 'includes both locales' do
      my_doc_loc.as_indexed_json['field_1'].must_equal field_1_translations
    end

    it 'works with aliased fields' do
      my_doc_loc.as_indexed_json['f2'].must_equal field_2_translations
    end
  end
end
