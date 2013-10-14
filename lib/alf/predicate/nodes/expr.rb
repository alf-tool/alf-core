module Alf
  class Predicate
    module Expr
      include Factory

      OP_NEGATIONS = {
        :eq  => :neq,
        :neq => :eq,
        :lt  => :gte,
        :lte => :gt,
        :gt  => :lte,
        :gte => :lt
      }

      def tautology?
        false
      end

      def contradiction?
        false
      end

      def !
        sexpr([:not, self])
      end

      def &(other)
        return other if other.contradiction?
        return self  if other.tautology?
        sexpr([:and, self, other])
      end

      def |(other)
        return other if other.tautology?
        return self  if other.contradiction?
        sexpr([:or, self, other])
      end

      def and_split(attr_list)
        (free_variables & attr_list).empty? ? [ tautology, self ] : [ self, tautology ]
      end

      def rename(renaming)
        Renamer.call(self, :renaming => renaming)
      end

      def qualify(qualifier)
        Qualifier.new(qualifier).call(self)
      end

      def constant_variables
        AttrList::EMPTY
      end

      def to_ruby_code(scope = 't')
        code = ToRubyCode.call(self, scope: scope)
        "->(t){ #{code} }"
      end

      def to_proc(scope = 't')
        Kernel.eval(to_ruby_code(scope))
      end

      def sexpr(arg)
        Factory.sexpr(arg)
      end

    end
  end
end
