require 'configuration'

class ExampleConfig < Configuration::ConfigBase
  define :foo do
    default 10
  end
end

puts ExampleConfig.new.foo
