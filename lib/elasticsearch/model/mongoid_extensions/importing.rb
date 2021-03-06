# NOTE: waiting for https://github.com/elastic/elasticsearch-rails/pull/625 to be merged

module Elasticsearch
  module Model
    module MongoidExtensions
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
