require 'configuration'

# Monkey patch class to easily allow a class to be configurable.
class Class
  def configurable
    extend Configuration::DSL
    include Configuration::InstanceMethods
  end

  def configured_by(config)
    configurable
    @configured_by = config
  end
end

