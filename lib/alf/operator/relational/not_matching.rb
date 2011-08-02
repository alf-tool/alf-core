module Alf
  module Operator::Relational
    # 
    # Relational not matching (inverse of matching)
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # DESCRIPTION
    #
    # This operator restricts LEFT tuples to those for which there does not 
    # exist any tuple in RIGHT that (naturally) joins. This is a shortcut 
    # operator for the following longer expression: 
    #
    #         (minus xxx, (matching xxx, yyy))
    # 
    # EXAMPLE
    #
    #   alf not-matching suppliers supplies
    #  
    class NotMatching < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature do |s|
      end
      
      #
      # Performs a NotMatching of two relations through a Hash buffer on the 
      # right one.
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
                h[key.project(right_tuple)] = true
              end
              key ||= coerce([], AttrList)
              h
            end
            yield(left_tuple) unless seen.has_key?(key.project(left_tuple))
          end
        end
        
      end # class HashBased
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class NotMatching
  end # module Operator::Relational
end # module Alf
