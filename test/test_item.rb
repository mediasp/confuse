# coding: utf-8

class TestItem < MiniTest::Unit::TestCase
  def setup
    @item = Confuse::Item.new(:foo, default: 1,
                                    description: 'Description')
  end

  def test_sets_the_default_value
    assert_equal 1, @item.default(nil)
  end

  def test_sets_the_description
    assert_equal 'Description', @item.description
  end

  def test_required_item
    item = Confuse::Item.new(:foo, description: 'required!',
                                   required: true)
    assert_raises(Confuse::Errors::Undefined) { item.default(nil) }
  end

  def test_proc_as_default
    mock_conf = Class.new do
      def bar
        'bar'
      end
    end.new

    item = Confuse::Item.new(:foo, default: proc { |c| c.bar })

    assert_equal 'bar', item.default(mock_conf)
  end

  def test_to_hash
    assert_equal({ description: 'Description', default: 1 },
                 @item.to_hash)
  end

  def test_default_false
    item = Confuse::Item.new(:foo, default: false)

    assert_equal false, item.convert('false')
  end
end
