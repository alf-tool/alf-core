module Alf
  module Operator::Relational
    class Wrap < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attributes, AttrList, []
        s.argument :as, AttrName, :wrapped
      end

      def each(&block)
        Engine::Wrap.new(input, attributes, as, false).each(&block)
      end

    end # class Wrap
  end # module Operator::Relational
end # module Alf
