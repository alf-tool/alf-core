module Alf
  module Tools
    
    
    # Helper to define methods with multiple signatures. 
    #
    # Example:
    #
    #   varargs([1, "hello"], [Integer, String]) # => [1, "hello"]
    #   varargs(["hello"],    [Integer, String]) # => [nil, "hello"]
    # 
    def varargs(args, types)
      types.collect{|t| t===args.first ? args.shift : nil}
    end
    
    #
    # Attempt to require(who) the most friendly way as possible.
    #
    def friendly_require(who, dep = nil, retried = false)
      gem(who, dep) if dep && defined?(Gem)
      require who
    rescue LoadError => ex
      if retried
        raise "Unable to require #{who}, which is now needed\n"\
              "Try 'gem install #{who}'"
      else
        require 'rubygems' unless defined?(Gem)
        friendly_require(who, dep, true)
      end
    end

    # Returns the unqualified name of a ruby class or module
    #
    # Example
    #
    #   class_name(Alf::Tools) -> :Tools
    #
    def class_name(clazz)
      clazz.name.to_s =~ /([A-Za-z0-9_]+)$/
      $1.to_sym
    end
    
    #
    # Converts an unqualified class or module name to a ruby case method name.
    #
    # Example
    #
    #    ruby_case(:Alf)  -> "alf"
    #    ruby_case(:HelloWorld) -> "hello_world"
    # 
    def ruby_case(s)
      s.to_s.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1]
    end
    
    #
    # Returns the first non nil values from arguments
    #
    # Example
    #
    #   coalesce(nil, 1, "abc") -> 1
    #
    def coalesce(*args)
      found = args.find{|x| !x.nil?}
      found.nil? ? (block_given? ? yield : nil) : found
    end
    
    #
    # Iterates over enum and yields the block on each element. 
    # Collect block results as key/value pairs returns them as 
    # a Hash.
    #
    def tuple_collect(enum)
      Hash[enum.collect{|elm| yield(elm)}]
    end

    #
    # Infers the heading from a tuple
    #
    def tuple_heading(tuple)
      Heading[tuple_collect(tuple){|k,v| [k, v.class]}]
    end

  end # module Tools
end # module Alf
