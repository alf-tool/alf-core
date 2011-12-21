module Alf
  module Operator
    module Relational
      class Ungroup
        include Relational, Unary

        signature do |s|
          s.argument :attribute, AttrName, :grouped
        end

        # (see Operator#compile)
        def compile
          Engine::Ungroup.new(operand, attribute)
        end

      end # class Ungroup
    end # module Relational
  end # module Operator
end # module Alf
