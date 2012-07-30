module Alf
  module Engine
    #
    # Coerce input tuples according to a Heading. Attributes that do not belong
    # to the heading are simply ignored but are kept in the output.
    #
    # Example:
    #
    #     operand = [
    #       {:name => "Jones", :price => "10.0"}, 
    #       {:name => "Smith", :price => "-12.0"}
    #     ]
    #     
    #     Coerce.new(operand, Heading[:price => Float]).to_a
    #     # => [
    #     #      {:name => "Jones", :price => 10.0}, 
    #     #      {:name => "Smith", :price => -12.0}
    #     #    ]
    #
    class Coerce < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Heading] Heading for coercions
      attr_reader :coercions

      # Creates an Coerce instance
      def initialize(operand, coercions)
        @operand = operand
        @coercions = coercions
      end

      # (see Cog#each)
      def each
        @operand.each do |tuple|
          yield tuple.merge(Hash[@coercions.map{|k,d|
            [k, Tools.coerce(tuple[k], d)]
          }])
        end
      end

    end # class Coerce
  end # module Engine
end # module Alf

