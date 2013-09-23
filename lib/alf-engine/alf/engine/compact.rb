module Alf
  module Engine
    #
    # Remove duplicate tuples from its operand.
    #
    class Compact
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # Creates a Compact instance
      def initialize(operand, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
      end

      # (see Cog#each)
      def _each(&block)
        Compact::Uniq.new(operand, expr).each(&block)
      end

    end # class Compact
  end # module Engine
end # module Alf
require_relative 'compact/uniq'
require_relative 'compact/set'

