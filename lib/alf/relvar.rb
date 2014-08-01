module Alf
  module Relvar
    extend Forwardable
    include Algebra::Operand
    include Lang::ObjectOriented

    def initialize(expr = nil)
      @expr = expr
    end
    attr_reader :expr

    def_delegators :expr, :heading,
                          :keys,
                          :to_cog,
                          :to_lispy

    def type
      @type ||= Relation[heading]
    end

    ###

    def each(&bl)
      to_cog.each(&bl)
    end

    def empty?
      to_cog.each{|_| return false }
      true
    end

    def empty!(msg = "relvar is empty")
      raise FactAssertionError, msg unless empty?
      self
    end

    def not_empty!(msg = "relvar is not empty")
      raise FactAssertionError, msg if empty?
      self
    end

    def value
      to_relation
    end

    def lock(*)
      raise NotSupportedError
    end

    def affect(value)
      delete
      insert(value)
    end

    def insert(tuples)
      raise NotSupportedError
    end

    def delete(predicate = Predicate.tautology)
      raise NotSupportedError
    end

    def update(updating, predicate = Predicate.tautology)
      raise NotSupportedError
    end

    def upsert(tuples)
      empty? ? insert(tuples) : update(tuples)
    end

    def safe(*args, &bl)
      Safe.new(self, *args, &bl)
    end

    def to_relvar
      self
    end

    def to_relation
      to_cog.to_relation
    end

  private

    def _self_operand
      expr
    end

    def _operator_output(expr)
      Relvar::Virtual.new(expr)
    end

  end # module Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
require_relative 'relvar/read_only'
require_relative 'relvar/memory'
require_relative 'relvar/fake'
