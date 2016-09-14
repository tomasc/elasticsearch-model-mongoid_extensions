$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/around'
require 'minitest/spec'

require 'elasticsearch/model/mongoid_extensions'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
