module Alf
  module Operator
    module NonRelational
      class Autonum
        include NonRelational, Unary

        signature do |s|
          s.argument :as, AttrName, :autonum
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Autonum.new(operand, as, context)
        end

      end # class Autonum
    end # module NonRelational
  end # module Operator
end # module Alf
