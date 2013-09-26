require 'configuration/configurable'

# An example of adding configuration options to a class.
class SimpleExample
  configurable

  config_path 'example/001_simple_example.ini'

  define :foo do
    description   "How many Foo's are there?"
    type          :integer
    default       1
  end

end

example = SimpleExample.new
puts example.foo
