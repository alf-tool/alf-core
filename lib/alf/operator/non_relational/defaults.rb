module Alf
  module Operator
    module NonRelational
      class Defaults
        include Operator, NonRelational, Unary

        signature do |s|
          s.argument :defaults, TupleComputation, {}
          s.option   :strict,   Boolean, false, "Restrict to default attributes only?"
        end

        def heading
          raise NotSupportedError
        end

      end # class Defaults
    end # module NonRelational
  end # module Operator
end # module Alf
