module Alf
  module Lang
    module Literals

      # Coerces `h` to a valid tuple.
      #
      # @param [Hash] h, a hash mapping symbols to values
      def Tuple(h)
        unless h.keys.all?{|k| k.is_a?(Symbol)} &&
               h.values.all?{|v| !v.nil?}
          raise ArgumentError, "Invalid tuple literal #{h.inspect}"
        end
        h
      end

      # Coerces `args` to a valid relation.
      def Relation(first, *args)
        if args.empty?
          if first.is_a?(Symbol)
            _environment.dataset(first).to_rel
          elsif first.is_a?(Hash)
            Alf::Relation[first]
          else
            raise ArgumentError, "Unable to coerce `#{first.inspect}` to a relation"
          end
        else
          Alf::Relation[*args.unshift(first)] 
        end
      end

    end # module Literals
  end # module Lang
end # module Alf
