# coding: utf-8

require 'minitest/autorun'
require 'confuse'

# Test {Confuse::Namespace}
class TestNamespace < MiniTest::Unit::TestCase
  def setup
    @namespace = Confuse::Namespace.new
  end

  def test_add_an_item
    @namespace.add_item(:foo, :default => :foo, :description => 'Test')
    refute_nil @namespace[:foo]
  end
end
