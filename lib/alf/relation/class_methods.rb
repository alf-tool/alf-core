module Alf
  class Relation
    module ClassMethods
      
      #
      # Coerces `val` to a relation.
      #
      # Recognized arguments are: Relation (identity coercion), Set of ruby hashes, 
      # Array of ruby hashes, Alf::Iterator.
      #
      # @return [Relation] a relation instance for the given set of tuples
      # @raise [ArgumentError] when `val` is not recognized
      #
      def coerce(val)
        Alf::Tools.to_relation(val)
      rescue Myrrha::Error
        raise ArgumentError, "Unable to coerce `#{val}` to a Relation"
      end
      
      # (see Relation.coerce)
      def [](*tuples)
        coerce(tuples)
      end
      
    end # module ClassMethods
    extend(ClassMethods)
  end # class Relation
end # module Alf
