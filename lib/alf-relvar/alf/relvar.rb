module Alf
  module Relvar
    include Algebra::Operand::Leaf
    include Lang::ObjectOriented

    def self.new(connection, expr)
      return expr.to_relvar if expr.respond_to?(:to_relvar)
      Virtual.new(connection, expr)
    end

    def empty?
      to_cog.each{ return false }
      true
    end

    def empty!
      raise FactAssertionError unless empty?
      true
    end

    def not_empty!
      raise FactAssertionError if empty?
      true
    end

    def value
      to_relation
    end

    def affect(value)
      delete
      insert(value)
    end

  private

    def _operator_output(expr)
      Relvar::Virtual.new(connection, expr)
    end

  end # module Relvar
end # module Alf
require_relative 'relvar/base'
require_relative 'relvar/virtual'
