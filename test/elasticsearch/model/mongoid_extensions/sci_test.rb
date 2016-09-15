require 'test_helper'

describe Elasticsearch::Model::MongoidExtensions::SCI do
  let(:field_1) { 'ONE' }
  let(:field_2) { 'TWO' }
  let(:field_3) { 'THREE' }

  let(:my_doc) { MyDoc.new(field_1: field_1) }
  let(:my_doc_1) { MyDoc1.new(field_1: field_1, field_2: field_2) }
  let(:my_doc_2) { MyDoc2.new(field_1: field_1, field_2: field_2, field_3: field_3) }

  describe '.index_name' do
    it 'evaluates lambda throughout subclasses' do
      [my_doc, my_doc_1, my_doc_2].each do |doc|
        doc.class.index_name.must_equal ['elasticsearch-model-mongoid_extensions', doc.model_name.plural].join('-')
      end
    end
  end

  describe '.document_type' do
    it 'equals to singular model_name of each class' do
      [my_doc, my_doc_1, my_doc_2].each do |doc|
        doc.class.document_type.must_equal doc.class.model_name.singular
      end
    end
  end

  describe '.settings' do
    it 'propagates settings from super class to subclasses' do
      my_doc.class.settings.to_hash.must_equal(index: { number_of_shards: 1 })
      my_doc_1.class.settings.to_hash.must_equal my_doc.class.settings.to_hash
      my_doc_2.class.settings.to_hash.must_equal my_doc.class.settings.to_hash
    end
  end

  describe '.mapping' do
    let(:my_doc_mapping) { my_doc.class.mapping.to_hash[:my_doc][:properties] }
    let(:my_doc_1_mapping) { my_doc_1.class.mapping.to_hash[:my_doc1][:properties] }

    it 'propagates mapping from super class to subclasses' do
      my_doc_1.class.mapping.to_hash[:my_doc1][:properties][:field_1].must_equal my_doc_mapping[:field_1]
      my_doc_2.class.mapping.to_hash[:my_doc2][:properties][:field_1].must_equal my_doc_mapping[:field_1]
      my_doc_2.class.mapping.to_hash[:my_doc2][:properties][:field_2].must_equal my_doc_1_mapping[:field_2]
    end
  end

  describe '.index_document' do
    before do
      my_doc.class.create_index! force: true
      [my_doc, my_doc_1, my_doc_2].each do |doc|
        doc.__elasticsearch__.index_document refresh: true
      end
    end

    it 'indexes it to the corresponding index' do
      [my_doc, my_doc_1, my_doc_2].each do |doc|
        doc.class.__elasticsearch__.search('*').results.total.must_equal 1
      end
    end
  end

  describe '.search' do
    before do
      my_doc.class.create_index! force: true
      [my_doc, my_doc_1, my_doc_2].each do |doc|
        doc.save!
        doc.__elasticsearch__.index_document refresh: true
      end
    end

    it 'must search across indexes' do
      my_doc.class.search(field_1.downcase).records.to_a.must_equal [my_doc, my_doc_1, my_doc_2]
      my_doc_1.class.search(field_1.downcase).records.to_a.must_equal [my_doc_1, my_doc_2]
      my_doc_2.class.search(field_1.downcase).records.to_a.must_equal [my_doc_2]
    end

    it 'must respect document type if specified' do
      my_doc.class.search(field_1.downcase, type: [my_doc.class.document_type]).records.to_a.must_equal [my_doc]
      my_doc.class.search(field_1.downcase, type: [my_doc.class.document_type, my_doc_1.class.document_type]).records.to_a.must_equal [my_doc, my_doc_1]
      my_doc_1.class.search(field_1.downcase, type: [my_doc_1.class.document_type]).records.to_a.must_equal [my_doc_1]
      my_doc_1.class.search(field_1.downcase, type: [my_doc_2.class.document_type]).records.to_a.must_equal [my_doc_2]
    end
  end

  describe '.import' do
    before do
      my_doc.class.create_index! force: true
      [my_doc, my_doc_1, my_doc_2].each(&:save!)
      my_doc.class.import force: true, refresh: true
    end

    it 'must import root class' do
      my_doc.class.search('*').results.total.must_equal 3
    end

    it 'must import all descending classes' do
      my_doc_1.class.search('*').results.total.must_equal 2
      my_doc_2.class.search('*').results.total.must_equal 1
    end
  end

  describe '.callbacks' do
  end
end
