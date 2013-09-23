module Alf
  module Engine
    module Cog
      include Compiler::Cog
      include Enumerable

      def each(&bl)
        return to_enum unless block_given?
        _each(&bl)
      end

      def to_dot(buffer = "")
        Engine::ToDot.new.call(self, buffer)
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

    end # module Cog
  end # module Engine
end # module Alf
