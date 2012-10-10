module Alf
  class DatabaseOptionError < Alf::Error; end
  class Database
    class Options

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

      # Cache results of native schema queries?
      option :schema_cache, Boolean, true

      # What viewpoint to use by default?
      option :default_viewpoint, Module, Viewpoint::NATIVE

      # Creates a default options instance
      def initialize(h = {})
        install_options_from_hash(h)
      end

    private

      def install_options_from_hash(h)
        h.each_pair do |k,v|
          install_single_option(k, v)
        end
      end

      def install_single_option(k, v)
        unless Options.public_method_defined?(setter = :"#{k}=")
          raise DatabaseOptionError, "No such database option `#{k}`"
        end
        self.send(setter, v)
      rescue CoercionError
        raise DatabaseOptionError, "Invalid option value `#{k}`: `#{v}`"
      end

    end # class Options
  end # class Database
end # module Alf