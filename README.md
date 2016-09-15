# Elasticsearch::Model::MongoidExtensions

[![Build Status](https://travis-ci.org/tomasc/elasticsearch-model-mongoid_extensions.svg)](https://travis-ci.org/tomasc/elasticsearch-model-mongoid_extensions) [![Gem Version](https://badge.fury.io/rb/elasticsearch-model-mongoid_extensions.svg)](http://badge.fury.io/rb/elasticsearch-model-mongoid_extensions) [![Coverage Status](https://img.shields.io/coveralls/tomasc/elasticsearch-model-mongoid_extensions.svg)](https://coveralls.io/r/tomasc/elasticsearch-model-mongoid_extensions)

[Elasticsearch::Model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model) extensions for Mongoid adding support of [single collection inheritance](#sci) (by the way of multiple indexes), [localized fields](#localized) and [mapped fields extraction](#fields).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch-model-mongoid_extensions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-model-mongoid_extensions

## Usage

### SCI

Using a separate index per each subclass is beneficial in case the field definitions vary across the subclasses (as it may in document oriented databases such as Mongoid). On the contrary sharing an index for all subclasses might lead into conflicts with different mappings of fields with same name.

If your subclass tree shares same field definitions, you might prefer use only one index (see the `inheritance_enabled` setting on [`ElasticSearch::Model`](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model#settings)).

#### Setup

```ruby
class MyDoc
  include Mongoid::Document
  include Elasticsearch::Model::MongoidExtensions::SCI

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

The `MyDoc` class will use index with name `my_docs`, the `MyDoc1` subclass will use `my_doc_1s`. If you wish to customize the index name (prepend application name, append Rails environment name etc.) supply an `index_name_template` that will be automatically evaluated in context of each of the subclasses.

```ruby
class MyDoc
  # …
  index_name_template -> (cls) { ['elasticsearch-model-mongoid_extensions', cls.model_name.plural].join('-') }
  # …
end
```

#### Index creation & refresh

Use the class methods defined on the base class to create/refresh indexes for all descending classes as well:

```ruby
MyDoc.create_index! # will trigger MyDoc1.create_index! as well
MyDoc.refresh_index! # will trigger MyDoc1.refresh_index! as well
```

#### Importing

Import on base class (here `MyDoc`) imports all documents of descending classes as well:

```ruby
MyDoc.import # will trigger MyDoc1.import as well
```

#### Indexing

Indexing works as expected using the standard proxied methods:

```ruby
my_doc.__elasticsearch__.index_document
my_doc.__elasticsearch__.update_document
my_doc.__elasticsearch__.delete_document
```

#### Search

Search on base class searches descendants as well:

```ruby
MyDoc.search('*') # will search MyDoc1 as well
```

Use the `type` option to limit the searched classes:

```ruby
MyDoc.search('*', type: [MyDoc.document_type]) # will search only MyDoc
```

### Localized

By including the `Localized` module, all Mongoid localized fields will be automatically mapped and serialized as objects:

```ruby
class MyDoc3
  # …
  include Elasticsearch::Model::MongoidExtensions::Localized

  field :field_3, type: String, localize: true

  mapping do
    indexes :field_3
  end
  # …
end
```

#### Mapping

The mapping will be altered, so that fields that would be originally mapped as:

```
{ 'field_1' => { 'type' => 'string' } }
```

Are automatically transformed to:

```
{ 'field_1' => { 'type' => 'object', 'properties' => { 'en' => { 'type' => 'string' } } } }
```

This happens for all `I18n.available_locales`.

#### Serializing

The `:as_indexed_json` is automatically transformed behind the scenes to correspond with the mapping. Therefore it can be specified as usual:

```ruby
def as_indexed_json(options = {})
  super(only: %i(field_1))
end
```

The result automatically becoming:

```
{ 'field_1' => { 'en' => 'value_en', 'cs' => 'value_cs' } }
```

TODO: it might be helpful to add support for the I18n's fallbacks, so that missing value is correctly replaced by a fallback.

### Fields

The fields extension adds `to_fields` method on class `mappings` that returns all fields names as they are mapped in Elasticsearch. This is especially useful in combination with the `Localized` mixin as it allows to select only fields for a particular locale and use those when searching.

Having document with the following mapping:

```ruby
class MyDocFields
  # …
  include Elasticsearch::Model::MongoidExtensions::Fields
  # …
  mapping do
    indexes :field_1
    indexes :field_2 do
      indexes :number, type: :integer, index: :not_analyzed
      indexes :string, type: :string, index: :not_analyzed
    end
  end
end
```

The `#to_fields` returns:

```ruby
MyDocFields.mapping.to_fields # => ["field_1", "field_2", "field_2.number", "field_2.string"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomasc/elasticsearch-model-mongoid_extensions.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
