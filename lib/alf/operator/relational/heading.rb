module Alf
  module Operator::Relational
    class Heading < Alf::Operator()
      include Relational, Experimental, Unary

      signature do |s|
      end
      
      # (see Operator#each)
      def each
        yield(input.inject(Alf::Heading::EMPTY){|h,t|
          h + Tools.tuple_heading(t)
        }.attributes)
      end

    end # class Project
  end # module Operator::Relational
end # module Alf
