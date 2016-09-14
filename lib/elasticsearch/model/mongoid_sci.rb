require 'active_support/concern'
require 'elasticsearch/model/mongoid_sci/version'

module Elasticsearch
  module Model
    module MongoidSci
      extend ActiveSupport::Concern

      included do
        # needs to be here in order to override the .search method from Elasticsearch::Model
        def self.search(query_or_payload, options = {})
          models = options.fetch(:models, (Array(self) + descendants))
          Elasticsearch::Model.search(query_or_payload, models, options)
        end
      end

      module ClassMethods
        def index_name_template(proc)
          @@index_name_template = proc
          index_name @@index_name_template.call(self)
        end

        def inherited(descendant)
          super(descendant)

          descendant.instance_eval do
            include Elasticsearch::Model
            # include Elasticsearch::Model::Callbacks
          end

          # propagate index_name_template
          descendant.index_name @@index_name_template.call(descendant) if defined?(@@index_name_template)

          # propagate settings
          descendant.settings settings.to_hash
        end

        def create_index!(options = {})
          __elasticsearch__.create_index!(options)
          descendants.each { |cls| cls.__elasticsearch__.create_index!(options) }
        end
      end

      def as_indexed_json(options = {})
        as_json options.deep_merge(except: %i(id _id))
      end
    end
  end
end
