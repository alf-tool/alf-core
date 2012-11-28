module Alf
  module Relvar
    include Algebra::Operand
    include Lang::ObjectOriented

    def type
      @type ||= Relation[heading]
    end

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

    def safe(*args, &bl)
      Safe.new(self, *args, &bl)
    end

    def to_relvar
      self
    end

    def to_lispy
      raise NotImplementedError
    end

    def to_relation
      type.new(to_cog.to_set)
    rescue NotSupportedError
      Relation.coerce(to_cog.each)
    end

  private

    def _operator_output(expr)
      Relvar::Virtual.new(expr, connection)
    end

  end # module Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
require_relative 'relvar/read_only'
require_relative 'relvar/fake'
