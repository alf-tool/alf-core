module Alf
  module Engine
    #
    # Concat tuples from multiple operands.
    #
    class Concat < Cog

      # @return [Array] operands to concatenate
      attr_reader :operands

      # Creates a Concat instance
      def initialize(operands, context=nil)
        super(context)
        @operands = operands
      end

      # (see Cog#each)
      def each(&block)
        operands.each do |op|
          op.each(&block)
        end
      end

    end # class Concat
  end # module Engine
end # module Alf
