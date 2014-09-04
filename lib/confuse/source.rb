# coding: utf-8

module Confuse
  module Source
    class << self
      def types
        @types ||= { }
      end

      def create(options = {})
        path = options[:path]

        type = if path
                 path[path.rindex('.') + 1, path.length].to_sym
               end
        type ||= options[:type]

        if type
          types[type].new(options)
        else
          Env.new(options)
        end
      end

      def register(type, klass)
        types[type] = klass
      end
    end
  end
end

require 'confuse/source/ini'
require 'confuse/source/yaml'
require 'confuse/source/env'
