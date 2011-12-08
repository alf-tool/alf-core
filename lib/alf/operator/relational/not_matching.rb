module Alf
  module Operator::Relational
    class NotMatching < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      def each(&block)
        Engine::Semi::Hash.new(left, right, false).each(&block)
      end

    end # class NotMatching
  end # module Operator::Relational
end # module Alf
