module Alf
  module Operator::Relational
    class Intersect < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#each)
      def each(&block)
        Engine::Join::Hash.new(left, right).each(&block)
      end

    end # class Intersect
  end # module Operator::Relational
end # module Alf
