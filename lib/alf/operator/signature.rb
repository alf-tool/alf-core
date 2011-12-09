module Alf
  module Operator
    # Provides an operator signature
    class Signature

      # @return [Class] the operator class to which this signature belongs
      attr_reader :operator

      # @return [Array] signature arguments
      attr_reader :arguments

      # @return [Array] signature options
      attr_reader :options

      # Creates an empty signature instance
      #
      # @param [Class] the operator class to which this signature belongs
      def initialize(operator)
        @operator = operator
        @arguments = []
        @options = []
        yield(self) if block_given?
      end

      # Adds an argument to the signature
      #
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      def argument(name, domain, default = nil, descr = nil)
        arguments << [name, domain, default, descr]
      end

      # Adds an option to the signature
      # 
      # @param [Symbol] name argument name
      # @param [Class] domain argument domain
      # @param [Object] default (optional) default value
      def option(name, domain, default = nil, descr = nil)
        options << [name, domain, default, descr]
      end

      # Returns default options as a Hash
      #
      # @return [Hash] the default options
      def default_options
        @default_options ||=
          Hash[options.select{|opt| !opt[2].nil? }.
                       map{|opt| [opt[0], opt[2]]}]
      end

      # Fills an OptionParser instance according to signature options.
      #
      # @param [OptionParser] opt the parser to fill with options
      # @return [OptionParser] `opt`
      def fill_option_parser(opt, receiver)
        options.each do |option|
          name, dom, defa, descr = option
          opt.on(option_name(option), descr || "") do |val|
            receiver.send(:"#{name}=", val)
          end
        end
        opt
      end

      # Returns an option parser instance bound to a given `receiver` object
      #
      # @return [OptionParser] an parser instance, ready to parse options and
      #         install them on `receiver` 
      def option_parser(receiver)
        fill_option_parser(OptionParser.new, receiver)
      end

      # Installs the signature on the operator class
      #
      # This method installs an attr reader and an attr writer for each
      # signature argument and each signature option.
      #
      # @return [Hash] the default options to use
      def install
        clazz = operator
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

      # Parses arguments `args` passed to the operator `initialize` and 
      # sets attributes accordingly on `receiver`.
      #
      # @param [Array] args an array of initialize arguments
      # @param [Operator] receiver an operator instance
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

      # Parses arguments `argv` used to create an operator initialize from
      # commandline arguments and sets attributes accordingly on `receiver`.
      #
      # @param [Array] argv an array of commandline arguments
      # @param [Operator] receiver an operator instance
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

      # Collects signature values on a given operator.
      #
      # This methods returns a triple `[datasets, arguments, options]` with
      # the respective values collected on `op`.
      #
      # @param [Operator] op an operator, which should be an instance of 
      #                   `self.operator`
      # @return [Array] a triple [datasets, arguments, options] with operands, 
      #                 then signature values
      def collect_on(op)
        oper = op.operands
        args = arguments.map{|name,_| op.send(name) }
        opts = Hash[options.map{|name,dom,defa,_| 
          val = op.send(name)
          (val == defa) ? nil : [name, val]
        }.compact]
        [oper, args, opts]
      end

      # Returns a lispy synopsis for this signature
      #
      # Example:
      #
      #     Alf::Operator::Relational::Project.signature.to_shell
      #     # => "(project operand, attributes:AttrList, {allbut: Boolean})"
      def to_lispy
        cmd  = operator.command_name.to_s.gsub('-', '_')
        oper = operator.nullary? ? "" :
              (operator.unary? ? "operand" : "left, right")

        args = arguments.collect{|name,dom,_| 
          dom.to_s =~ /::([A-Za-z]+)$/
          "#{name}:#{$1}" 
        }.join(", ")
        args = (args.empty? ? "#{oper}" : "#{oper}, #{args}").strip

        opts = options.collect{|name,dom,_|
          dom.to_s =~ /::([A-Za-z]+)$/
          "#{name}: #{$1}" 
        }.join(', ')
        opts = opts.empty? ? "" : "{#{opts}}"

        argopt = [args, opts].select{|s| !s.empty?}.join(', ')
        "(#{cmd} #{argopt}".strip + ")"
      end

      # Returns a shell synopsis for this signature.
      #
      # Example:
      #
      #     Alf::Operator::Relational::Project.signature.to_shell
      #     # => "alf project [--allbut] [OPERAND] -- ATTRIBUTES"
      def to_shell
        oper = operator.nullary? ? "" :
              (operator.unary? ? "[OPERAND]" : "[LEFT] RIGHT")
        opts =   options.collect{|opt|   "[#{option_name(opt)}]" }.join(" ")
        args = arguments.collect{|arg,_| "#{arg.to_s.upcase}"    }.join(" -- ")
        optargs = "#{opts} #{oper} " + (args.empty? ? "" : "-- #{args}")
        "alf #{operator.command_name} #{optargs.strip}".strip
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
      
    end # class Signature
  end # module Operator
end # module Alf
