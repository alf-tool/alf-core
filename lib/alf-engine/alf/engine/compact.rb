module Alf
  module Engine
    #
    # Remove duplicate tuples from its operand.
    #
    class Compact < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # Creates a Compact instance
      def initialize(operand, context=nil)
        super(context)
        @operand = operand
      end

      # (see Cog#each)
      def each(&block)
        Compact::Uniq.new(operand, context).each(&block)
      end

    end # class Compact
  end # module Engine
end # module Alf
require_relative 'compact/uniq'
require_relative 'compact/set'

