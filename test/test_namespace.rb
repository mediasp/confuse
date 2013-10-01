require 'minitest/autorun'
require 'confuse'

class TestNamespace < MiniTest::Unit::TestCase
  def setup
    @namespace = Confuse::Namespace.new do
      define :foo do
        default 1
      end
    end
  end

  def test_merge!
    namespace = Confuse::Namespace.new do
      define :bar do
        default 1
      end
    end

    @namespace.merge!(namespace)

    assert @namespace[:foo]
    assert @namespace[:bar]
  end
end
