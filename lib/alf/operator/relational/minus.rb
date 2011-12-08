module Alf
  module Operator::Relational
    class Minus < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      def each(&block)
        Engine::Semi::Hash.new(left, right, false).each(&block)
      end

    end # class Minus
  end # module Operator::Relational
end # module Alf
