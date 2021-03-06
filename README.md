# Confuse

This gem is used to simplify specifying and reading configuration.

You can define what you expect to be configured, and this can be read from ini
files, yaml files or environment variables.

## Installation

Add this line to your application's Gemfile:

    gem 'confuse'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configuration

## Usage

# Basic usage

    config = Confuse.config do |conf|
      conf.add_item :foo
    end

    config[:foo]

or

    config.foo

# Sources

You can choose where and your config is stored by passing a :path variable to
Confuse.config:

    config = Confuse.config :path => 'config.ini' do |conf|
      conf.add_item :foo
    end

Confuse will attempt to work out the type of file from the extension (Supports
.ini for ini files, and .yml or .yaml for yaml files). You can override this by
passing in a :type option:

    config = Confuse.config :path => 'foo.conf' :type => :yaml do |conf|
      conf.add_item :foo
    end

If no type or path is given, it will default to environment variables.
Environment variables have an an extra option, which is the ability to provide
a prefix:

    config = Confuse.config :prefix => 'FOO' do |conf|
      conf.add_item :foo
    end

This means Confuse will lookup environment varialbles with that prefix with an
underscore followed by the configuration name. If none is given, it will lookup
environment variables as is.

# Defaults

You can give a config item a default value, which will be used in cases where
none is set in the source.

    config = Confuse.config do |conf|
      conf.add_item :foo, :default => 1
    end

This can also be a proc that takes the config as an argument. This allows you
to set a value based on what another item is set to.

    config = Confuse.config do |conf|
      conf.add_item :foo, :default => 'foo'
      conf.add_item :bar, :default => proc { |c| "#{c.foo}_bar" }
    end

# Namespaces

You can separate your configuration into different namespaces:

    config = Confuse.config :type => :env do |conf|
      conf.add_namespace :foo do |ns|
        ns.add_item :foo
      end
    end

For simplicity, you can fetch these items using a single []:

    config[:foo_bar]

Or a method call:

    config.foo_bar

However, beware of adding an item at the top level with the same name.

# Types

You can specify the type of a configuration item.

    config = Confuse.config do |conf|
      conf.add_item :foo, :type => Fixnum
    end

This will ensure that any value is converted to the correct class when asked
for, or an error raised if it is the wrong type and it can't be converted.

If a default is given, the type will be derived from the class of the default,
unless the default is a Proc.

The following types are supported:
- String
- Fixnum
- Float
- Array
- :bool (a special case, because TrueClass and FalseClass do not share a unique
    common ancestor.)

Arrays can be used in sources that don't support arrays by supplying a comma
separated list.

If you wish to add support for another type, or even custom types. You can
register your own types if you wish:

    Confuse::Converter.register <type> do |item|
      ...
    end

The type can be anything, but it can only be derived from the default if a
class is used.

# Check

If you want to make sure all your configuration items are in place before
running the program you can call .check on it.

    config = Confuse.config do |conf|
      conf.add_item :foo
    end

    config.check

If any of the items haven't been set, and don't have a default value, or if an
item is the incorrect type, an exception will be thrown. If you don't care about
certain variables, you can pass :required => false to them (or give them a
default value).

# Use a different source

If you want to use a source that isn't an ini file or yaml file, or environment
variable. It is very easy to create your own one. It simply needs to be a class
that has an initialize that takes a hash, and a [] method that takes a
namespace and a key argument.

    class MyOwnSource
      def initialize(options = {})
        ...
      end

      def [](namespace, key)
        ...
      end
    end

    Confuse::Source.register(:foo, MyOwnSource)

    definition = Confuse.config, :type => :foo do |conf|
      conf.add_item :foo
    end

    config = Confuse::Config.new(definition, my_own_source)

If your class takes a :path variable, it will autodetect the extension for
whatever you register. You can register more than one extension if you wish.

You could use this to store data in whatever fancy file format you like, or
perhaps even a database table, or one of those fancy NoSQL datastores, you
could even write your config in Ruby code.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
