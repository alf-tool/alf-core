module Alf
  module Engine
    #
    # Set computed tuples attributes. This cog allows implementing both
    # EXTEND and UPDATE relational operators.
    # 
    # Example:
    #
    #     rel = [
    #       {:name => "Jones", :city => "London"}
    #     ]
    #     comp = TupleComputation[
    #       :city   => lambda{ city.upcase },
    #       :concat => lambda{ "#{name} #{city}" }
    #     ]
    #     SetAttr.new(rel, comp).to_a
    #     # => [
    #     #      {:name => "Jones", :city => "LONDON", :concat => "Jones LONDON"}
    #     #    ]
    #
    class SetAttr < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [TupleComputation] Computed attributes as a computation
      attr_reader :computation

      # Creates a SetAttr instance
      def initialize(operand, computation, context=nil)
        super(context)
        @operand = operand
        @computation = computation
      end

      # (see Cog#each)
      def each
        scope = tuple_scope
        operand.each do |tuple|
          computed = @computation.evaluate(scope.__set_tuple(tuple))
          yield tuple.merge(computed){|k,v1,v2| v2}
        end
      end

    end # class SetAttr
  end # module Engine
end # module Alf
