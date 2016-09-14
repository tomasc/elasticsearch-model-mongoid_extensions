$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/around'
require 'minitest/spec'

require 'mongoid'
require 'elasticsearch/model'
require 'elasticsearch/rails'

require 'elasticsearch/model/mongoid_sci'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
