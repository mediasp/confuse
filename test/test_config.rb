# coding: utf-8

require 'minitest/autorun'

class TestConfig < MiniTest::Unit::TestCase
  def definition
    @definition ||= Confuse.define do |conf|
      conf.add_item :foo
      conf.add_item :bar, :default => 'default'
      conf.add_item :baz, :required => true
    end
  end

  def source
    @source ||= Class.new do
      def [](namespace, key)
        'foo' if key == :foo
      end
    end.new
  end

  def setup
    @config = Confuse::Config.new(definition, source)
  end

  # gets a value from the source if it is defined, and in the source
  def test_get_value_from_source
    assert_equal 'foo', @config.foo
  end

  # returns the default value if the source returns nil
  def test_get_default_from_definition
    assert_equal 'default', @config.bar
  end

  # raises undefined if an item hasn't been set, and has no default
  def test_get_default_from_definition
    assert_raises(Confuse::Errors::Undefined) { @config.buz }
  end

  # raises an error if any items are required and don't have defaults
  def test_check
    assert_raises(Confuse::Errors::Undefined) { @config.check }
  end
end
