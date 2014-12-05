# coding: utf-8

module Confuse
  # An {Item} is a class for storing a description piece of config.
  class Item
    def initialize(key, opts = {})
      @key = key
      @default, @description = opts.values_at(:default, :description)

      @converter = opts[:converter]
      @type = opts[:type]

      @required = opts.key?(:required) ? opts[:required] : true
    end

    attr_reader :description, :required, :converter

    def convert(value)
      converter.call(value)
    end

    def default(config)
      raise Errors::Undefined.new(@key) if @required && @default.nil?

      @default.respond_to?(:call) ? @default.call(config) : @default
    end

    def to_s
      default = if @default && !@default.respond_to?(:call)
                  "default: #{@default}"
                else
                  ''
                end
      "#{@key}:\t#{description} #{default}"
    end

    def to_hash
      {
        :description => @description,
        :default => @default
      }
    end

    private

    def type
      @type || type_from_default || String
    end

    def type_from_default
      unless @default.nil?
        case @default
        when TrueClass, FalseClass
          :bool
        when Proc
          String
        else
          @default.class
        end
      end
    end

    def converter
      @converter ||= Converter[type]
    end
  end
end
