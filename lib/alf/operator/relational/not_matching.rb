module Alf
  module Operator
    module Relational
      class NotMatching
        include Relational, Binary

        signature do |s|
        end

        # (see Operator#compile)
        def compile
          Engine::Semi::Hash.new(left, right, false)
        end

      end # class NotMatching
    end # module Relational
  end # module Operator
end # module Alf
