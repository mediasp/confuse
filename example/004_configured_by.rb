require 'configuration/config'
require 'configuration/configurable'
require 'singleton'

module ExampeConfig
  extend Configuration::ConfigMixin
  extend Configuration::DSL

  define :conf do
    default 2
  end
end

class Foo
  configured_by ExampleConfig

  default_namespace :foo

  define :bar do
    default 1
  end

end

foo = Foo.new
puts foo.config[:conf]
puts foo.bar

