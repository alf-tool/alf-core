module Alf
  module Operator
    module Relational
      class Intersect
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile
          Engine::Join::Hash.new(left, right)
        end

      end # class Intersect
    end # module Relational
  end # module Operator
end # module Alf
