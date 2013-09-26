require 'configuration/configurable'

# An example of adding configuration options to a class, seperated by
# namespaces.
class NamespaceExample
  configurable

  config_path 'example/002_namespace_example.ini'

  define :bar do
    description 'foo_bar'
    type :integer
    default 1
  end

  namespace :foo do
    define :bar do
      description 'bar_foo'
      type :string
      default 'Hello, world!'
    end
  end
end

example = NamespaceExample.new
puts example.config.inspect
puts example.bar
puts example.config[:foo_bar]
puts example.foo[:bar]
