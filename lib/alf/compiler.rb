module Alf
  class Compiler

    def supports_reuse?
      false
    end

    def join(plan)
      nil
    end

    def call(expr)
      Plan.new(self).compile(expr)
    end

    def compile(plan, expr, compiled, usage_count)
      send(to_method_name(expr), plan, expr, *compiled)
    end

    def on_relation(plan, expr)
      expr.to_cog(plan)
    end

    def on_relvar(plan, expr)
      expr.to_cog(plan)
    end

    def on_leaf_operand(plan, expr)
      expr.to_cog(plan)
    end

    def on_shortcut(plan, expr, *compiled)
      plan.__compile{|p| expr.expand }
    end

    def on_missing(plan, expr, *compiled)
      raise NotSupportedError, "Unable to compile `#{expr}` (#{self})"
    end

    def on_unsupported(plan, expr, *args)
      raise NotSupportedError, "Unsupported expression `#{expr}`"
    end

  private

    def to_method_name(expr)
      case expr
      when Algebra::Operator
        name = expr.class.rubycase_name
        meth = :"on_#{name}"
        meth = :"on_shortcut" if expr.is_a?(Algebra::Shortcut) and !respond_to?(meth)
        meth = :"on_missing"  if !respond_to?(meth)
        meth
      when Relation
        :on_relation
      when Relvar
        :on_relvar
      when Algebra::Operand
        :on_leaf_operand
      else
        :on_unsupported
      end
    end

  end # class Compiler
end # module Alf
require_relative 'compiler/plan'
require_relative 'compiler/cog'
require_relative 'compiler/default'
