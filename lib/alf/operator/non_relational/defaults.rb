module Alf
  module Operator
    module NonRelational
      class Defaults
        include NonRelational, Unary

        signature do |s|
          s.argument :defaults, TupleComputation, {}
          s.option   :strict,   Boolean, false, "Restrict to default attributes only?"
        end

        # (see Operator#compile)
        def compile
          op = Engine::Defaults.new(operand, defaults)
          op = Engine::Clip.new(op, defaults.to_attr_list, false) if strict
          op
        end

      end # class Defaults
    end # module NonRelational
  end # module Operator
end # module Alf
