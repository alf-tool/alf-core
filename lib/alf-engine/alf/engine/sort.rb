module Alf
  module Engine
    #
    # Sort its operand according to an ordering information.
    #
    class Sort
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] The ordering info
      attr_reader :ordering

      # Creates an Autonum instance
      def initialize(operand, ordering, expr = nil)
        super(expr)
        @operand = operand
        @ordering = ordering
      end

      # (see Cog#each)
      def _each(&block)
        Sort::InMemory.new(operand, ordering, expr).each(&block)
      end

    end # class Sort
  end # module Engine
end # module Alf
require_relative 'sort/in_memory'
