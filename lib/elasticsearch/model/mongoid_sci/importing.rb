require 'elasticsearch/model/adapters/mongoid'

module Elasticsearch
  module Model
    module Adapter
      module Mongoid
        module Importing
          def __find_in_batches(options = {})
            batch_size = options.fetch(:batch_size, 1_000)
            base_criteria = options.fetch(:criteria, all)

            base_criteria.no_timeout.each_slice(batch_size) do |items|
              yield items
            end
          end
        end
      end
    end
  end
end
