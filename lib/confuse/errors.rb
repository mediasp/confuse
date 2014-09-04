# coding: utf-8

module Confuse
  module Errors
    class Undefined < StandardError
      def initialize(name)
        @name = name
        super
      end
    end
  end
end
