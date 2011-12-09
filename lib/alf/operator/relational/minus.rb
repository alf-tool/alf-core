module Alf
  module Operator::Relational
    class Minus < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Semi::Hash.new(left, right, false)
      end

    end # class Minus
  end # module Operator::Relational
end # module Alf
