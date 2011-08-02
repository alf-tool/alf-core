module Alf
  module Types
    #
    # Defines a projection key
    # 
    class AttrList
    
      # Projection attributes
      attr_accessor :attributes
    
      def initialize(attributes)
        @attributes = attributes
      end
    
      def self.coerce(arg)
        case arg
        when AttrList
          arg
        when OrderingKey
          AttrList.new(arg.attributes)
        when Array
          AttrList.new(arg.collect{|s| Tools.coerce(s, AttrName)})
        else
          raise ArgumentError, "Unable to coerce #{arg} to a projection key"
        end
      end

      def self.from_argv(argv, opts = {})
        coerce(argv)
      end
          
      def to_ordering_key
        OrderingKey.new attributes.collect{|arg| [arg, :asc]}
      end
    
      def project(tuple, allbut = false)
        split(tuple, allbut).first
      end
    
      def split(tuple, allbut = false)
        projection, rest = {}, tuple.dup
        attributes.each do |a|
          projection[a] = tuple[a]
          rest.delete(a)
        end
        allbut ? [rest, projection] : [projection, rest]
      end

      def ==(other)
        other.is_a?(AttrList) && (other.attributes == attributes)          
      end
      alias :eql? :==
      
    end # class AttrList
  end # module Types
end # module Alf
