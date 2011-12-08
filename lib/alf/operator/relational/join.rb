module Alf
  module Operator::Relational
    class Join < Alf::Operator()
      include Relational, Binary

      signature do |s|
      end

      # (see Operator#each)
      def each(&block)
        Engine::Join::Hash.new(left, right).each(&block)
      end

    end # class Join
  end # module Operator::Relational
end # module Alf
