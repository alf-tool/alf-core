module Alf
  module Lang
    module ObjectOriented
      module AlgebraMethods

        def self.def_operator_method(name, clazz)
          define_method(name) do |*args|
            args.unshift(_self_operand)
            operands, arguments = args[0...clazz.arity], args[clazz.arity..-1]
            _operator_output clazz.new(operands, *arguments)
          end
        end

        Algebra::Operator.listen do |name, clazz|
          def_operator_method(name, clazz)
        end

        def allbut(attributes)
          project(attributes, :allbut => true)
        end

        def +(other)
          union(other)
        end
        alias :| :+

        def -(other)
          minus(other)
        end

        def *(other)
          join(other)
        end

        def &(other)
          intersect(other)
        end

        def =~(other)
          matching(other)
        end

        def !~(other)
          not_matching(other)
        end

        def tuple_extract
          tuple = nil
          each do |t|
            raise NoSuchTupleError if tuple
            tuple = t
          end
          tuple ||= yield if block_given?
          raise NoSuchTupleError unless tuple or block_given?
          Tuple(tuple)
        end
        alias_method :'tuple!', :tuple_extract

      private

        def _self_operand
          self
        end

        def _operator_output(op)
          op
        end

      end # module AlgebraMethods
    end # module ObjectOriented
  end # module Lang
end # module Alf
