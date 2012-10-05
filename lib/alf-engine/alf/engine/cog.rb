module Alf
  module Engine
    class Cog
      include Enumerable

      def to_relation
        Relation.coerce(to_a)
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

    end # module Cog
  end # module Engine
end # module Alf
