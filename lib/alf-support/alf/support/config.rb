module Alf
  module Support
    class Config

      def self.delegation_methods
        public_instance_methods(false).reject{|m| m.to_s =~ /=$/ }
      end

      def self.helpers(to = :config)
        meths = delegation_methods
        Module.new do
          meths.each do |m|
            define_method(m){|*args, &bl| self.send(to).send(m, *args, &bl) }
          end
        end
      end

      def self.option(name, domain, default_value)
        getter_name = domain == Boolean ? :"#{name}?" : :"#{name}"
        setter_name = :"#{name}="
        ivar_name   = :"@#{name}"
        define_method(getter_name) do
          return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)
          default_value
        end
        define_method(setter_name) do |val|
          instance_variable_set(ivar_name, Support.coerce(val, domain))
        end
      end
      private_class_method :option

      # Creates a default options instance
      def initialize(h = {})
        install_options_from_hash(h)
      end

      # Merge with another options from a hash
      def merge(h)
        dup.install_options_from_hash(h)
      end

    protected

      def install_options_from_hash(h)
        h.each_pair do |k,v|
          install_single_option(k, v)
        end
        self
      end

      def install_single_option(k, v)
        unless self.class.public_method_defined?(setter = :"#{k}=")
          raise ConfigError, "No such option `#{k}`"
        end
        self.send(setter, v)
      rescue TypeError
        raise ConfigError, "Invalid option value `#{k}`: `#{v}`"
      end

    end # module Config
  end # module Support
end # module Alf
