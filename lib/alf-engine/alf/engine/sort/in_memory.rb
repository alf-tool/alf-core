module Alf
  module Engine
    #
    # Implement an in-memory sort, relying on `to_a.sort!`
    #
    # Example:
    #
    #     rel = [
    #       {:name => "Smith"},
    #       {:name => "Jones"}
    #     ]
    #     Sort.new(rel, Ordering[[:name, :asc]]).to_a
    #     # => [
    #     #      {:name => "Jones"}
    #     #      {:name => "Smith"},
    #     #    ]
    #
    class Sort::InMemory
      include Sort
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] The ordering info
      attr_reader :ordering

      # Creates an Autonum instance
      def initialize(operand, ordering, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @ordering = ordering
      end

      # (see Cog#cog_orders)
      def cog_orders
        @cog_orders ||= [ ordering ]
      end

      # (see Cog#each)
      def _each(&block)
        operand.to_a.sort!(&ordering.sorter).each(&block)
      end

    end # class Sort::InMemory
  end # module Engine
end # module Alf
