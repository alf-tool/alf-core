module Alf
  module Tools

    # Converts `value` to a Tuple.
    #
    # Example:
    #
    #     Tools.to_tuple(:name => "Alf")
    #     # => {:name => "Alf"}
    #
    # @param [Object] expr any ruby object to convert to a Tuple
    # @return [Hash] a tuple as a Hash for `expr`
    def to_tuple(expr, &bl)
      tuple = ToTuple.apply(expr)
      tuple = Hash[tuple.map(&bl)] if bl
      tuple.extend(Types::Tuple)
    end

    # Myrrha rules for converting objects to relations
    ToTuple = Myrrha::coercions do |r|

      # Hash to Tuple
      r.upon(Hash) do |v,_|
        Tools.symbolize_keys(v)
      end

    end # ToTuple

  end # module Tools
end # module Alf
