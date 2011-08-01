module Alf
  module Types
    #
    # Encapsulates a Renaming information 
    #
    class Renaming
      
      # @return [Hash] a renaming mapping as AttrName -> AttrName
      attr_reader :renaming     
      
      # 
      # Creates a renaming instance
      #
      # @param [Hash] a renaming mapping as AttrName -> AttrName 
      #
      def initialize(renaming)
        @renaming = renaming
      end 
      
      # 
      # Coerces `arg` to a renaming
      # 
      def self.coerce(arg)
        case arg
        when Renaming
          arg
        when Hash
          h = Tools.tuple_collect(arg){|k,v|
            [Tools.coerce(k, AttrName), Tools.coerce(v, AttrName)]
          }
          Renaming.new(h)
        when Array
          coerce(Hash[*arg])
        else
          raise ArgumentError, "Invalid argument `#{arg}` for Renaming()"
        end
      end

      def self.from_argv(argv, opts = {})
        coerce(argv)
      end
            
      #
      # Applies renaming to a a given tuple
      #
      def apply(tuple)
        Tools.tuple_collect(tuple){|k,v| [@renaming[k] || k, v]}
      end
      
      # Checks if this renaming is equal to `other`
      def ==(other)
        other.is_a?(Renaming) && (other.renaming == renaming)
      end
      
    end # class Renaming
  end # module Types
end # module Alf