module Alf
  module Operator
    module Relational
      class Extend
        include Operator, Relational, Unary

        signature do |s|
          s.argument :ext, TupleComputation, {}
        end

        # (see Operator#compile)
        def compile(context)
          Engine::SetAttr.new(operand, ext, context)
        end

      end # class Extend
    end # module Relational
  end # module Operator
end # module Alf
