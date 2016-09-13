$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'

require 'elasticsearch/model/mongoid/sti'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }