module Alf
  class Relation
    module InstanceMethods

      protected
      
      # @return [Set] the set of tuples
      attr_reader :tuples
      
      public
      
      #
      # Creates a Relation instance.
      #
      # @param [Set] tuples a set of tuples
      #
      def initialize(tuples)
        raise ArgumentError unless tuples.is_a?(Set)
        @tuples = tuples
      end
      
      #
      # (see Iterator#each)
      #
      def each(&block)
        tuples.each(&block)
      end
      
      #
      # Returns relation's cardinality (number of tuples).
      #
      # @return [Integer] relation's cardinality 
      # 
      def cardinality
        tuples.size
      end
      alias :size :cardinality
      alias :count :cardinality
      
      # Returns true if this relation is empty
      def empty?
        cardinality == 0
      end
      
      # 
      # Install the DSL through iteration over defined operators
      #
      Operator::each do |op_class|
        meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
        if op_class.unary?
          define_method(meth_name) do |*args|
            op = op_class.new(*args).pipe(self)
            Relation.coerce(op)
          end
        elsif op_class.binary?
          define_method(meth_name) do |right, *args|
            op = op_class.new(*args).pipe([self, Iterator.coerce(right)])
            Relation.coerce(op)
          end
        elsif op_class.nullary?
          define_method(meth_name) do |*args|
            op = op_class.new(*args)
            Relation.coerce(op)
          end
        else
          raise "Unexpected operator #{op_class}"
        end
      end # Operators::each
        
      alias :+ :union
      alias :- :minus
  
      # Shortcut for project(attributes, :allbut => true)
      def allbut(attributes)
        project(attributes, :allbut => true)
      end
          
      #
      # (see Object#hash)
      #
      def hash
        @tuples.hash
      end
      
      #
      # (see Object#==)
      #
      def ==(other)
        return nil unless other.is_a?(Relation)
        other.tuples == self.tuples
      end
      alias :eql? :==
      
      #
      # Returns a textual representation of this relation
      #
      def to_s
        Alf::Renderer.text(self).execute("")
      end
      
      #
      # Returns an array with all tuples in this relation.
      #
      # @param [Tools::Ordering] an optional ordering key (any argument 
      #        recognized by Ordering.coerce is supported here). 
      # @return [Array] an array of hashes, in requested order (if specified)
      #
      def to_a(okey = nil)
        okey = Tools.coerce(okey, Ordering) if okey
        ary = tuples.to_a
        ary.sort!(&okey.sorter) if okey
        ary
      end
      
      #
      # Returns a  literal representation of this relation
      #
      def to_ruby_literal
        "Alf::Relation[" +
          tuples.collect{|t| Tools.to_ruby_literal(t)}.join(', ') + "]"
      end
      alias :inspect :to_ruby_literal
      
    end # module InstanceMethods
    include(InstanceMethods)
  end # class Relation
end # module Alf
