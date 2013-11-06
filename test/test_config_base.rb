require 'minitest/autorun'
require 'confuse'

class Foo < Confuse::ConfigBase
  define :foo do
    default 'foo'
    type :string
    description 'foo'
  end
end

class TestConfigBase < MiniTest::Unit::TestCase
  # This is easier to test with an instance of a config object, rather than as
  # part of the test for the module where other tests can modify the model.
  def test_params_hash
    assert_equal({ :default_foo  => { :type => :string, :doc => 'foo',
                                      :default => 'foo' } },
                 Foo.new.params_hash)
  end

  def test_can_specify_config_options_on_initialize
    config = Foo.new(:conf => { :foo => 'bar' })

    assert_equal 'bar', config[:foo]
  end

  def test_two_instances_can_exist_with_different_values
    # instatiate two versions of the config
    config1 = Foo.new
    config2 = Foo.new(:conf => { :foo => 'bar' })

    # assert config1 and config2 are different
    assert_equal 'foo', config1[:foo]
    assert_equal 'bar', config2[:foo]
  end
end

