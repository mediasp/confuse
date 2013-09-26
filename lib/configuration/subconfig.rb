module Configuration
  class Subconfig < Config
    class << self
      attr_accessor :parent_config
    end

    def self.parent(parent)
      self.parent_config = parent
    end
  end
end
