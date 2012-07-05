module Alf
  module Tools

    # Helper to define methods with multiple signatures.
    #
    # Example:
    #
    #   varargs([1, "hello"], [Integer, String]) # => [1, "hello"]
    #   varargs(["hello"],    [Integer, String]) # => [nil, "hello"]
    #
    # @param [Array] args some arguments passed to a method
    # @param [Array<===>] some expected types
    # @return [Array] an array with one value for each type
    def varargs(args, types)
      types.map{|t| t===args.first ? args.shift : nil}
    end

    # Attempts to require `who` the most friendly way as possible.
    #
    # This method allows loading weak dependencies in a friendly way. It takes
    # care of ensuring the dependency requirement `req` through rubygems. The
    # latter is loaded if required.
    #
    # Example:
    #
    #     Tools.friendly_require('sequel', '~> 3.0')
    #
    # @param [String] who the name of a gem
    # @param [String] req optional requirements on the gem version
    # @param [Boolean] retried (private parameter)
    def friendly_require(who, req = nil, retried = false)
      gem(who, req) if req && defined?(Gem)
      require who
    rescue LoadError => ex
      if retried
        raise "Unable to require #{who}, which is now needed\n"\
              "Try 'gem install #{who}'"
      else
        require 'rubygems' unless defined?(Gem)
        friendly_require(who, req, true)
      end
    end

    # Returns the unqualified name of a ruby class or module.
    #
    # Example
    #
    #   class_name(Alf::Tools) -> :Tools
    #
    # @param [Class] clazz a ruby class
    # @return [Symbol] the unqualified name of the class as a Symbol
    def class_name(clazz)
      /([A-Za-z0-9_]+)$/.match(clazz.name.to_s)[1].to_sym
    end

    # Converts an unqualified class or module name to a ruby case method name.
    #
    # Example
    #
    #    ruby_case(:Alf)  -> "alf"
    #    ruby_case(:HelloWorld) -> "hello_world"
    #
    # @param [String or Symbol] a class or module name
    # @return [String] the class or module name in ruby_case
    def ruby_case(s)
      s.to_s.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1]
    end

    # Returns the first non nil values from arguments.
    #
    # When no non-nil value can be found, the block is yield if present.
    # Otherwise, nil is returned.
    #
    # Example:
    #
    #   coalesce(nil, 1, "abc")         # -> 1
    #   coalesce(nil, nil){ "hello" }   # -> "hello"
    #   coalesce(nil, nil)              # -> nil
    #
    # @param [Array] args a list of values
    # @return [Object] the first non-nil value in `args`; the result of the
    #         block or nil if no non-nil value can be found.
    def coalesce(*args)
      if found = args.find{|x| !x.nil?}
        found
      elsif block_given?
        yield
      end
    end

    # Builds a tuple through enumeration.
    #
    # Iterates over enum and yields the block on each element. Collect block
    # results as key/value pairs returns them as a Hash.
    #
    # @param [Enumerable] enum any enumerable
    # @return [Tuple] a tuple built from yield results
    def tuple_collect(enum)
      Hash[enum.map{|elm| yield(elm)}]
    end

    # Infers the heading from a tuple
    #
    # @param [Tuple] tuple a tuple, represented by a Hash
    # @param [Heading] the heading of the tuple
    def tuple_heading(tuple)
      Heading[Hash[tuple.map{|k,v| [k, v.class]}]]
    end

    # Symbolizes all keys of `tuple`
    #
    # @param  [Hash]  tuple a tuple, represented by a Hash
    # @return [Tuple] the same tuple, with all keys as Symbols
    def symbolize_keys(tuple)
      tuple_collect(tuple){|k,v| [k.to_sym, v] }
    end

  end # module Tools
end # module Alf
