module Alf
  module Operator
    module Relational
      class NotMatching
        include Operator, Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Semi::Hash.new(left, right, false, context)
        end

      end # class NotMatching
    end # module Relational
  end # module Operator
end # module Alf
