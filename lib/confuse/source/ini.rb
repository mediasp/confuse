# coding: utf-8

require 'inifile'

module Confuse
  module Source
    class Ini
      def initialize(options = {})
        @ini = from_file(options[:path])
      end

      def from_file(file)
        IniFile.load(file).to_h
      rescue IniFile::Error
        nil
      end

      def [](namespace, key)
        namespace ||= :global
        @ini[namespace.to_s][key.to_s]
      end
    end

    register(:ini, Ini)
  end
end
