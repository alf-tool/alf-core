require_relative 'predicate/parser'
require_relative 'predicate/factory'
require_relative 'predicate/grammar'
require_relative 'predicate/processors'
module Alf
  class Predicate

    def initialize(expr)
      @expr = expr
    end
    attr_reader :expr

    class << self
      include Factory

      def coerce(arg)
        case arg
        when Predicate  then arg
        when TrueClass  then tautology
        when FalseClass then contradiction
        when Symbol     then var_ref(arg)
        when Proc       then native(arg)
        when Hash       then eq(arg)
        when String     then Predicate.new(Grammar.parse(arg))
        else
          raise ArgumentError, "Unable to coerce `#{arg}` to a predicate"
        end
      end
      alias :parse :coerce

      def from_argv(argv)
        if argv.size == 1
          coerce(argv.first)
        elsif (argv.size % 2) == 0
          coerce(Hash[argv.each_slice(2).map{|k,v| [k.to_sym, eval(v)] }])
        else
          raise ArgumentError, "Unable to coerce from ARGV `#{argv.inspect}`"
        end
      end

    private

      def _factor(arg)
        Predicate.new Grammar.sexpr(arg)
      end

    end

    def tautology?
      expr.tautology?
    end

    def contradiction?
      expr.contradiction?
    end

    def &(other)
      Predicate.new(expr & other.expr)
    end

    def |(other)
      Predicate.new(expr | other.expr)
    end

    def !
      Predicate.new(!expr)
    end

    def evaluate(scope)
      scope.instance_exec(&to_proc)
    end

    def ==(other)
      other.is_a?(Predicate) && (other.expr==expr)
    end

    def hash
      expr.hash
    end

    def to_ruby_code
      @ruby_code ||= expr.to_ruby_code(:scope => "self")
    end

    def to_proc
      @proc ||= expr.to_proc(:scope => "self")
    end

    def to_ruby_literal
      to_proc.to_ruby_literal
    end

  end # class Predicate
end # module Alf
