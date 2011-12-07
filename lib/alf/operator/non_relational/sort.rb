module Alf
  module Operator::NonRelational
    class Sort < Alf::Operator()
      include NonRelational, Unary

      signature do |s|
        s.argument :ordering, Ordering, []
      end

      def each(&block)
        Engine::Sort.new(input, ordering).each(&block)
      end

    end # class Sort
  end # module Operator::NonRelational
end # module Alf
