module Alf
  class Relation; end
  module Tools

    # Converts `value` to a Relation.
    #
    # Example:
    #
    #     Tools.to_relation(:name => "Alf")
    #     # => (Relation {:name => "Alf"})
    #
    # @param [Object] expr any ruby object to convert to a Relation
    # @return [Relation] a relation for `expr`
    def to_relation(expr)
      ToRelation.apply(expr)
    end

    # Myrrha rules for converting objects to relations
    ToRelation = Myrrha::coercions do |r|
      r.main_target_domain = Relation

      # Delegate to #to_relation if it exists
      rel_able = lambda{|v,rd| v.respond_to?(:to_relation)}
      r.upon(rel_able) do |v,_|
        v.to_relation
      end

      # Tuple to singleton Relation
      r.upon(Hash) do |v,_|
        Relation.new(Set.new << v)
      end

      # From enumerable of tuples to Relation
      enum_of_tuples = lambda{|v,_|
        v.is_a?(Enumerable) and v.all?{|t| t.is_a?(Hash)}
      }
      r.upon(enum_of_tuples) do |v,_|
        Relation.new(v.to_set)
      end

    end # ToRelation

  end # module Tools
end # module Alf
