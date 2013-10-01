require 'configuration/config_item'

module Configuration
  # A {Namespace} is a container to keep configuration data seperate from the
  # rest of the config.
  class Namespace

    attr_reader :items, :supress_warnings_flag, :strict_flag

    def initialize(&block)
      @items = {}
      @supress_warnings = false
      @strict = false
      instance_eval(&block)
    end

    def define(name, &block)
      @items[name] = ConfigItem.new(name, &block)
    end

    def supress_warnings
      @supress_warnings_flag = true
    end

    def strict
      @strict_flag = true
    end

    def [](key)
      (i = get_item(key)) && i.value
    end

    def []=(key, value)
      item = get_item(key) || create_new_key(key, value)
      item && item.value = value
    end

    def create_new_key(key, value)
      if @supress_warnings_flag
        puts "Warning: config includes unknown option '#{key}'"
      end
      @items[key] = ConfigItem.new(key, &(Proc.new {})) unless @strict_flag
    end

    def get_item(key)
      @items[key]
    end

    def merge!(namespace)
      @strict_flag = namespace.strict
      @supress_warnings_flag = namespace.supress_warnings
      @items.merge! namespace.items
    end

  end
end
