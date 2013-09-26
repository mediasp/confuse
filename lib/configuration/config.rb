require 'configuration/config_mixin'
require 'configuration/dsl'

module Configuration
  # The default module used for configuration.
  module Config
    extend ConfigMixin
  end

  # Super class for configuration in order to have multiple instances.
  class ConfigBase
    include ConfigMixin
    extend Configuration::DSL

    def initialize
      load_namespaces(self.class.namespaces)
      read_files(self.class.config_path)
    end

    def config
      self
    end
  end
end
