module Alf
  module Shell
    module Operator
      module ClassMethods

        attr_accessor :operator_class

        # Returns the ruby case name of this operator
        def rubycase_name
          Tools.ruby_case(Tools.class_name(self))
        end

        # @return false
        def command?
          false
        end

        # @return true
        def operator?
          true
        end

        # delegation to the class
        [ :signature,
          :relational?, :non_relational?, :experimental?,
          :nullary?, :unary?, :binary? ].each do |meth|
          define_method(meth) do |*args, &block|
            operator_class.send(meth, *args, &block)
          end
        end

        # Runs the command on commandline arguments `argv`
        #
        # @param [Array] argv an array of commandline arguments, typically ARGV
        # @param [Object] req an optional requester, typically a super command
        # @return [Iterator] an Iterator with query result
        def run(argv, req = nil)
          operands, args, options = signature.argv2args(argv)

          # find standard input reader
          stdin_reader = if req && req.respond_to?(:stdin_reader)
            req.stdin_reader
          else
            Reader.coerce($stdin)
          end

          # find database
          database = req && req.database

          # normalize operands
          operands = [ stdin_reader ] + Array(operands)
          operands = operands.map{|op|
            Iterator.coerce(op, database)
          }[(operands.size - operator_class.arity)..-1]

          init_args = [operands] + args + [options]
          operator_class.new(database, *init_args)
        end

      end # module ClassMethods

      # Defines a command for `clazz`
      def self.define_operator(op_name, op_class)
        superclass = Shell::Operator() do |b|
          b.callback do |cmd|
            cmd.operator_class = op_class
          end
        end
        Operator.const_set(Tools.class_name(op_class), Class.new(superclass))
      end

      Alf::Operator.listen do |op_name, op_class|
        define_operator(op_name, op_class)
      end

    end
  end
end
