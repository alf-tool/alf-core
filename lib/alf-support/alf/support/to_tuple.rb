module Alf
  module Support

    # Converts `value` to a Tuple.
    #
    # Example:
    #
    #     Support.to_tuple(:name => "Alf")
    #     # => {:name => "Alf"}
    #
    # @param [Object] expr any ruby object to convert to a Tuple
    # @return [Hash] a tuple as a Hash for `expr`
    def to_tuple(expr, &bl)
      tuple = ToTuple.apply(expr)
      tuple = tuple.remap(&bl) if bl
      tuple
    end

    # Myrrha rules for converting objects to relations
    ToTuple = Myrrha::coercions do |r|
      r.main_target_domain = Tuple

      # Hash to Tuple
      r.upon(Hash) do |v,_|
        Tuple.new(Support.symbolize_keys(v))
      end
    end # ToTuple

  end # module Support
end # module Alf
