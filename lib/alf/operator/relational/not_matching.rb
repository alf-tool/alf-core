module Alf
  module Operator::Relational
    # 
    # Relational not matching
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (not_matching :suppliers, :supplies)
    #
    # DESCRIPTION
    #
    # This operator restricts left tuples to those for which there does not 
    # exist any right tuple that joins. This is a shortcut operator for the
    # longer expression: 
    #
    #         (minus xxx, (matching xxx, yyy))
    # 
    # In shell:
    #
    #   alf not-matching suppliers supplies 
    #  
    class NotMatching < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
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
                key ||= coerce(left_tuple.keys & right_tuple.keys, ProjectionKey)
                h[key.project(right_tuple)] = true
              end
              key ||= coerce([], ProjectionKey)
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
