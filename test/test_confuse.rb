# coding: utf-8

require 'minitest/autorun'

class TestConfuse < MiniTest::Unit::TestCase
  def create_definition
    definition = Confuse.define do |d|
      d.add_item :foo, default: 1, description: 'Foo'
    end

    assert definition.instance_of Confuse::Definition
  end
end
