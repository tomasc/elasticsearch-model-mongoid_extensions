# Elasticsearch::Model::Mongoid::STI

[![Build Status](https://travis-ci.org/tomasc/elasticsearch-model-mongoid-sti.svg)](https://travis-ci.org/tomasc/elasticsearch-model-mongoid-sti) [![Gem Version](https://badge.fury.io/rb/elasticsearch-model-mongoid-sti.svg)](http://badge.fury.io/rb/elasticsearch-model-mongoid-sti) [![Coverage Status](https://img.shields.io/coveralls/tomasc/elasticsearch-model-mongoid-sti.svg)](https://coveralls.io/r/tomasc/elasticsearch-model-mongoid-sti)

Set of [Elasticsearch::Model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model) mixins for support of STI of Mongoid classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch-model-mongoid-sti'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-model-mongoid-sti

## Usage

This gem makes sure that the following requirements, required to support indexing of full subclass tree of Mongoid classes, are met:

* `Elasticsearch::Model` && `Elasticsearch::Model::Callbacks` are included in all descending classes
* `document_type` is set on all descending classes
* `index_name` is the same for all descending classes
* mappings are propagated to all descending classes
* mappings of all descending classes are combined and used when creating new index
* search is performed across all descending classes

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/elasticsearch-model-mongoid-sti.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
