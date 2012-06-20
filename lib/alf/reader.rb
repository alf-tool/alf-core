module Alf
  #
  # Implements an Iterator at the interface with the outside world.
  #
  # The contrat of a Reader is simply to be an Iterator. Unlike operators, however,
  # readers are not expected to take other iterators as input, but IO objects, database
  # tables, or something similar instead. This base class provides a default behavior for
  # readers that works with IO objects. It can be safely extended, overriden, or even
  # mimiced (provided that you include and implement the Iterator contract).
  #
  # This class also provides a registration mechanism to help getting Reader instances for
  # specific file extensions. A typical scenario for using this registration mechanism is
  # as follows:
  #
  #   # Registers a reader kind named :foo, associated with ".foo" file
  #   # extensions and the FooFileDecoder class (typically a subclass of
  #   # Reader)
  #   Reader.register(:foo, [".foo"], FooFileDecoder)
  #
  #   # Later on, you can request a reader instance for a .foo file, as
  #   # illustrated below.
  #   r = Reader.reader('/a/path/to/a/file.foo')
  #
  #   # Also, a factory method is automatically installed on the Reader class
  #   # itself. This factory method can be used with a String, or an IO object.
  #   r = Reader.foo([a path or a IO object])
  #
  class Reader
    include Iterator

    class << self

      # @return [Array<Reader>] registered readers
      def readers
        @readers ||= []
      end

      # Registers a reader class associated with specific file extensions.
      #
      # Registered class must provide a constructor with the following signature
      # `new(path_or_io, environment = nil, options = {})`. The registration
      # name must be a symbol which can safely be used as a ruby method name.
      # A factory method of that name and signature is automatically installed
      # on the Reader class.
      #
      # @param [Symbol] name a name for the kind of data decoded
      # @param [Array] extensions file extensions mapped to the registered reader
      #                class (should include the '.', e.g. '.foo')
      # @param [Class] class Reader subclass used to decode this kind of files
      def register(name, extensions, clazz)
        readers << [name, extensions, clazz]
        (class << self; self; end).
          send(:define_method, name) do |*args|
            clazz.new(*args)
          end
      end

      # When filepath looks like a String or a path, returns a reader instance
      # for the source it denotes. Otherwise, delegates the call to
      # `coerce(filepath)`.
      #
      # @param [:to_str|:to_path] filepath path to a file for which extension
      #        is recognized
      # @param [Array] args optional additional arguments that must be passed at
      #        reader's class new method.
      # @return [Reader] a reader instance built from arguments
      # @raise [ArgumentError] if `filepath` is not recognized or no reader can
      #        be found for this extension.
      def reader(filepath, *args)
        if looks_a_path?(filepath)
          ext = File.extname(filepath.to_s)
          has_reader_for_ext!(ext).new(filepath.to_s, *args)
        elsif args.empty?
          coerce(filepath)
        else
          raise ArgumentError, "Unable to return a reader for #{filepath} and #{args}"
        end
      end

      # Coerces `arg` to a Reader instance, using an optional environment to
      # convert named datasets.
      #
      # This method automatically provides readers for Strings and Symbols
      # through `environment` (**not** through the reader factory) and for IO
      # objects through a Rash reader.
      #
      # @param [Object] arg any value to coerce to a Reader instance
      # @param [Environment] environment to resolved named datasets (optional)
      def coerce(arg, environment = nil)
        case arg
        when Reader
          arg
        when IO, StringIO
          rash(arg, environment)
        else
          raise ArgumentError, "Unable to coerce #{arg.inspect} to a reader"
        end
      end

      private

      # Checks if `path` looks like a usable path
      def looks_a_path?(path)
        return false if path.is_a?(StringIO)
        path.respond_to?(:to_str) or path.respond_to?(:to_path)
      end

      # @return [Class] the reader class to use for `ext` file extension.
      # @raise [ArgumentError] if no such reader class can be found
      def has_reader_for_ext!(ext)
        entry = readers.find{|r| r[1].include?(ext)}
        return entry[2] if entry
        raise ArgumentError, "No registered reader for #{ext}"
      end

    end # class << self

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

  end # class Reader
end # module Alf
require_relative 'reader/rash'
require_relative 'reader/alf_file'
