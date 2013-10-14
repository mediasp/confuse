require 'minitest/autorun'
require 'confuse'

class Foo < Confuse::ConfigBase
  define :foo do
    default 'foo'
  end
end

class TestConfigBase < MiniTest::Unit::TestCase
  def test_two_instances_can_exist_with_different_values
    # instatiate two versions of the config
    config1 = Foo.new
    config2 = Foo.new

    # change the values of one of them
    config1[:foo] = 'bar'

    # assert only one has changed
    assert_equal 'bar', config1[:foo]
    assert_equal 'foo', config2[:foo]
  end
end

