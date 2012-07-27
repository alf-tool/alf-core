module Alf
  class Predicate

    def initialize(expr)
      @expr = expr
    end
    attr_reader :expr

    def self.coerce(arg)
      case arg
      when Predicate  then arg
      when TrueClass  then Predicate.new(Factory.tautology)
      when FalseClass then Predicate.new(Factory.contradiction)
      when Symbol     then Predicate.new(Factory.var_ref(arg))
      when Proc       then Predicate.new(Factory.native(arg))
      when String     then Predicate.new(Grammar.parse(arg))
      when Hash       then Predicate.new(Factory.comp(:eq, arg))
      else
        raise ArgumentError, "Unable to coerce `#{arg}` to a predicate"
      end
    end

    def self.from_argv(argv)
      if argv.size == 1
        coerce(argv.first)
      elsif (argv.size % 2) == 0
        coerce(Hash[argv.each_slice(2).map{|k,v| [k.to_sym, eval(v)] }])
      else
        raise ArgumentError, "Unable to coerce from ARGV `#{argv.inspect}`"
      end
    end

    def &(other)
      Predicate.new(Factory.and(expr, other.expr))
    end

    def |(other)
      Predicate.new(Factory.or(expr, other.expr))
    end

    def !
      Predicate.new(Factory.not(expr))
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
      @ruby_code ||= expr.to_ruby_code
    end

    def to_proc
      @proc ||= expr.to_proc
    end

    def to_ruby_literal
      to_proc.to_ruby_literal
    end

  end # class Predicate
end # module Alf
require_relative 'predicate/parser'
require_relative 'predicate/grammar'
require_relative 'predicate/factory'
require_relative 'predicate/processors'
