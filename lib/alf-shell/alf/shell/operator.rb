require 'forwardable'
module Alf
  module Shell
    module Operator

      module ClassMethods
        extend Forwardable

        attr_accessor  :operator_class
        def_delegators :operator_class, :signature,
                                        :relational?,
                                        :non_relational?,
                                        :experimental?,
                                        :nullary?,
                                        :unary?,
                                        :binary?

        def command?
          false
        end

        def operator?
          true
        end
      end

      module InstanceMethods
        extend Forwardable

        def_delegators :"self.class", :signature, :operator_class

        def run(argv, req = nil)
          @requester = req
          compile(argv)
        end

        def compile(argv)
          operands, args, options = signature.argv2args(argv)
          operands  = operands(operands, operator_class.arity)
          init_args = [operands] + args + [options]
          operator_class.new(*init_args)
        end

      end # module InstanceMethods


      # Defines a command for `clazz`
      def self.define_operator(op_name, op_class)
        superclass = Shell::Operator() do |b|
          b.callback do |cmd|
            cmd.operator_class = op_class
          end
        end
        Operator.const_set(::Alf::Support.class_name(op_class), Class.new(superclass))
      end

      Algebra::Operator.listen do |op_name, op_class|
        define_operator(op_name, op_class)
      end

    end # module Operator
  end # module Shell
end # module Alf
