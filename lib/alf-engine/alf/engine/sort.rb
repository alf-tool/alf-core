module Alf
  module Engine
    #
    # Sort its operand according to an ordering information.
    #
    class Sort < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] The ordering info
      attr_reader :ordering

      # Creates an Autonum instance
      def initialize(operand, ordering)
        @operand = operand
        @ordering = ordering
      end

      # (see Cog#each)
      def each(&block)
        Sort::InMemory.new(operand, ordering).each(&block)
      end

    end # class Sort
  end # module Engine
end # module Alf
require 'alf/engine/sort/in_memory'
