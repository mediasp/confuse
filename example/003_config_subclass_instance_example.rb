require 'confuse'

class ExampleConfig < Confuse::ConfigBase
  define :foo do
    default 10
  end
end

puts ExampleConfig.new('example/003_config_subclass_instance.ini').foo
