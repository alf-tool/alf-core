module Alf
  module Engine
    class Compilable

      def initialize(cog)
        @cog = cog
        @parser = Lang::Lispy.new
      end

      ### main

      def compile(expr)
        send(expr.class.rubycase_name, expr).to_cog
      end

      ### non relational

      def autonum(expr, traceability = expr)
        compiled = Autonum.new(@cog, expr.as, traceability)
        compiled.to_compilable
      end

      def clip(expr, traceability = expr)
        compiled = Clip.new(@cog, expr.attributes, expr.allbut, traceability)
        compiled.to_compilable
      end

      def coerce(expr, traceability = expr)
        compiled = Coerce.new(@cog, expr.coercions, traceability)
        compiled.to_compilable
      end

      def compact(expr, traceability = expr)
        compiled = Compact.new(@cog, traceability)
        compiled.to_compilable
      end

      def defaults(expr, traceability = expr)
        defaults = expr.defaults
        compiled = Defaults.new(@cog, defaults, traceability)
        if expr.strict
          clipping = @parser.clip(expr, defaults.to_attr_list)
          compiled = compiled.to_compilable.clip(clipping, traceability).to_cog
        end
        compiled.to_compilable
      end

      def sort(expr, traceability = expr)
        ordering = expr.ordering
        compiled = @cog
        unless @cog.orderedby?(ordering)
          compiled = Sort.new(compiled, ordering, traceability)
        end
        compiled.to_compilable
      end

      ### traceability

      def expr
        to_cog.expr
      end

      ### to_xxx

      def to_cog
        @cog
      end

    end # class Compilable
  end # module Engine
end # module Alf
