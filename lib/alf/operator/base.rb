module Alf
  module Operator
    #
    # Contains all methods for operator instances
    #
    module Base

      #
      # Input datasets
      #
      attr_accessor :datasets
      
      #
      # Optional environment
      #
      attr_accessor :environment
      
      #
      # Create an operator instance
      #
      def initialize(*args)
        signature.parse_args(args, self)
      end
  
      # 
      # Sets the operator input
      #
      def pipe(input, env = environment)
        raise NotImplementedError, "Operator#pipe should be overriden"
      end
      
      #
      # Returns operator signature.
      #
      def signature
        self.class.signature
      end
      
      #
      # Run the operator command.
      #
      def run(argv = [], req = nil)
        @requester = req
        argv       = parse_options(argv, :split)
        operands   = command_line_operands([ $stdin ] + Array(argv[0]))
        args       = Array(argv[1..-1])
        signature.parse_argv(args, self)
        pipe(operands, environment || (req && req.environment))
        self
      end
  
      #
      # Yields each tuple in turn 
      #
      # This method is implemented in a way that ensures that all operators are 
      # thread safe. It is not intended to be overriden, use _each instead.
      # 
      def each
        op = self.dup
        op._prepare
        op._each(&Proc.new)
      end
      
      protected
  
      #
      # Prepares the iterator before subsequent call to _each.
      #
      # This method is intended to be overriden by suclasses to install what's 
      # need for successful iteration. The default implementation does nothing.
      #
      def _prepare 
      end
  
      # Internal implementation of the iterator.
      #
      # This method must be implemented by subclasses. It is safe to use instance
      # variables (typically initialized in _prepare) here.
      # 
      def _each
      end
      
      private :datasets=, :environment=
    end # module Base
    include Base
  end # module Operator
end # module Alf
