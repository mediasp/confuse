module Configuration
  # A {ConfigItem} is a class for storing a single piece of config. It has a
  # key, a type, a description, and a default value.
  class ConfigItem
    attr_reader :key
    attr_writer :value

    def initialize(name, &block)
      @key = name
      instance_eval(&block)
    end

    def description(description = nil)
      @description = description unless description.nil?
      @description
    end

    def type(type = nil)
      @type = type unless type.nil?
      @type
    end

    def default(default = nil)
      @default = default unless default.nil?
      @default
    end

    def value
      @value || @default
    end
  end
end

