module Elasticsearch
  module Model
    module MongoidExtensions
      module SCI
        extend ActiveSupport::Concern

        included do
          include Elasticsearch::Model
        end

        module ClassMethods
          def index_name_template(proc)
            @@index_name_template = proc
            index_name @@index_name_template.call(self)
          end

          def document_type_template(proc)
            @@document_type_template = proc
            document_type @@document_type_template.call(self)
          end

          def inherited(descendant)
            super(descendant)

            descendant.instance_eval do
              include Elasticsearch::Model
            end

            # propagate index_name_template
            descendant.index_name @@index_name_template.call(descendant) if defined?(@@index_name_template)
            descendant.document_type @@document_type_template.call(descendant) if defined?(@@document_type_template)

            # propagate settings
            descendant.settings settings.to_hash

            # propagate mapping to all descendants
            mapping.instance_variable_get(:@mapping).each do |name, options|
              descendant.mapping do
                indexes(name, options)
              end
            end
          end

          def create_index!(options = {})
            res = Array(__elasticsearch__.create_index!(options))
            descendants.each { |cls| res << cls.__elasticsearch__.create_index!(options) }
            res.compact
          end

          def refresh_index!(options = {})
            res = Array(__elasticsearch__.refresh_index!(options))
            descendants.each { |cls| res << cls.__elasticsearch__.refresh_index!(options) }
            res.compact
          end

          def search(query_or_payload, options = {})
            models = options.fetch :models, [self] + descendants
            Elasticsearch::Model.search(query_or_payload, models, options)
          end

          def import(options = {}, &block)
            __elasticsearch__.import(options.merge(criteria: criteria.type(to_s)), &block) +
            subclasses.map { |cls| cls.import(options, &block) }.sum
          end
        end
      end
    end
  end
end
