module Alf
  module Operator::Relational
    class Matching < Alf::Operator()
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
      #
      # Performs a Matching of two relations through a Hash buffer on the right
      # one.
      #
      class HashBased
        include Operator, Operator::Binary
      
        # (see Operator#_each)
        def _each
          seen, key = nil, nil
          left.each do |left_tuple|
            seen ||= begin
              h = Hash.new
              right.each do |right_tuple|
                key ||= coerce(left_tuple.keys & right_tuple.keys, AttrList)
                h[key.project_tuple(right_tuple)] = true
              end
              key ||= coerce([], AttrList)
              h
            end
            yield(left_tuple) if seen.has_key?(key.project_tuple(left_tuple))
          end
        end
        
      end # class HashBased
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Matching
  end # module Operator::Relational
end # module Alf
