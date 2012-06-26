module Alf
  module Operator
    module Relational
      class Matching
        include Operator, Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Semi::Hash.new(left, right, true, context)
        end

      end # class Matching
    end # module Relational
  end # module Operator
end # module Alf
