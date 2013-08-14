module Alf
  module Algebra
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

      # Builds an option parser instance `opt` prepared for installing options on
      # `receiver`.
      #
      # @param [Hash|Operator] a receiver for option values
      # @param [OptionParser] opt the parser to fill with options
      # @return [OptionParser] `opt`
      def option_parser(receiver, opt = OptionParser.new)
        options.each do |option|
          name, dom, defa, descr = option
          opt.on(option_name(option), descr || "") do |val|
            if receiver.is_a?(Hash)
              receiver[name] = val
            else
              receiver.send(:"#{name}=", val)
            end
          end
        end
        opt
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
            instance_variable_set(:"@#{name}", Support.coerce(val, domain))
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
      # @return [Operator] installed `receiver`
      def parse_args(args, receiver)

        # 1) Check and set operands, passed as an array as first argument
        invalid_args!(args) unless args.first.is_a?(Array)
        receiver.send(:operands=, args.shift.map{|op| Operand.coerce(op)})

        # 2) Extract options if provided
        optargs = default_options
        if args.size == (1+arguments.size)
          # options are passed as last argument
          invalid_args!(args) unless args.last.is_a?(Hash)
          optargs = optargs.merge(args.pop)
        elsif args.size > arguments.size
          # too many arguments here
          invalid_args!(args)
        end

        # 3) Set options now, including default ones
        optargs.each_pair do |name,val|
          receiver.send(:"#{name}=", val)
        end

        # 4) Parse other arguments now
        with_each_arg(args) do |name,dom,value|
          invalid_args!(args) if value.nil?
          receiver.send(:"#{name}=", value)
        end

        receiver
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
      #     Alf::Algebra::Project.signature.to_shell
      #     # => "(project operand, attributes:AttrList, {allbut: Boolean})"
      def to_lispy
        cmd  = operator.rubycase_name
        oper = operator.nullary? ? "" :
              (operator.unary? ? "operand" : "left, right")

        args = arguments.map{|name,dom,_|
          dom.to_s =~ /::([A-Za-z]+)$/
          "#{name}:#{$1}"
        }.join(", ")
        args = (args.empty? ? "#{oper}" : "#{oper}, #{args}").strip

        opts = options.map{|name,dom,_|
          dom.to_s =~ /::([A-Za-z]+)$/
          "#{name}: #{$1}"
        }.join(', ')
        opts = opts.empty? ? "" : "{#{opts}}"

        argopt = [args, opts].select{|s| !s.empty?}.join(', ')
        "(#{cmd} #{argopt}".strip + ")"
      end

      private

      # @return the default options as a Hash
      def default_options
        @default_options ||=
          Hash[options.select{|opt| !opt[2].nil? }.
                       map{|opt| [opt[0], opt[2]]}]
      end

      # @return the name to use in shell for `option`
      def option_name(option)
        name, domain, defa, = option
        name = name.to_s.gsub(/_/, '-')
        domain == Boolean ? "--#{name}" : "--#{name}=#{name.upcase}"
      end

      # Yields `(name,dom,value)` triples for each argument value
      def with_each_arg(args)
        arguments.zip(args).map do |sigpart,subargs|
          name, dom, default = sigpart
          val = Array(subargs).empty? ? default : subargs
          yield(name, dom, val)
        end
      end

      def invalid_args!(args, msg = "Invalid `#{args.inspect}` for #{self}")
        raise ArgumentError, msg, caller
      end

    end # class Signature
  end # module Algebra
end # module Alf
