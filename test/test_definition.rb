# coding: utf-8

module Confuse
  class TestDefinition < MiniTest::Unit::TestCase
    def setup
      @definition = Confuse::Definition.new do |d|
        d.add_item :foo, :default => 1
        d.add_namespace :bar do |n|
          n.add_item(:foo, :default => 1, :description => 'test')
        end
      end
    end

    # can define a configuration item
    def test_define_item
      assert @definition.defines? :foo
    end

    # can define a namespace
    def test_define_namespace
      assert @definition.defines? :bar_foo
    end

    def test_default
      assert_equal 1, @definition.default(nil, :foo)
    end

    def test_default_for_namespaced_item
      assert_equal 1, @definition.default(:bar, :foo)
    end
  end
end
