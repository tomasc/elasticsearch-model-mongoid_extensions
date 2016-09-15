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
          include Elasticsearch::Model::MongoidExtensions

          # FIXME: not so clean to override the mapping method on Elasticsearch::Model::Indexing::Mappings directly
          def self.mapping(options = {}, &block)
            @mapping ||= Mappings.new(document_type, { cls: self }.merge(options))
            @mapping.options.update(options) unless options.empty?

            return @mapping unless block_given?

            @mapping.instance_eval(&block)
            self
          end

          prepend Serializing
        end
      end
    end
  end
end
