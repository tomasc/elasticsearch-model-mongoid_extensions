require 'elasticsearch/model/indexing'

module Elasticsearch
  module Model
    module MongoidExtensions
      module Localized
        extend ActiveSupport::Concern

        class Mappings < Elasticsearch::Model::Indexing::Mappings
          def indexes(name, options = {}, &block)
            # take the cls from options on the Mappings object
            cls = @options[:cls]

            return super(name, options, &block) unless cls

            field = cls.fields[name.to_s] || cls.fields.detect { |_, meta| meta.options[:as] == name.to_sym }.try(:last)

            return super(name, options, &block) unless field.present? && field.localized?

            super(name) do
              Array(::I18n.available_locales).each do |locale|
                super(locale, options, &block)
              end
            end
          end
        end

        included do
          include Elasticsearch::Model
          include Elasticsearch::Model::MongoidExtensions

          def self.mapping(options = {}, &block)
            options[:cls] ||= self # pass the class to the Mappings object
            __elasticsearch__.instance_variable_set(:@mapping, Mappings.new(document_type, options)) unless __elasticsearch__.instance_variable_get(:@mapping)
            __elasticsearch__.mapping(options, &block)
          end

          # wraps the #as_indexed_json method in order to process the localized fields
          proxy = Module.new do
            define_method(:as_indexed_json) do |*args|
              super(*args).tap do |obj|
                fields.select { |_, field| field.localized? }.each do |name, field|
                  aliased_name = field.options[:as].to_s
                  translations_field_name = [name, 'translations'].join('_')
                  if obj.key?(name) then obj[name] = send(translations_field_name)
                  elsif obj.key?(aliased_name) then obj[aliased_name] = send(translations_field_name)
                  end
                end
              end
            end
          end
          prepend proxy
        end
      end
    end
  end
end
