module Alf
  module Operator
    module NonRelational
      class Compact
        include NonRelational, Unary

        signature do |s|
        end

        # (see Operator#compile)
        def compile
          Engine::Compact.new(operand)
        end

      end # class Compact
    end # module NonRelational
  end # module Operator
end # module Alf
