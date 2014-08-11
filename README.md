# DataMapper::PostgresTypes

Adds support for native PostgreSQL datatypes, including JSON, HSTORE, and ARRAY to DataMapper.

This gem replaces `dm-pg-types` with a cleaner/faster implementation of the Array and HStore datatypes, and adds support for the PostgreSQL's native JSON datatype (which means it is stored in the database differently than the JSON property offered by `dm-types`.

While `dm-postgres-types` is more or less compatible with the other implemenations, I recommend you create new fields and migrate any existing data instead of just changing the property type of existing models and hoping for the best. YMMV, of course.

On with the show...

## Installation

Add this line to your application's Gemfile:

    gem 'dm-postgres-types'

And then execute:

    $ bundle

## Usage

DataMapper::PostgresTypes defines 4 new `DataMapper::Property` classes that can be used when defining your schema. These properties take advantage of datatypes available in PostgreSQL 8.4+, and in the case of `DataMapper::Property::PgJSON`, PostgreSQL 9.2+. With that said, this gem is recommended for and has only been tested against PostgreSQL 9.3.

### DataMapper::Property::PgArray

Example:

````ruby
class MyModel
  include DataMapper::Resource

  property :id, Serial
  property :elements, PgArray
end

m = MyModel.new(elements: ['abc', 'def'])
m.elements
# => ["abc", "def"]
````

Use this property when you want to store an array of strings. This property doesn't have any options.

---

### DataMapper::Property::PgNumericArray

Example:

````ruby
class MyModel
  include DataMapper::Resource

  property :id, Serial
  property :decimals, PgNumericArray, scale: 5, precision: 2
end

m = MyModel.new(decimals: [1.13, 2.19, 5.11])
m.decimals
# => [1.13, 2.19, 5.11]
````
Use this property when you want to store an array of integers and/or floats.

Precision is the number of digits in your array's value(s). Scale is the number of digits to the right of the decimal point in your array's values. Set these options and PostgreSQL will cooerce your array's value(s) when it stores your array.

The default percision is `10` and the default scale is `0`, which is suitable for integers. Adjust the scale if you want to store float values instead.

---

### DataMapper::Property::PgHStore

Example:

````ruby
class MyModel
  include DataMapper::Resource

  property :id, Serial
  property :things, PgHStore
end

m = MyModel.new(things: { a: 'bcd', e: 'fgh' })
m.things
# => { "a" => "bcd", "e" => "fgh" }
````

Use this property when you want to store simple hash values. This property doesn't have any options. 

Please note: All hash keys will be returned as strings when your hash is loaded from the database, even if you supplied a hash with symbol keys when you saved it. If this is undesired, check out the `Hash#symbolize_keys` method provided by `ActiveSupport` ([link](http://rubygems.org/gems/activesupport)).

---

### DataMapper::Property::PgJSON

Example:

````ruby
class MyModel
  include DataMapper::Resource

  property :id, Serial
  property :data, PgJSON, load_raw_value: true
end

m = MyModel.new(data: { a: 'bcd', e: 'fgh' })
m.things
# => "{"a" => "bcd", "e" => "fgh" }
````

Use this property when you want to store your value, serialized as JSON. By default, the value will be deserialized back into a ruby datatype (e.g. `Hash` or `Array`) when loaded from the database. Set the `:load_raw_value` to `true`, as shown above, to get the raw JSON value as a string instead.

Please note: As of release 0.1.0, JSON de/serialization is now being handled by the `MultiJSON` gem for compatibility with the widest range of ruby interpreters. For best performance, the preferred implementation is the `Oj` gem.

## Contributing

1. Fork it ( http://github.com/xentek/dm-postgres-types/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Shout Outs

This library is heavily inspired by and borrows ideas and sometimes code from:
 - [dm-pg-types](https://github.com/svs/dm-pg-types)
 - [dm-types](https://github.com/datamapper/dm-types)
 - [dm-pg-json](https://github.com/styleseek/dm-pg-json)
