# coding: utf-8

require 'yaml'

module Confuse
  module Source
    class Yaml
      def initialize(options = {})
        @yaml = ::YAML.load_file(options[:path])
      end

      def [](namespace, key)
        namespace ? @yaml[namespace][key] : @yaml[key]
      end
    end

    register(:yml, Yaml)
    register(:yaml, Yaml)
  end
end
