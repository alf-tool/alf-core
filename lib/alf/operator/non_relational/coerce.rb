module Alf
  module Operator
    module NonRelational
      class Coerce
        include NonRelational, Unary

        signature do |s|
          s.argument :heading, Heading, {}
        end

        # (see Operator#compile)
        def compile
          Engine::Coerce.new(operand, heading)
        end

      end # class Coerce
    end # module NonRelational
  end # module Operator
end # module Alf
