module Alf
  module Operator::Relational
    class Intersect < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Join::Hash.new(left, right)
      end

    end # class Intersect
  end # module Operator::Relational
end # module Alf
