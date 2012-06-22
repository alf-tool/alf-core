module Alf
  module Operator
    module Relational
      class Union
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          op = Engine::Concat.new([left, right], context)
          op = Engine::Compact.new(op, context)
          op
        end

      end # class Union
    end # module Relational
  end # module Operator
end # module Alf
