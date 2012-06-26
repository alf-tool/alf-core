module Alf
  module Operator
    module NonRelational
      class Compact
        include Operator, NonRelational, Unary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Compact.new(operand, context)
        end

      end # class Compact
    end # module NonRelational
  end # module Operator
end # module Alf
