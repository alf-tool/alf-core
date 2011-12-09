module Alf
  class Reader
    module InstanceMethods

      # Default reader options
      DEFAULT_OPTIONS = {}

      # @return [Environment] Wired environment 
      attr_accessor :environment

      # @return [String or IO] Input IO, or file name
      attr_accessor :input

      # @return [Hash] Reader's options
      attr_accessor :options

      # Creates a reader instance. 
      #
      # @param [String or IO] path to a file or IO object for input
      # @param [Environment] environment wired environment, serving this reader
      # @param [Hash] options Reader's options (see doc of subclasses) 
      def initialize(*args)
        @input, @environment, @options = case args.first
        when String, IO, StringIO
          Tools.varargs(args, [args.first.class, Environment, Hash])
        else
          Tools.varargs(args, [String, Environment, Hash])
        end
        @options = self.class.const_get(:DEFAULT_OPTIONS).merge(@options || {}) 
      end

      # (see Iterator#each)
      #
      # @private the default implementation reads lines of the input stream and 
      # yields the block with <code>line2tuple(line)</code> on each of them. This 
      # method may be overriden if this behavior does not fit reader's needs.
      def each
        each_input_line do |line| 
          tuple = line2tuple(line)
          yield tuple unless tuple.nil?
        end
      end

      protected

      # @return the input file path, or nil if this Reader is bound to an IO
      # directly.
      def input_path
        input.is_a?(String) ? input : nil
      end

      # Coerces the input object to an IO and yields the block with it.
      #
      # StringIO and IO input are yield directly while file paths are first
      # opened in read mode and then yield.
      def with_input_io
        case input
        when IO, StringIO
          yield input
        when String
          File.open(input, 'r'){|io| yield io}
        else
          raise "Unable to convert #{input} to an IO object"
        end
      end

      # Returns the whole input text. 
      #
      # This feature should only be used by subclasses on inputs that are 
      # small enough to fit in memory. Consider implementing readers without this
      # feature on files that could be larger. 
      def input_text
        with_input_io{|io| io.readlines.join}
      end

      # Yields the block with each line of the input text in turn.
      #
      # This method is an helper for files that capture one tuple on each input 
      # line. It should be used in those cases, as the resulting reader will not
      # load all input in memory but serve tuples on demand.  
      def each_input_line
        with_input_io{|io| io.each_line(&Proc.new)}
      end

      # Converts a line previously read from the input stream to a tuple. 
      #
      # The line is simply ignored is this method return nil. Errors should be
      # properly handled by raising exceptions. This method MUST be implemented 
      # by subclasses unless each is overriden.
      def line2tuple(line)
      end
      undef :line2tuple

    end # module InstanceMethods
    include InstanceMethods
  end # class Reader
end # module Alf
