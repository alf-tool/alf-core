module Alf
  module Operator::Relational
    class Matching < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      def each(&block)
        Engine::Semi::Hash.new(left, right, true).each(&block)
      end

    end # class Matching
  end # module Operator::Relational
end # module Alf
