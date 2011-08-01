module Alf
  module Tools
    #
    # Provides a handle, implementing a flyweight design pattern on tuples.
    #
    class TupleHandle
    
      # Creates an handle instance
      def initialize
        @tuple = nil
      end
    
      #
      # Sets the next tuple to use.
      #
      # This method installs the handle as a side effect 
      # on first call. 
      #
      def set(tuple)
        build(tuple) if @tuple.nil?
        @tuple = tuple
        self
      end
    
      #
      # Evaluates a tuple expression on the current tuple.
      # 
      def evaluate(expr)
        TupleExpression.coerce(expr).evaluate(self)
      end
    
      private
    
      #
      # Builds this handle with a tuple.
      #
      # This method should be called only once and installs 
      # instance methods on the handle with keys of _tuple_.
      #
      def build(tuple)
        tuple.keys.each do |k|
          (class << self; self; end).send(:define_method, k) do
            @tuple[k]
          end
        end
      end
    
    end # class TupleHandle
  end # module Tools
end # module Alf