$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest'
require 'minitest/autorun'
require 'minitest/around'
require 'minitest/spec'

require 'elasticsearch/model/mongoid_extensions'

::I18n.available_locales = %i[en cs]

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
