module Alf
  module Tools

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
      Hash[tuple.map{|k,v| [k.to_sym, v] }]
    end

  end # module Tools
end # module Alf
