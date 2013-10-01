require 'confuse/config'

module Confuse
  # DSL for setting up a configurable class
  module DSL
    attr_reader :configured_by

    def configured_by(config = Config)
      @configured_by ||= config
    end

    def default_namespace(namespace = :default)
      @default_namespace ||= namespace
    end

    def config_path(*paths)
      @config_path ||= []
      @config_path.concat paths
    end

    def namespaces
      @namespaces ||= {
        default_namespace => Namespace.new(&(Proc.new { }))
      }
    end

    def define(name, &block)
      namespaces[default_namespace].define(name, &block)
      getter(name, default_namespace)
    end

    def namespace(name, &block)
      new_namespace = Namespace.new(&block)
      if namespaces[name.to_sym]
        namespaces[name.to_sym].merge! new_namespace
      else
        namespaces[name.to_sym] = new_namespace
      end
      getter(name)
    end

    def getter(name, namespace = nil)
      class_eval do
        if namespace.nil?
          define_method(name) do
            config[name]
          end
        else
          define_method(name) do
            config[namespace][name, config]
          end
        end
      end
    end

  end

  # Instance methods for getting the defined configuration from an instance of
  # a configured class.
  module InstanceMethods
    # Lazilly create the config object when it is first requested.
    def config
      self.class.configured_by.load_namespaces(self.class.namespaces)
      self.class.configured_by.read_files(self.class.config_path)
      self.class.configured_by
    end
  end
end
