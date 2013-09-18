module Alf
  class Compiler
    include Algebra::Visitor

    def parser
      @parser ||= Lang::Lispy.new
    end

    def chain(other)
      Chain.new(self, other)
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

    # Post-DFS
    def _call(expr, compiled, &fallback)
      compiler = responsible_compiler(compiled)
      compiler.send(to_method_name(expr), expr, *compiled, &fallback)
    end

    def responsible_compiler(compiled)
      return self if compiled.empty?
      compiled.map(&:compiler).reduce(&:&)
    end

  end # class Compiler
end # module Alf
require_relative 'compiler/chained'
require_relative 'compiler/default'
