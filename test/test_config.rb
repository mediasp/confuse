require 'minitest/autorun'
require 'confuse'

# Test instance methods
class TestConfig < MiniTest::Unit::TestCase
  def setup
    namespace = Confuse::Namespace.new do
      define :baz do
        default 1
      end
    end
    @config = Confuse::Config
    @config.load_namespaces({ :foo_bar => namespace })
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

  def test_load_namespaces
    namespace = Confuse::Namespace.new do
      define :foo do
        default 1
      end
    end

    @config.load_namespaces({ :foo_bar => namespace })

    assert @config[:foo_bar][:foo]
    assert @config[:foo_bar][:baz]
  end

  def test_to_hash
    config = Class.new(Confuse::ConfigBase) do
      define :foo do
        description 'Foo'
        type :integer
        default 1
      end
    end
    assert_nil config.new.to_hash[:default_foo]
    refute_nil config.new.to_hash[:foo]
  end

end

