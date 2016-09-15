require 'mongoid'
require 'elasticsearch/model'

require 'active_support/concern'
require 'elasticsearch/model/importing_monkey_patch'

require 'elasticsearch/model/mongoid_extensions/localized'
require 'elasticsearch/model/mongoid_extensions/sci'

require 'elasticsearch/model/mongoid_extensions/version'

module Elasticsearch
  module Model
    module MongoidExtensions
      # always exclude id fields from being serialised
      def as_indexed_json(options = {})
        as_json options.deep_merge(except: %i(id _id))
      end
    end
  end
end
