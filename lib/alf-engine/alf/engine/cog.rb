module Alf
  module Engine
    class Cog
      include Enumerable

      def to_relation
        Relation.new(to_set)
      end

    protected

      def main_scope
        if respond_to?(:operand)
          operand.main_scope
        elsif respond_to?(:left)
          left.main_scope
        else
          raise "Unable to infer scope on `#{self}`"
        end
      end

      def tuple_scope(tuple = nil)
        Tools::TupleScope.new tuple, [], main_scope
      end

    end # module Cog
  end # module Engine
end # module Alf
