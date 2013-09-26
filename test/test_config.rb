require 'minitest/autorun'
require 'configuration/config'

# Test instance methods
class TestInstanceMethods < MiniTest::Unit::TestCase

  def setup
    @config = Configuration::Config
    @config.load_namespaces({ :foo_bar => true })
  end

  def test_find_namespace
    assert_equal :foo_bar, @config.find_namespace(:foo_bar_baz)
  end

  def test_fine_namespace_no_sub_key
    assert_equal :foo_bar, @config.find_namespace(:foo_bar)
  end

  def test_find_namespace_doesnt_exist
    assert_equal nil, @config.find_namespace(:bar)
  end

  def test_rest_of_key
    assert_equal :bar, @config.rest_of_key(:foo_bar, :foo)
  end

  def test_rest_of_key_default_namespace
    assert_equal :bar, @config.rest_of_key(:bar, :default)
  end

end
