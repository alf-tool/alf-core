module Alf
  module Operator
    module Relational
      class Heading
        include Operator, Relational, Unary, Experimental

        signature do |s|
        end

        # (see Operator#each)
        def each
          heading = operand.inject(Alf::Heading::EMPTY){|h,t| h + heading(t) }
          yield(heading.to_h)
        end

      private

        def heading(tuple)
          Types::Heading[Hash[tuple.map{|k,v| [k, v.class]}]]
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
