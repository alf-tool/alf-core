module Alf
  module Operator
    module Relational
      class Intersect
        include Operator, Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile(context)
          Engine::Join::Hash.new(left, right, context)
        end

      end # class Intersect
    end # module Relational
  end # module Operator
end # module Alf
