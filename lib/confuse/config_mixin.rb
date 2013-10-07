require 'confuse/namespace'
require 'inifile'
require 'yaml'

module Confuse
  # Mixin for configuration.
  module ConfigMixin
    def namespaces
      @namespaces ||= {}
    end

    def load_namespaces(new_namespaces)
      new_namespaces.each do |key, value|
        existing = namespaces[key]
        existing ? existing.merge!(value) : namespaces[key] = value
      end
    end

    def read_files(file_paths)
      Array(file_paths).map do |path|
        if File.directory?(path)
          load_config_dir(path)
        elsif File.exists?(path)
          load_config_file(path)
        end
      end.flatten.compact.each { |c| mixin_config!(c) }
    end

    def [](key)
      namespace = find_namespace(key) || :default
      rest_of_key = rest_of_key(key, namespace)
      ns = namespaces[namespace]
      return ns unless rest_of_key
      ns[rest_of_key, self]
    end

    def to_hash
      namespaces.reduce({}) do |memo, (name, namespace)|
        namespace.keys.each do |key|
          memo[:"#{name}_#{key}"] = namespace[key, self]
        end
        memo
      end
    end

    # We allow the namespace and the key to be concatenated with an '_', so this
    # method is to search the possible substrings that could make up the
    # namespace for a key.
    #
    # This does not guarentee that the suffix of the namespace that is found is
    # a valid key in that namespace.
    #
    # @param [Symbol] key to search
    def find_namespace(key)
      until key.to_s.empty? || @namespaces[key.to_sym]
        key = (s = key.to_s)[0, s.rindex('_') || 0]
      end
      key.to_s.empty? ? nil : key.to_sym
    end

    # Once we've found the namespace, we want to find the rest of the string
    # to use as the rest of the key. If the namespace isn't a substring of the
    # key (e.g. :default), we return the key unaltered.
    #
    # @param [Symbol] key The full key
    # @param [Symbol] namespace The substring of the key that is the
    # namespace.
    def rest_of_key(key, namespace)
      key_s = key.to_s
      namespace_s = namespace.to_s
      return nil if key_s == namespace_s
      index = key_s.index(namespace_s) && (namespace_s.length + 1)
      key_s[index || 0, key_s.length].to_sym
    end

    def load_config_dir(config_dir)
      Dir[config_dir + '/*.{ini,conf,yaml}'].map do |conf_file|
        load_config_file(conf_file)
      end
    end

    def load_config_file(conf_file)
      conf = load_ini(conf_file) || load_yaml(conf_file)
      raise "Can't parse #{conf_file}" unless conf
      conf
    end

    def mixin_config!(config)
      config.each do |key, value|
        namespace_name = find_namespace(key) || :default
        namespace = @namespaces[namespace_name]
        if value.respond_to?(:keys)
          # if its a hash, set each key in the hash as a config item in the
          # namespace
          value.each do |k, v|
            namespace[k] = v
          end
        else
          # otherwise, set it directly in the namespace
          namespace[rest_of_key(key, namespace_name)] = value
        end
      end
    end

    def load_ini(file)
      begin
        # make sure they keys are ruby symbols
        symbolise_hash_keys(IniFile.load(file).to_h)
      rescue IniFile::Error
        nil
      end
    end

    def symbolise_hash_keys(hash)
      hash.reduce({}) do |memo, (key, val)|
        memo[key.to_sym] =
        val.respond_to?(:reduce) ? symbolise_hash_keys(val) : val
      memo
      end
    end

    def load_yaml(file)
      YAML.load(File.read(file))
    end

  end
end
