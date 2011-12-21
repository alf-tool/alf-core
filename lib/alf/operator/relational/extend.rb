module Alf
  module Operator
    module Relational
      class Extend
        include Relational, Unary

        signature do |s|
          s.argument :ext, TupleComputation, {}
        end

        # (see Operator#compile)
        def compile
          Engine::SetAttr.new(operand, ext)
        end

      end # class Extend
    end # module Relational
  end # module Operator
end # module Alf
