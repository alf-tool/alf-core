module Alf
  module Operator
    module Relational
      class Union
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile
          op = Engine::Concat.new([left, right])
          op = Engine::Compact.new(op)
          op
        end

      end # class Union
    end # module Relational
  end # module Operator
end # module Alf
