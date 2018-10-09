require 'test_helper'
require "i18n/backend/fallbacks"

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
      mapping[:field_1].must_equal(type: 'object', properties: { en: { type: 'text' }, cs: { type: 'text' } })
    end

    it 'works with aliased fields' do
      mapping[:f2].must_equal(type: 'object', properties: { en: { type: 'text' }, cs: { type: 'text' } })
    end

    describe 'subclass' do
      let(:mapping) { MyDocLocSub.mapping.to_hash[MyDocLocSub.document_type.to_sym][:properties] }

      it 'converts the default mappings into objects' do
        mapping[:field_1].must_equal(type: 'object', properties: { en: { type: 'text' }, cs: { type: 'text' } })
      end

      it 'works with aliased fields' do
        mapping[:f2].must_equal(type: 'object', properties: { en: { type: 'text' }, cs: { type: 'text' } })
      end
    end
  end

  describe '#as_indexed_json' do
    it 'includes both locales' do
      my_doc_loc.as_indexed_json['field_1'].must_equal field_1_translations
    end

    it 'works with aliased fields' do
      my_doc_loc.as_indexed_json['f2'].must_equal field_2_translations
    end

    describe 'fallbacks' do
      let(:field_1_translations_with_fallbacks) { { 'en' => field_1_en, 'cs' => field_1_en } }
      let(:field_2_translations_with_fallbacks) { { 'en' => field_2_cs, 'cs' => field_2_cs } }

      before do
        @original_fallbacks = I18n.fallbacks
        I18n.fallbacks = { cs: %i[en], en: %i[cs] }
      end

      after do
        I18n.fallbacks = @original_fallbacks
      end

      describe 'for nil' do
        let(:field_1_cs) { nil }
        let(:field_2_en) { nil }

        it { my_doc_loc.as_indexed_json['field_1'].must_equal field_1_translations_with_fallbacks }
        it { my_doc_loc.as_indexed_json['f2'].must_equal field_2_translations_with_fallbacks }
      end

      describe 'for empty string' do
        let(:field_1_cs) { "" }
        let(:field_2_en) { "" }

        it { my_doc_loc.as_indexed_json['field_1'].must_equal field_1_translations_with_fallbacks }
        it { my_doc_loc.as_indexed_json['f2'].must_equal field_2_translations_with_fallbacks }
      end
    end
  end
end
