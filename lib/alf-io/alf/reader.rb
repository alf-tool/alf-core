module Alf
  #
  # Implements an iterator at the interface with the outside world.
  #
  # This base class provides a default behavior for readers that works with IO objects. It
  # can be safely extended, overriden, or mimiced. This class also provides a registration
  # mechanism to help getting Reader instances for specific file extensions. A typical
  # scenario for using this registration mechanism is as follows:
  #
  #   # Registers a reader kind named :foo, associated with ".foo" file
  #   # extensions and the FooFileDecoder class (typically a subclass of
  #   # Reader)
  #   Reader.register(:foo, [".foo"], FooFileDecoder)
  #
  #   # Later on, you can request a reader instance for a .foo file
  #   r = Reader.reader('/a/path/to/a/file.foo')
  #
  #   # Also, a factory method is automatically installed on the Reader class
  #   # itself. This factory method can be used with a String, or an IO object.
  #   r = Reader.foo([a path or a IO object])
  #
  class Reader
    include Enumerable

    class << self
      include Support::Registry

      # Registers a reader class associated with specific file extensions.
      #
      # Registered class must provide a constructor with the following signature
      # `new(path_or_io, connection = nil, options = {})`. The registration name must be a
      # symbol which can safely be used as a ruby method name. A factory method of that
      # name and signature is automatically installed on the Reader class.
      #
      # @param [Symbol] name a name for the kind of data decoded
      # @param [Array] extensions file extensions mapped to the registered reader
      #                class (should include the '.', e.g. '.foo')
      # @param [Class] class Reader subclass used to decode this kind of files
      def register(name, extensions, clazz)
        super([name, extensions, clazz], Reader)
      end

      # Returns a Reader on `source` denoting a physical representation of a relation.
      #
      # @param [...]     source a String, a Path or an IO denoting a relation physical source.
      # @param [Array]   args optional reader arguments
      # @return [Reader] a reader instance built from arguments
      # @raise [ArgumentError] if `source` is not recognized or no reader can be found.
      #
      def reader(source, *args)
        if Path.like?(source)
          has_reader_for_ext!(Path(source).extname).new(source, *args)
        elsif args.empty?
          coerce(source)
        else
          raise ArgumentError, "Unable to return a reader for `#{source}`"
        end
      end

      # Coerces `arg` to a Reader instance.
      #
      # @param [Object] arg any value coercable to a Reader instance
      def coerce(arg)
        case arg
        when Reader       then arg
        when IO, StringIO then rash(arg)
        else
          raise ArgumentError, "Unable to coerce `#{arg}` to a reader"
        end
      end

      # Returns a Reader instance for the given mime type.
      #
      # @param [String] mime_type a given (simplified) MIME type
      # @param [...] args other arguments to pass to the reader constructor
      # @return [Renderer] a Renderer instance, already wired if args are provided
      #
      def by_mime_type(mime_type, *args)
        if r = registered.find{|_,_,c| c.mime_type == mime_type}
          r.last.new(*args)
        else
          raise UnsupportedMimeTypeError, "No reader for `#{mime_type}`"
        end
      end

    private

      # @return [Class] the reader class to use for `ext` file extension.
      # @raise [ArgumentError] if no such reader class can be found
      def has_reader_for_ext!(ext)
        entry = registered.find{|r| r[1].include?(ext)}
        return entry[2] if entry
        raise ArgumentError, "No registered reader for `#{ext}`"
      end

    end # class << self

    # Default reader options
    DEFAULT_OPTIONS = {}

    # @return [String, IO, ...] Input as initially provided to initialize
    attr_accessor :input

    # @returns [Path] a Path instance if input can be localized
    attr_reader :path

    # @return [Hash] Reader's options
    attr_accessor :options

    # Creates a reader instance.
    #
    # @param [String or IO] path to a file or IO object for input
    # @param [Hash] options Reader's options (see doc of subclasses)
    def initialize(input, options = {})
      @input   = input
      @path    = Path(@input)
      @options = self.class.const_get(:DEFAULT_OPTIONS).merge(options)
    end

    # Yields each tuple in turn
    #
    # @private the default implementation reads lines of the input stream and
    # yields the block with <code>line2tuple(line)</code> on each of them. This
    # method may be overriden if this behavior does not fit reader's needs.
    def each
      return to_enum unless block_given?
      each_input_line do |line|
        tuple = line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end

    protected

    # @return the input file path, or nil if this Reader is bound to an IO
    # directly.
    def input_path
      path && path.to_s
    end

    # Coerces the input object to an IO and yields the block with it.
    #
    # StringIO and IO input are yield directly while file paths are first
    # opened in read mode and then yield.
    def with_input_io(&bl)
      case input
      when IO, StringIO
        input.rewind unless input.pos==0
        yield input
      when String, Path
        Path(input).open('r', &bl)
      else
        raise "Unable to convert `#{input}` to an IO object"
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
require_relative 'reader/csv'
require_relative 'reader/json'
require_relative 'reader/ruby'
