module Alf
  class Compiler

    def call(expr)
      Plan.new(self).compile(expr)
    end

    def compile(plan, expr, compiled, &fallback)
      send(to_method_name(expr), plan, expr, *compiled, &fallback)
    rescue NotSupportedError
      return fallback.call if fallback
      raise
    end

    def on_leaf_operand(plan, expr)
      expr.to_cog(plan)
    end

    def on_missing(plan, expr, *compiled, &fallback)
      raise "Unable to compile `#{expr}` (#{self})" unless fallback
      fallback.call
    end

    def on_unsupported(plan, expr, *args)
      raise NotSupportedError, "Unsupported expression `#{expr}`"
    end

  private

    def responsible_compiler(compiled)
      return self if compiled.size == 0
      candidates = compiled.map(&:compiler).uniq
      if (candidates.size != 1) or candidates.first.nil?
        Default===self ? self : Default.new
      else
        candidates.first
      end
    end

    def to_method_name(expr)
      case expr
      when Algebra::Operator
        name = expr.class.rubycase_name
        meth = :"on_#{name}"
        meth = :"on_missing" unless respond_to?(meth)
        meth
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
