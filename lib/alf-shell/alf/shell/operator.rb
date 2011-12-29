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

          # normalize operands
          operands = [ stdin_reader ] + Array(operands)
          operands = operands.map{|op| 
            Iterator.coerce(op, req && req.environment)
          }
          operands = if nullary?
            []
          elsif unary?
            [operands.last]
          elsif binary?
            operands[-2..-1]
          end

          init_args = [operands] + args + [options]
          operator_class.new(*init_args)
        end

      end # module ClassMethods

      # Defines a command for `clazz`
      def self.define_operator(clazz)
        superclass = Shell::Operator() do |b|
          b.callback do |cmd|
            cmd.operator_class = clazz
          end
        end
        Operator.const_set(Tools.class_name(clazz), Class.new(superclass)) 
      end
    
      Alf::Operator::Relational.each do |op_class|
        define_operator(op_class)
      end
    
      Alf::Operator::NonRelational.each do |op_class|
        define_operator(op_class)
      end
    
    end
  end
end
