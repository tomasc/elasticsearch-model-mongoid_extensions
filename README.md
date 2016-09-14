# Elasticsearch::Model::MongoidSci

[![Build Status](https://travis-ci.org/tomasc/elasticsearch-model-mongoid_sci.svg)](https://travis-ci.org/tomasc/elasticsearch-model-mongoid_sci) [![Gem Version](https://badge.fury.io/rb/elasticsearch-model-mongoid_sci.svg)](http://badge.fury.io/rb/elasticsearch-model-mongoid_sci) [![Coverage Status](https://img.shields.io/coveralls/tomasc/elasticsearch-model-mongoid_sci.svg)](https://coveralls.io/r/tomasc/elasticsearch-model-mongoid_sci)

[Elasticsearch::Model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model) mixin that adds support for importing, indexing & search of Mongoid single collection inheritance classes by the way of separate indexes.

If your subclass tree shares same field definitions, you might prefer sharing one index (see the `inheritance_enabled` setting on [`ElasticSearch::Model`](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model#settings)). This gem splits subclasses into separate indexes which is beneficial in case the field definitions on your subclasses vary (as it may in document oriented databases such as Mongoid).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch-model-mongoid_sci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-model-mongoid_sci

## Usage

Include the `Elasticsearch::Model::MongoidSci` mixin in your baseclass.

```ruby
class MyDoc
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::MongoidSci

  field :field_1, type: String

  mapping do
    indexes :field_1
  end
end

class MyDoc1 < MyDoc
  field :field_2, type: String

  mapping do
    indexes :field_2
  end
end
```

The `MyDoc` class will use index with name `my_docs`, the `MyDoc1` subclass will use `my_doc_1s`. If you wish to customize the index name (prepend your application name, append Rails environment name etc.) see the configuration below.

## Configuration

### Index name

Optionally supply an `index_name_template` that will be automatically evaluated in context of each of the subclasses.

```ruby
class MyDoc
  # …
  index_name_template -> (cls) { ['elasticsearch-model-mongoid_sci', cls.model_name.plural].join('-') }
  # …
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/elasticsearch-model-mongoid_sci.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
