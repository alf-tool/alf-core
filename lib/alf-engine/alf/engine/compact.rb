module Alf
  module Engine
    #
    # Remove duplicate tuples from its operand.
    #
    class Compact < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # Creates a Compact instance
      def initialize(operand)
        @operand = operand
      end

      # (see Cog#each)
      def each(&block)
        Compact::Uniq.new(operand).each(&block)
      end

    end # class Compact
  end # module Engine
end # module Alf
require 'alf/engine/compact/uniq'

