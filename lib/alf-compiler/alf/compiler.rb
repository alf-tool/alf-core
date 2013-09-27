module Alf
  class Compiler

    def parser
      @parser ||= Lang::Lispy.new
    end

    def &(other)
      return self if self==other
      raise "Unable to negociate with `#{other}`"
    end

    # Pre-DFS
    def call(expr)
      compiled = expr.is_a?(Algebra::Operator) ?
                 expr.operands.map{|op| call(op) } :
                 []
      _call(expr, compiled)
    end

    # Post-DFS, Pre-responsibility
    def _call(expr, compiled)
      compiler = responsible_compiler(compiled)
      compiler.__call(expr, compiled){
        __call(expr, compiled)
      }
    end

    # Post-responsibility
    def __call(expr, compiled, &fallback)
      send(to_method_name(expr), expr, *compiled, &fallback)
    rescue NotSupportedError
      return fallback.call if fallback
      raise
    end

    def on_missing(expr, *compiled, &fallback)
      raise "Unable to compile `#{expr}` (#{self})" unless fallback
      fallback.call
    end

    def on_unsupported(expr, *args)
      raise NotSupportedError, "Unsupported expression `#{expr}`"
    end

  private

    def responsible_compiler(compiled)
      candidates = compiled.map(&:compiler).compact.uniq
      case candidates.size
      when 0 then self
      when 1 then candidates.first
      else
        Default===self ? self: Default.new
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
require_relative 'compiler/cog'
require_relative 'compiler/chained'
require_relative 'compiler/default'
