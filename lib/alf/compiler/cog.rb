module Alf
  class Compiler
    module Cog
      extend Forwardable

      def initialize(expr, compiler)
        @expr = expr
        @compiler = compiler
      end
      attr_reader :expr
      attr_reader :compiler

      def_delegators :expr, :connection,
                            :heading,
                            :keys

      def cog_orders
        []
      end

      def orderedby?(order)
        cog_orders.any?{|o| order <= o }
      end

      def to_cog
        self
      end

      def to_ascii_tree
        Support::Tree.new(self).to_text
      end

      def relation_type
        @relation_type ||= Relation[heading]
      end

      def to_relation
        raise NotSupportedError unless expr
        relation_type.new(each)
      rescue NotSupportedError
        Relation.coerce(each)
      end

    end # module Cog
  end # class Compiler
end # module Alf
