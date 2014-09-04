# coding: utf-8

require 'minitest/autorun'

class TestKeySplitter < MiniTest::Unit::TestCase
  def test_key_with_no_underscore
    key_splitter = Confuse::KeySplitter.new(:foo)
    assert_equal 0, key_splitter.possible_namespaces.count
  end

  def test_key_with_one_underscore
    key_splitter = Confuse::KeySplitter.new(:foo_bar)
    assert_equal 1, key_splitter.possible_namespaces.count
    assert key_splitter.possible_namespaces.include? :foo
  end

  def test_key_with_many_underscores
    key_splitter = Confuse::KeySplitter.new(:foo_1_2_3_4_5_6_7_8_9)
    assert_equal 9, key_splitter.possible_namespaces.count
    assert key_splitter.possible_namespaces.include? :foo
    assert key_splitter.possible_namespaces.include? :foo_1
    assert key_splitter.possible_namespaces.include? :foo_1_2
    assert key_splitter.possible_namespaces.include? :foo_1_2_3
    assert key_splitter.possible_namespaces.include? :foo_1_2_3_4
    assert key_splitter.possible_namespaces.include? :foo_1_2_3_4_5
    assert key_splitter.possible_namespaces.include? :foo_1_2_3_4_5_6
    assert key_splitter.possible_namespaces.include? :foo_1_2_3_4_5_6_7
    assert key_splitter.possible_namespaces.include? :foo_1_2_3_4_5_6_7_8
  end

  def test_rest_of_key
    key_splitter = Confuse::KeySplitter.new(:foo_bar)
    assert_equal :bar, key_splitter.rest_of_key(:foo)
  end

  def test_rest_of_key_return_nil_if_namespace_doesnt_match
    key_splitter = Confuse::KeySplitter.new(:foo_bar)
    assert_nil key_splitter.rest_of_key(:baz)
  end

  def test_split
    key_splitter = Confuse::KeySplitter.new(:foo_1_2_3_4_5_6_7_8_9)
    assert key_splitter.split.include? [:foo, :"1_2_3_4_5_6_7_8_9"]
    assert key_splitter.split.include? [:foo_1, :"2_3_4_5_6_7_8_9"]
    assert key_splitter.split.include? [:foo_1_2, :"3_4_5_6_7_8_9"]
    assert key_splitter.split.include? [:foo_1_2_3, :"4_5_6_7_8_9"]
    assert key_splitter.split.include? [:foo_1_2_3_4, :"5_6_7_8_9"]
    assert key_splitter.split.include? [:foo_1_2_3_4_5, :"6_7_8_9"]
    assert key_splitter.split.include? [:foo_1_2_3_4_5_6, :"7_8_9"]
    assert key_splitter.split.include? [:foo_1_2_3_4_5_6_7, :"8_9"]
    assert key_splitter.split.include? [:foo_1_2_3_4_5_6_7_8, :"9"]
  end
end
