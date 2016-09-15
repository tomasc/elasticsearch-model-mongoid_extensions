require 'elasticsearch/model/indexing'

module Elasticsearch
  module Model
    module MongoidExtensions
      module Fields
        extend ActiveSupport::Concern

        included do
          mapping.define_singleton_method :to_fields do
            mapping_hash = to_hash[@type.to_sym]

            l = lambda do |h, parent = nil|
              res = []
              h.each do |field_name, props|
                key_type = Elasticsearch::Model::Indexing::Mappings::TYPES_WITH_EMBEDDED_PROPERTIES.include?(props[:type].to_s) ? :properties : :fields
                path = [parent, field_name].compact.join('.')
                res << path
                res += l.call(props[key_type], path) if props[key_type].present?
              end
              res.compact
            end

            l.call(mapping_hash[:properties]).map(&:to_s)
          end
        end
      end
    end
  end
end
