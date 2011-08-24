module Alf
  class Reader
    module ClassMethods
      
      #
      # Returns registered readers
      #
      def readers
        @readers ||= []
      end
      
      #      
      # Registers a reader class associated with specific file extensions
      #
      # Registered class must provide a constructor with the following signature 
      # <code>new(path_or_io, environment = nil)</code>. The name must be a symbol
      # which can safely be used as a ruby method name. A factory class method of 
      # that name and same signature is automatically installed on the Reader 
      # class.
      #
      # @param [Symbol] name a name for the kind of data decoded
      # @param [Array] extensions file extensions mapped to the registered reader 
      #                class (should include the '.', e.g. '.foo')
      # @param [Class] class Reader subclass used to decode this kind of files 
      #     
      def register(name, extensions, clazz)
        readers << [name, extensions, clazz]
        (class << self; self; end).
          send(:define_method, name) do |*args|
            clazz.new(*args)
          end
      end
    
      #
      # When filepath is a String, returns a reader instance for a specific file 
      # whose path is given as argument. Otherwise, delegate the call to
      # <code>coerce(filepath)</code>
      #
      # @param [String] filepath path to a file for which extension is recognized
      # @param [Array] args optional additional arguments that must be passed at
      #        reader's class new method.
      # @return [Reader] a reader instance
      # 
      def reader(filepath, *args)
        if filepath.is_a?(String)
          ext = File.extname(filepath)
          if registered = readers.find{|r| r[1].include?(ext)}
            registered[2].new(filepath, *args)
          else
            raise "No registered reader for #{ext} (#{filepath})"
          end
        elsif args.empty? 
          coerce(filepath)
        else
          raise ArgumentError, "Unable to return a reader for #{filepath} and #{args}" 
        end
      end
      
      #
      # Coerces an argument to a reader, using an optional environment to convert 
      # named datasets.
      #
      # This method automatically provides readers for Strings and Symbols through
      # passed environment (**not** through the reader factory) and for IO objects 
      # (through Rash reader). It is part if Alf's internals and should be used 
      # with care.
      #
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
      
    end # module ClassMethods
    extend(ClassMethods)
  end # class Reader
end # module Alf
