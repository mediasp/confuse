# coding: utf-8

module Confuse
  # A {Namespace} is a container to keep configuration data seperate from the
  # rest of the config.
  class Namespace
    attr_reader :items

    def initialize(name, &block)
      @name = name
      @items = {}
      block.call(self) if block_given?
    end

    def add_item(name, opts = {})
      @items[name] = Item.new(name, opts)
    end

    def [](key)
      @items[key]
    end

    def to_hash
      @items.reduce({}) do |a, (k,v)|
        key = @name ? :"#{@name}_#{k}" : k
        a.merge({ key => v.to_hash })
      end
    end
  end
end
