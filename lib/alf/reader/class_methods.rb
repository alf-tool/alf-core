module Alf
  class Reader
    module ClassMethods

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
          if registered = readers.find{|r| r[1].include?(ext)}
            registered[2].new(filepath.to_s, *args)
          else
            raise ArgumentError, "No registered reader for #{ext} (#{filepath})"
          end
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

    end # module ClassMethods
    extend(ClassMethods)
  end # class Reader
end # module Alf
