# coding: utf-8

require 'confuse/version'

require 'confuse/key_splitter'
require 'confuse/config'
require 'confuse/item'
require 'confuse/definition'
require 'confuse/namespace'
require 'confuse/source'
require 'confuse/errors'

# Top level namespace for confuse gem
module Confuse
  class << self
    def define(&block)
      Definition.new(&block)
    end

    def source(options = {})
      Source.create(options)
    end

    def config(options = {}, &block)
      definition = Definition.new(&block)
      source = Source.create(options)
      Config.new(definition, source)
    end
  end
end
