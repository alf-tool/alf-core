module Alf
  module Operator
    # 
    # Encapsulates method that allows making operator introspection, that is,
    # knowing operator cardinality and similar stuff.
    # 
    module ClassMethods

      # Returns the ruby case name of this operator
      def rubycase_name 
        Tools.ruby_case(Tools.class_name(self))
      end

      ########################################################### Query methods

      # @return true if this is a relational operator, false otherwise
      def relational?
        ancestors.include?(Relational)
      end

      # @return true if this is an experimental operator, false otherwise
      def experimental?
        ancestors.include?(Experimental)
      end

      # @return true if this is a non relational operator, false otherwise
      def non_relational?
        ancestors.include?(NonRelational)
      end

      # @return true if this operator is a zero-ary operator, false otherwise
      def nullary?
        ancestors.include?(Operator::Nullary)
      end

      # @return true if this operator is an unary operator, false otherwise
      def unary?
        ancestors.include?(Operator::Unary)
      end

      # @return true if this operator is a binary operator, false otherwise
      def binary?
        ancestors.include?(Operator::Binary)
      end

      ################################################################# Factory
      
      # Installs or set the operator signature
      def signature
        if block_given?
          @signature = Signature.new(self, &Proc.new) 
          @signature.install
        else
          @signature ||= Signature.new(self)
        end
      end

      # Runs the command on commandline arguments `argv`
      #
      # @param [Array] argv an array of commandline arguments, typically ARGV
      # @param [Object] req an optional requester, typically a super command
      # @return [Iterator] an Iterator with query result
      def run(argv, req = nil)
        operands, args, options = signature.argv2args(argv)

        # find standard input reader
        stdin_reader = if req && req.respond_to?(:stdin_reader)
          req.stdin_reader
        else 
          Reader.coerce($stdin)
        end

        # normalize operands
        operands = [ stdin_reader ] + Array(operands)
        operands = operands.map{|op| 
          Iterator.coerce(op, req && req.environment)
        }
        operands = if nullary?
          []
        elsif unary?
          [operands.last]
        elsif binary?
          operands[-2..-1]
        end

        init_args = [operands] + args + [options]
        new(*init_args)
      end

    end # module ClassMethods

    # Yields non-relational then relational operators, in turn.
    def self.each
      Operator::NonRelational.each{|x| yield(x)}
      Operator::Relational.each{|x| yield(x)}
    end

    # Let submodules and classes have required methods
    module Installer

      # Ensures that the Introspection module is set on real operators
      def included(mod)
        if mod.is_a?(Class)
          mod.extend(ClassMethods) 
        else
          mod.extend(Installer)
        end
      end

    end # module Installer
    extend(Installer)
    
  end # module Operator
end # module Alf
