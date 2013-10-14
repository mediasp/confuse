module Confuse
  # A {ConfigItem} is a class for storing a single piece of config. It has a
  # key, a type, a description, and a default value.
  class ConfigItem
    attr_reader :key
    attr_writer :value

    def initialize(name, &block)
      @key = name
      instance_eval(&block) unless block.nil?
    end

    def description(description = nil)
      @description = description unless description.nil?
      @description
    end

    def type(type = nil)
      @type = type unless type.nil?
      @type
    end

    def default(value = nil, &block)
      @default_value = value unless value.nil?
      @default_value = block unless block.nil?
    end

    def value=(val)
      @value = val
    end

    def value
      @value || @default_value
    end
  end
end

