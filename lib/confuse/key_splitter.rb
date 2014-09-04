# coding: utf-8

module Confuse
  # This class encapsulates the code required to support searching for items
  # with a single key item even for nested items.
  # config[:foo_bar] instead of config[:foo][:bar]
  class KeySplitter
    def initialize(key)
      @key = key
    end

    def split
      possible_namespaces.map do |ns|
        [ns, rest_of_key(ns)]
      end
    end

    # Returns an array of possible namespaces based on splitting the key at
    # every underscore.
    def possible_namespaces
      namespaces = []
      key = @key.to_s
      while (index = key.rindex('_'))
        key = key[0, index]
        namespaces << key.to_sym
      end
      namespaces
    end

    # Returns the rest of the key for a given namespace
    def rest_of_key(namespace)
      return nil if @key == namespace

      key = @key.to_s

      index = key.index(namespace.to_s) && (namespace.to_s.length + 1)
      key[index, key.length].to_sym if index
    end
  end
end
