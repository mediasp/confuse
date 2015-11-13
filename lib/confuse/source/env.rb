# coding: utf-8

module Confuse
  module Source
    class Env
      def initialize(options = {})
        @prefix = options[:prefix]
      end

      def [](namespace, key)
        lookup = key.to_s
        lookup = prepend(namespace, lookup) if namespace
        lookup = prepend(@prefix, lookup) if @prefix

        ENV[lookup.upcase]
      end

      private

      def prepend(pref, key)
        "#{pref}_#{key}" if pref
      end
    end

    register(:env, Env)
  end
end
