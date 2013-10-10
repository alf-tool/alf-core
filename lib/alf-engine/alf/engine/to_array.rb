module Alf
  module Engine
    #
    # Ensures an order of tuples, recursing on relation value attributes, that are
    # converted as arrays as well.
    #
    # Example:
    #
    #   res = [
    #     {:price => 12.0, :rva => Relation(...)},
    #     {:price => 10.0, :rva => Relation(...)}
    #   ]
    #   ToArray.new(res, [:price, :asc]).to_a
    #   # => [
    #   #      {:price => 10.0, :rva => [...] },
    #   #      {:price => 12.0, :rva => [...] }
    #   #    ]
    #
    class ToArray
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] The ordering info
      attr_reader :ordering

      # Creates an ToArray instance
      def initialize(operand, ordering = nil, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @ordering = ordering
      end

      # (see Cog#each)
      def _each(&block)
        operand = ordering ? Sort.new(self.operand, ordering) : self.operand
        operand.each do |tuple|
          yield recurse(tuple)
        end
      end

    private

      def recurse(tuple)
        case tuple
        when Hash
          Hash[tuple.map{|k,v| [ k, reorder(k,v) ] }]
        when Tuple
          tuple.remap{|k,v| reorder(k, v) }.to_hash
        end
      end

      def reorder(key, value)
        if RelationLike===value
          subordering = ordering ? ordering.dive(key) : nil
          ToArray.new(value, subordering).to_a
        elsif TupleLike===value
          value.to_hash
        else
          value
        end
      end

    end # class ToArray
  end # module Engine
end # module Alf