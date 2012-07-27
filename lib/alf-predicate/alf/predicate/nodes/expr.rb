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
        sexpr([:and, self, other])
      end

      def |(other)
        sexpr([:or, self, other])
      end

      def and_split(attr_list, reverse = false)
        res = free_variables.subset?(attr_list) ? [ self, tautology ] : [ tautology, self ]
        reverse ? res.reverse : res
      end

      def to_ruby_code(options = {})
        ToRubyCode.call(self, options)
      end

      def to_proc(options = {})
        ToProc.call(self, options)
      end

      def sexpr(arg)
        Factory.sexpr(arg)
      end

    end
  end
end
