module Alf
  module Types
    #
    # Encapsulates tools for computing orders on tuples
    #
    class Ordering
    
      attr_reader :ordering
    
      def initialize(ordering = [])
        @ordering = ordering
        @sorter = nil
      end
    
      # 
      # Coerces `arg` to an ordering key. 
      #
      # Implemented coercions are:
      # * Array of symbols (all attributes in ascending order)
      # * Array of [Symbol, :asc|:desc] pairs (obvious semantics)
      # * AttrList (all its attributes in ascending order)
      # * Ordering (self)
      #
      # @return [Ordering]
      # @raises [ArgumentError] when `arg` is not recognized
      #
      def self.coerce(arg)
        case arg
        when Ordering
          arg
        when AttrList
          arg.to_ordering
        when Array
          if arg.all?{|a| a.is_a?(Array)}
            Ordering.new(arg)
          else
            symbolized = arg.collect{|s| Tools.coerce(s, Symbol)}
            sliced = symbolized.each_slice(2) 
            if sliced.all?{|a,o| [:asc,:desc].include?(o)}
              Ordering.new sliced.to_a
            else
              Ordering.new symbolized.collect{|a| [a, :asc]}
            end
          end
        else
          raise ArgumentError, "Unable to coerce #{arg} to an ordering key"
        end
      end

      def self.from_argv(argv, opts = {})
        coerce(argv)
      end
          
      def attributes
        @ordering.collect{|arg| arg.first}
      end
    
      def order_by(attr, order = :asc)
        @ordering << [attr, order]
        @sorter = nil
        self
      end
    
      def order_of(attr)
        @ordering.find{|arg| arg.first == attr}.last
      end
    
      def compare(t1,t2)
        @ordering.each do |attr,order|
          x, y = t1[attr], t2[attr]
          comp = x.respond_to?(:<=>) ? (x <=> y) : (x.to_s <=> y.to_s)
          comp *= -1 if order == :desc
          return comp unless comp == 0
        end
        return 0
      end
    
      def sorter
        @sorter ||= lambda{|t1,t2| compare(t1, t2)}
      end
    
      def +(other)
        other = Ordering.coerce(other)
        Ordering.new(@ordering + other.ordering)
      end
    
      def ==(other)
        other.is_a?(Ordering) && (other.ordering == ordering)
      end
      
    end # class Ordering
  end # module Types
end # module Alf