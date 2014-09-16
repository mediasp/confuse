# coding: utf-8

module Confuse
  class Converter
    class << self
      def converters
        @converters ||= { }
      end

      def register(key, &block)
        converters[key] = block
      end

      def [](key)
        converters[key]
      end
    end

    register(String) { |item| item.to_s }

    register Fixnum do |item|
      raise Errors::Invalid unless /^\d*$/.match item.to_s
      item.to_i
    end

    register Float do |item|
      raise Errors::Invalid unless /^\d*(\.\d*)?$/.match item.to_s
      item.to_f
    end

    register :bool do |item|
      raise Errors::Invalid unless %w(true false).include? item.to_s
      item.to_s == 'true'
    end

    register Array do |item|
      if item.respond_to? :to_ary
        item.to_ary
      elsif item.include? ','
        item.split(',')
      else
        raise Errors::Invalid
      end
    end
  end
end
