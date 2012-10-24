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
        when Predicate   then arg
        when TrueClass   then tautology
        when FalseClass  then contradiction
        when Symbol      then var_ref(arg)
        when Proc        then native(arg)
        when Hash, Tuple then eq(arg)
        when String      then Predicate.new(Grammar.parse(arg))
        when Relation    then relation(arg)
        else
          raise ArgumentError, "Unable to coerce `#{arg}` to a predicate"
        end
      end
      alias :parse :coerce

    private

      def _factor_predicate(arg)
        Predicate.new Grammar.sexpr(arg)
      end

    end

    def tautology?
      expr.tautology?
    end

    def contradiction?
      expr.contradiction?
    end

    def free_variables
      expr.free_variables
    end

    def constant_variables
      expr.constant_variables
    end

    def &(other)
      return self  if other.tautology? or other==self
      return other if tautology?
      Predicate.new(expr & other.expr)
    end

    def |(other)
      return self  if other.contradiction? or other==self
      return other if contradiction?
      Predicate.new(expr | other.expr)
    end

    def !
      Predicate.new(!expr)
    end

    def rename(renaming)
      Predicate.new(expr.rename(renaming))
    end

    def evaluate(scope)
      scope.instance_exec(&to_proc)
    end

    def and_split(attr_list)
      expr.and_split(attr_list).map{|e| Predicate.new(e)}
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
    alias :to_s :to_ruby_code

    def to_proc
      @proc ||= expr.to_proc(:scope => "self")
    end

    def to_lispy
      "->{ #{to_ruby_code} }"
    end

    def to_ruby_literal
      to_proc.to_ruby_literal
    end

  end # class Predicate
end # module Alf
