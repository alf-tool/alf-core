module Alf
  module Operator::Relational
    class Join < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#compile)
      def compile
        Engine::Join::Hash.new(left, right)
      end

    end # class Join
  end # module Operator::Relational
end # module Alf
