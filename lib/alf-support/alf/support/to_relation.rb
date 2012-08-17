module Alf
  class Relation; end
  module Support

    # Converts `value` to a Relation.
    #
    # Example:
    #
    #     Support.to_relation(:name => "Alf")
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

      # to_relation(:name => ["...", "..."])
      list_of_values = lambda{|v,_|
        v.is_a?(Hash) and v.size == 1 and v.values.first.is_a?(Array)
      }
      r.upon(list_of_values) do |v,_|
        key, values = v.to_a.first
        tuples      = values.map{|value| {key.to_sym => value}}.to_set
        Relation.new(tuples)
      end

      # Tuple to singleton Relation
      r.upon(Hash) do |v,_|
        Relation.new(Set.new << Support.symbolize_keys(v))
      end

      # path able
      r.upon(IO) do |v,_|
        Alf.reader(v).to_relation
      end

      # From enumerable of tuples to Relation
      enum_of_tuples = lambda{|v,_|
        v.is_a?(Enumerable) and v.all?{|t| t.is_a?(Hash)}
      }
      r.upon(enum_of_tuples) do |v,_|
        Relation.new(v.map{|t| Support.symbolize_keys(t)}.to_set)
      end

      # path able
      r.upon(Path.like) do |v,_|
        Alf.reader(v).to_relation
      end

    end # ToRelation

  end # module Support
end # module Alf
