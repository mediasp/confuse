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

    def test_to_hash
      assert_equal(
        { :foo => { :description => nil, :default => 1 },
          :bar_foo => { :description => 'test', :default => 1 } },
        @definition.to_hash)
    end
  end
end
