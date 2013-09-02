module Alf
  module Support
    class Config

      module ClassMethods

        def options
          @options ||= []
        end

        def each_option(&bl)
          options.each(&bl)
        end

        def delegation_methods
          public_instance_methods(false).reject{|m| m.to_s =~ /=$/ }
        end

        def helpers(to = :config)
          meths = delegation_methods
          Module.new do
            meths.each do |m|
              define_method(m){|*args, &bl| self.send(to).send(m, *args, &bl) }
            end
          end
        end

        def option(name, domain, default_value)
          options << [name, domain, default_value]
          getter_name = self.getter_name(name, domain)
          setter_name = self.setter_name(name)
          ivar_name   = self.ivar_name(name)
          define_method(getter_name) do
            value = instance_variable_defined?(ivar_name) \
                  ? instance_variable_get(ivar_name)
                  : default_value
            value.is_a?(Proc) && domain != Proc ? instance_exec(&value) : value
          end
          define_method(setter_name) do |val|
            val = val.is_a?(Proc) ? val : Support.coerce(val, domain)
            instance_variable_set(ivar_name, val)
          end
        end

        def getter_name(option, domain)
          domain == Boolean ? :"#{option}?" : :"#{option}"
        end

        def setter_name(option)
          :"#{option}="
        end

        def ivar_name(option)
          :"@#{option}"
        end

        def option_get(conf, name)
          option = options.find{|(n,_,_)| n == name }
          raise ConfigError, "No such option `#{name}`" unless option
          conf.send(getter_name(option[0], option[1]))
        end

        def option_set(conf, name, value)
          option = options.find{|(n,_,_)| n == name }
          raise ConfigError, "No such option `#{name}`" unless option
          conf.send(setter_name(option[0]), value)
        end

      end
      extend(ClassMethods)
      private_class_method :option

      # Creates a default options instance
      def initialize(h = {})
        install_options_from_hash(h)
        yield(self) if block_given?
      end

      # Returns the value of an option
      def [](option)
        self.class.option_get(self, option)
      end

      # Sets the value of an option
      def []=(option, value)
        self.class.option_set(self, option, value)
      end

      # Merge with another options from a hash
      def merge(h)
        dup.install_options_from_hash(h)
      end

      # Duplicates this configuration as well as all option values
      def dup
        super.tap do |c|
          self.class.each_option do |name,_,default|
            ivar_name = self.class.ivar_name(name)
            if instance_variable_defined?(ivar_name) || !default.is_a?(Proc)
              c[name] = (self[name].dup rescue self[name])
            end
          end
        end
      end

      # Freeze this configuration as well as all option values
      def freeze
        super
        self.class.each_option do |name,_,_|
          self[name].freeze
        end
        self
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
