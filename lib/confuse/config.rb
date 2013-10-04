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

    def initialize(*paths)
      load_namespaces(self.class.namespaces)
      read_files(self.class.config_path.flatten)
      read_files(paths.flatten)
    end

    def config
      self
    end
  end
end
