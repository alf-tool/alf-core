module Alf
  module Operator
    module Relational
      class Unwrap
        include Relational, Unary

        signature do |s|
          s.argument :attribute, AttrName, :wrapped
        end

        # (see Operator#compile)
        def compile
          Engine::Unwrap.new(operand, attribute)
        end

      end # class Unwrap
    end # module Relational
  end # module Operator
end # module Alf
