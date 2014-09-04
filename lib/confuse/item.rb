# coding: utf-8

module Confuse
  # An {Item} is a class for storing a description piece of config.
  class Item
    def initialize(key, opts = {})
      @key = key
      @default, @description = opts.values_at(:default, :description)
      @required = opts.key?(:required) ? opts[:required] : true
    end

    attr_reader :description, :required

    def default
      res = @default
      raise Errors::Undefined.new(@key) if @required && !res
      res
    end
  end
end
