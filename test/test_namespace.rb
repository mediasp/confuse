# coding: utf-8

require 'minitest/autorun'
require 'confuse'

# Test {Confuse::Namespace}
class TestNamespace < MiniTest::Unit::TestCase
  def setup
    @namespace = Confuse::Namespace.new(nil)
  end

  def test_add_an_item
    @namespace.add_item(:foo, default: :foo, description: 'Test')
    refute_nil @namespace[:foo]
  end

  def test_to_hash
    namespace = Confuse::Namespace.new(nil) do |ns|
      ns.add_item :foo, description: 'how many foos?', default: 1
      ns.add_item :bar, description: 'how many bars?', default: 2
    end

    assert_equal(
      { foo: { description: 'how many foos?', default: 1 },
        bar: { description: 'how many bars?', default: 2 } },
      namespace.to_hash)
  end

  def test_to_hash_named_namespace
    namespace = Confuse::Namespace.new(:foo) do |ns|
      ns.add_item :foo, description: 'how many foos?', default: 1
      ns.add_item :bar, description: 'how many bars?', default: 2
    end

    assert_equal(
      { foo_foo: { description: 'how many foos?', default: 1 },
        foo_bar: { description: 'how many bars?', default: 2 } },
      namespace.to_hash)
  end
end
