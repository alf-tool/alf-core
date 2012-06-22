module Alf
  module Engine
    class Cog
      include Enumerable

      # Execution context
      attr_reader :context

      def initialize(context)
        @context = context
      end

    end # module Cog
  end # module Engine
end # module Alf
