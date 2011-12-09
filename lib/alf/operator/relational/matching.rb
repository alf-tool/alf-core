module Alf
  module Operator::Relational
    class Matching < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Semi::Hash.new(left, right, true)
      end

    end # class Matching
  end # module Operator::Relational
end # module Alf
