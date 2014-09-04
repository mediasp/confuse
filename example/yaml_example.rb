#!/usr/bin/env ruby
# coding: utf-8

require 'confuse'

config = Confuse.config :path => 'example/example.yaml' do |conf|

  conf.add_item :foo, :description => "How many Foo's are there?", :default => 1
end

puts config.foo
