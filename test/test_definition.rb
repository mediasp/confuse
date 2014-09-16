# coding: utf-8

module Confuse
  class TestDefinition < MiniTest::Unit::TestCase
    def setup
      @definition = Confuse::Definition.new do |d|
        d.add_item :foo, :default => 1
        d.add_namespace :bar do |n|
          n.add_item(:foo, :default => 1, :description => 'test')
        end
        d.add_item :baz, :default => proc { |c| c.foo }
      end
    end

    def source
      @source ||= Confuse.source
    end

    def config
      @config ||= Confuse::Config.new(@definition, source)
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
      assert_equal 1, @definition.default(nil, :foo, nil)
    end

    def test_default_for_namespaced_item
      assert_equal 1, @definition.default(:bar, :foo, nil)
    end

    def test_default_with_proc
      assert_equal 1, @definition.default(nil, :baz, config)
    end
  end
end
