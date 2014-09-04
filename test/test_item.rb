# coding: utf-8

class TestItem < MiniTest::Unit::TestCase
  def setup
    @item = Confuse::Item.new(:foo, :default => 1, :description => 'Description')
  end

  def test_sets_the_default_value
    assert_equal 1, @item.default
  end

  def test_sets_the_description
    assert_equal 'Description', @item.description
  end

  def test_required_item
    item = Confuse::Item.new(:foo, :description => 'required!',
                                   :required => true)
    assert_raises(Confuse::Errors::Undefined) { item.default }
  end
end
