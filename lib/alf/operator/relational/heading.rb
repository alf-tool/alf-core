module Alf
  module Operator
    module Relational
      class Heading
        include Operator, Relational, Unary, Experimental

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::InferHeading.new(operand, context)
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
