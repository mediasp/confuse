require 'confuse/config_mixin'
require 'confuse/dsl'

module Confuse
  # The default module used for configuration.
  module Config
    extend ConfigMixin
  end

  # Super class for configuration in order to have multiple instances.
  class ConfigBase
    include ConfigMixin
    extend DSL

    def namespaces
      @namespaces ||= {}
    end

    def initialize(options = {})
      load_namespaces(self.class.namespaces.clone)
      paths = options[:paths] || []
      load_defaults = begin
                        d = options[:load_defaults]
                        d.nil? ? true : d
                      end
      if paths.flatten.empty?
        read_files(self.class.config_path.flatten)
      else
        read_files(paths.flatten)
      end
    end

    def config
      self
    end
  end
end
