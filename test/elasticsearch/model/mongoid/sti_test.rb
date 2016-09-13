require 'test_helper'

class Elasticsearch::Model::Mongoid::StiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Elasticsearch::Model::Mongoid::STI::VERSION
  end
end
