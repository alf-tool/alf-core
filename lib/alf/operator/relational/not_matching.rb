module Alf
  module Operator::Relational
    class NotMatching < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Semi::Hash.new(left, right, false)
      end

    end # class NotMatching
  end # module Operator::Relational
end # module Alf
