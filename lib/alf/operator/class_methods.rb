module Alf
  module Operator
    # 
    # Encapsulates method that allows making operator introspection, that is,
    # knowing operator cardinality and similar stuff.
    # 
    module ClassMethods
      
      #
      # Yields non-relational then relational operators, in turn.
      #
      def each
        Operator::NonRelational.each{|x| yield(x)}
        Operator::Relational.each{|x| yield(x)}
      end
      
      # Ensures that the Introspection module is set on real operators
      def included(mod)
        mod.extend(ClassMethods) if mod.is_a?(Class)
      end
      
      #
      # Returns true if this operator is an unary operator, false otherwise
      #
      def unary?
        ancestors.include?(Operator::Unary)
      end

      #
      # Returns true if this operator is a binary operator, false otherwise
      #
      def binary?
        ancestors.include?(Operator::Binary)
      end

      #
      # Installs or set the operator signature
      #
      def signature(sig = nil)
        if sig.nil?
          @signature || Tools::Signature::EMPTY
        else
          @signature = Tools::Signature.new(sig)
          @signature.install(self)
        end
      end
      
    end # module ClassMethods
    extend(ClassMethods)
  end # module Operator
end # module Alf
