module Alf
  module Engine
    #
    # Ensures an order on the main iterator of tuples, as well as on relation
    # value attributes, that are converted as arrays as well.
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
    class ToArray < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] The ordering info
      attr_reader :ordering

      # Creates an ToArray instance
      def initialize(operand, ordering, context=nil)
        super(context)
        @operand = operand
        @ordering = ordering
      end

      # (see Cog#each)
      def each(&block)
        Sort.new(operand, ordering, context).each do |tuple|
          yield recurse(tuple)
        end
      end

    private

      def recurse(tuple)
        Hash[tuple.map{|k,v| [k, reorder(v)] }]
      end

      def reorder(value)
        if Iterator===value
          ToArray.new(value, ordering, context).to_a
        else
          value
        end
      end

    end # class ToArray
  end # module Engine
end # module Alf