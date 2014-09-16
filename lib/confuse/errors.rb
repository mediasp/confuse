# coding: utf-8

module Confuse
  module Errors
    class Undefined < StandardError
      def initialize(name)
        @name = name
        super
      end
    end

    class Invalid < StandardError; end
  end
end
