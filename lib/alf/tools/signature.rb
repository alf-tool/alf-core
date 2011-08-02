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
      def initialize
        @arguments = []
        @options = []
        yield(self) if block_given?
      end

      #
      # Adds an argument to the signature
      #
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      #
      def argument(name, domain, default = nil, descr = nil)
        arguments << [name, domain, default, descr]
      end

      #
      # Adds an option to the signature
      # 
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      #
      def option(name, domain, default = nil, descr = nil)
        options << [name, domain, default, descr]
      end

      #
      # Returns default options as a Hash
      #
      # @return [Hash] the default options
      #
      def default_options
        @default_options ||=
          Hash[options.select{|opt| !opt[2].nil? }.
                       collect{|opt| [opt[0], opt[2]]}]
      end

      #
      # Fills an OptionParser instance according to signature options.
      #
      # @param [OptionParser] opt an parser instance, to fill with parse options
      # @return [OptionParser] `opt`
      #
      def fill_option_parser(opt, receiver)
        options.each do |option|
          name, dom, defa, descr = option
          opt.on(option_name(option), descr || "") do |val|
            receiver.send(:"#{name}=", val)
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
      # @return [Hash] the default options to use
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
        default_options
      end
      
      def parse_args(args, receiver)
        invalid_args!(args) if args.size > (1+arguments.size)

        # Merge default and provided options
        optargs = default_options
        if args.size == (1+arguments.size)
          invalid_args!(args) unless args.last.is_a?(Hash)
          optargs = optargs.merge(args.pop)
        end

        # Set options
        optargs.each_pair do |name,val|
          receiver.send(:"#{name}=", val)
        end
        
        # Parse other arguments now
        parse_xxx(args, :coerce) do |name,val|
          receiver.send(:"#{name}=", val)
        end
      end
      
      def parse_argv(argv, receiver)
        # First split over --
        argv = Quickl.split_commandline_args(argv)

        # Set default options then parse those in first group
        default_options.each_pair do |name,val|
          receiver.send(:"#{name}=", val)
        end
        argv[0] = option_parser(receiver).parse!(argv[0])

        # Remove operands
        operands = argv.shift

        # Parse the rest
        parse_xxx(argv, :from_argv) do |name,val|
          receiver.send(:"#{name}=", val)
        end

        operands
      end

      def to_lispy_doc(operator = nil)
        ope = operator.unary? ? "operand" : "left, right"
        args = arguments.collect{|name,_| 
          name.to_s.upcase
        }.join(", ")
        (args.empty? ? 
          "#{ope}" : 
          "#{ope}, #{args}").strip
      end

      def to_shell_doc(operator = nil)
        ope = if operator
          operator.unary? ? "[OPERAND]" : "[LEFT] RIGHT"
        else
          "OPERANDS"
        end
        opts = options.collect{|option| 
          "[#{option_name(option)}]"
        }.join(" ")
        args = arguments.collect{|name,_| 
          name.to_s.upcase
        }.join(" -- ")
        (args.empty? ? 
          "#{opts} #{ope}" : 
          "#{opts} #{ope} -- #{args}").strip
      end

      private

      def option_name(option)
        name, domain, defa, = option
        domain == Boolean ? "--#{name}" : "--#{name}=#{name.to_s.upcase}"
      end

      def parse_xxx(args, coercer)
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
            yield(name, val)
          end
        end
      end
      
      def invalid_args!(args)
        raise ArgumentError, "Invalid `#{args.inspect}` for #{self}"
      end
      
      EMPTY = Signature.new
    end # class Signature
  end # module Tools
end # module Alf
