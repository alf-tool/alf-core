module Alf
  module Tools
    # Provides an operator signature
    class Signature
      
      # @return [Array] signature arguments
      attr_reader :arguments

      # @return [Array] signature options
      attr_reader :options

      #
      # Creates a signature instance
      #
      def initialize(args = [])
        @arguments = args
        @options = []
        @descr = nil
        yield(self) if block_given?
      end

      #
      # Sets the description of the next argument or option.
      #
      # @param [String] descr the description to install on next element
      #
      def descr(descr)
        @descr = descr
      end

      #
      # Adds an argument to the signature
      #
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      #
      def argument(name, domain, default = nil)
        arguments << [name, domain, default, @descr]
        @descr = nil
        self
      end

      #
      # Adds an option to the signature
      # 
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      #
      def option(name, domain, default = nil)
        options << [name, domain, default, @descr]
        @descr = nil
        self
      end

      #
      # Fills an OptionParser instance according to signature options.
      #
      # @param [OptionParser] opt an parser instance, to fill with parse options
      # @return [OptionParser] `opt`
      #
      def fill_option_parser(opt, receiver)
        options.each do |name,domain,default,desc|
          if domain == Boolean
            opt.on("--#{name}", desc || "") do
              receiver.send(:"#{name}=", true)
            end
          else
            opt.on("--#{name}=#{name.to_s.upcase}", desc || "") do |val|
              receiver.send(:"#{name}=", val)
            end
          end
        end
        opt
      end

      #
      # Returns an option parser instance bound to a given `receiver` object
      #
      # @return [OptionParser] an parser instance, ready to parse options and
      #         install them on `receiver` 
      #
      def option_parser(receiver)
        fill_option_parser(OptionParser.new, receiver)
      end
      
      #
      # Installs the signature on `clazz` class 
      #
      # This method installs an attr reader and an attr writer for each
      # signature argument and each signature option.
      #
      # @param [Class] clazz a class on which the signature must be installed
      #
      def install(clazz)
        code = (arguments + options).each{|siginfo|
          name, domain, = siginfo
          clazz.send(:attr_reader, name)
          clazz.send(:define_method, :"#{name}=") do |val|
            instance_variable_set(:"@#{name}", Tools.coerce(val, domain))
          end
          clazz.send(:private, :"#{name}=")
        }
      end
      
      def from_xxx(args, coercer)
        arguments.zip(args).collect do |sigpart,subargs|
          name, dom, default = sigpart
          
          # coercion
          val = if Array(subargs).empty?
            Tools.coerce(default, dom)
          else
            dom.send(coercer, subargs)
          end
          
          # check and yield
          if val.nil?
            raise ArgumentError, "Invalid `#{subargs.inspect}` for #{sigpart.inspect}"
          else
            block_given? ? yield(name, val) : val
          end
        end
      end
      
      def from_args(args, &block)
        from_xxx(args, :coerce, &block)
      end
      
      def parse_args(args, receiver)
        from_args(args) do |name,val|
          receiver.send(:"#{name}=", val)
        end
      end
      
      def from_argv(argv, &block)
        from_xxx(argv, :from_argv, &block)
      end
      
      def parse_argv(argv, receiver)
        from_argv(argv) do |name,val|
          receiver.send(:"#{name}=", val)
        end
      end
      
      EMPTY = Signature.new
    end # class Signature
  end # module Tools
end # module Alf
