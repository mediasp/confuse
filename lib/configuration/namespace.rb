require 'configuration/config_item'

module Configuration
  # A {Namespace} is a container to keep configuration data seperate from the
  # rest of the config.
  class Namespace

    attr_reader :items, :error_level

    def initialize(&block)
      @items = {}
      @error_level = 0
      instance_eval(&block)
    end

    def define(name, &block)
      @items[name] = ConfigItem.new(name, &block)
    end

    # This is really ugly.
    # TODO: don't use magic numbers.
    def supress_warnings
      raise 'Cannot supress warnings while in strict mode' if @error_level > 0
      @error_level = -1
    end

    def strict
      raise 'Cannot supress warnings while in strict mode' if @error_level < 0
      @error_level = 1
    end

    def [](key)
      get_item(key).value
    end

    def []=(key, value)
      item = get_item(key)
      unless item
        warn(key)
        item = ConfigItem.new(key, &(Proc.new {}))
      end
      item.value = value
    end

    def warn(key)
      message = "config includes unknown option '#{key}'"
      if error_level == 0
        puts "Warning: #{message}"
      elsif error_level > 0
        puts "Error: #{message}"
        exit
      end
    end

    def get_item(key)
      @items[key]
    end

    def merge!(namespace)
      @error_level = namespace.error_level
      @items.merge! namespace.items
    end

  end
end
