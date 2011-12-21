module Alf
  module Operator
    module Relational
      class Heading
        include Relational, Unary, Experimental

        signature do |s|
        end
      
        # (see Operator#each)
        def each
          yield(operand.inject(Alf::Heading::EMPTY){|h,t|
            h + Tools.tuple_heading(t)
          }.to_h)
        end

      end # class Project
    end # module Relational
  end # module Operator
end # module Alf
