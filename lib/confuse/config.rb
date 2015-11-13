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
      unless (item = @definition.find_item(namespace, key))
        fail Errors::Undefined.new(key)
      end

      value = @source[namespace, key] || item.default(self)

      item.convert(value)
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

    def to_hash
      @definition.to_hash.reduce({}) do |a, (k, v)|
        value_added = v.merge(value: self[k])
        a.merge(k => value_added)
      end
    end
  end
end
