module Alf
  module Operator::Relational
    class Ungroup < Alf::Operator()
      include Relational, Unary

      signature do |s|
        s.argument :attribute, AttrName, :grouped
      end

      # (see Operator#each)
      def each(&block)
        Engine::Ungroup.new(input, attribute).each(&block)
      end

    end # class Ungroup
  end # module Operator::Relational
end # module Alf
