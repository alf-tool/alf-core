module Alf
  module Operator
    module Relational
      class Minus
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Semi::Hash.new(left, right, false, context)
        end

      end # class Minus
    end # Relational
  end # module Operator
end # module Alf
