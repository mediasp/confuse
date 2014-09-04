# coding: utf-8

module Confuse
  class Config
    def initialize(definition, source)
      @definition = definition
      @source = source
    end

    def respond_to?(name)
      @definition.defines?(name) || super
    end

    def method_missing(name, *_args)
      self[name] if respond_to?(name)
    end

    def [](name)
      namespace, key = @definition.namespace_and_key(name)
      lookup(namespace, key)
    end

    def lookup(namespace, key)
      @source[namespace, key] || @definition.default(namespace, key)
    end

    # check items have a value. Will raise Undefined error if a required item
    # has no value.
    def check
      @definition.namespaces.each do |(namespace, ns)|
        ns.items.each do |key, _|
          lookup(namespace, key)
        end
      end
    end
  end
end
