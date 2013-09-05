module Alf
  module Engine
    module Sort

      # Delegates to Sort::InMemory
      def self.new(operand, ordering, expr = nil)
        Sort::InMemory.new(operand, ordering, expr)
      end

    end # module Sort
  end # module Engine
end # module Alf
require_relative 'sort/in_memory'
