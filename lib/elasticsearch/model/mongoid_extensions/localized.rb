require 'elasticsearch/model/indexing'

module Elasticsearch
  module Model
    module MongoidExtensions
      module Localized
        extend ActiveSupport::Concern

        class ProcessMappings < Struct.new(:cls, :mapping)
          def self.call(*args)
            new(*args).call
          end

          def call
            mapping.each do |field_name, options|
              next unless field = cls.fields[field_name.to_s] || cls.fields.detect { |_, meta| meta.options[:as] == field_name.to_sym }.try(:last)
              next unless field.localized?
              next if mapping[field_name]&.frozen?
              mapping[field_name] = ::I18n.available_locales.each_with_object({ type: 'object', properties: {} }) do |locale, res|
                res[:properties][locale] = options.dup
              end
              mapping[field_name].freeze
            end
            mapping
          end
        end

        module Serializing
          def as_indexed_json(*args)
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

        included do
          def self.mapping(options = {}, &block)
            mappings = __elasticsearch__.mapping(options, &block)
            if mappings.is_a?(Elasticsearch::Model::Indexing::Mappings)
              if mapping = mappings.instance_variable_get(:@mapping)
                updated_mapping = ProcessMappings.call(self, mapping)
                mappings.instance_variable_set(:@mapping, updated_mapping)
              end
            end
            mappings
          end

          prepend Serializing
        end
      end
    end
  end
end
