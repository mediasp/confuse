# coding: utf-8

module Confuse
  class Definition
    def initialize(&block)
      @default_namespace = :default
      block.call(self)
    end

    def defines?(name)
      !!find_item_by_name(name)
    end

    def add_namespace(name, &block)
      new_namespace = Namespace.new(name, &block)
      namespaces[name.to_sym] = new_namespace
    end

    def add_item(name, opts = {})
      namespaces[@default_namespace].add_item(name, opts)
    end

    def namespaces
      @namespaces ||= {
        @default_namespace => Namespace.new(nil, &(Proc.new {}))
      }
    end

    def namespace_and_key(name)
      KeySplitter.new(name).split.find { |(ns, _)| namespaces[ns]  } ||
        [nil, name]
    end

    def find_item(namespace, key)
      (ns = find_namespace(namespace)) && ns[key]
    end

    def to_hash
      @namespaces.reduce({}) { |a, (_k, v)| a.merge(v) }
    end

    private

    def find_item_by_name(name)
      namespace, key = namespace_and_key(name)
    end

    def find_namespace(name)
      namespaces[name || @default_namespace]
    end
  end
end
