module Alf
  module Operator
    module NonRelational
      class Sort
        include NonRelational, Unary

        signature do |s|
          s.argument :ordering, Ordering, []
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Sort.new(operand, ordering, context)
        end

      end # class Sort
    end # module NonRelational
  end # module Operator
end # module Alf
