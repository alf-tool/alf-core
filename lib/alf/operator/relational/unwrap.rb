module Alf
  module Operator::Relational
    class Unwrap < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :wrapped
      end

      # (see Operator#each)
      def each(&block)
        Engine::Unwrap.new(input, attribute).each(&block)
      end

    end # class Unwrap
  end # module Operator::Relational
end # module Alf
