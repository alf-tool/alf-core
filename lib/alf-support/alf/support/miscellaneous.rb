module Alf
  module Support

    # Returns the unqualified name of a ruby class or module.
    #
    # Example
    #
    #   class_name(Alf::Support) -> :Support
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

    # Converts `name` to a rubycase name, as a Symbol.
    #
    # Example:
    #   rubycase_name(Alf)        => :alf
    #   rubycase_name(HelloWorld) => :hello_world
    #
    # @param [Object] any object, typically a Class, Symbol or String
    # @return [Symbol] a symbol capturing `name` in ruby-like casing
    def rubycase_name(name)
      name = class_name(name) if name.is_a?(Module)
      name = ruby_case(name.to_s)
      name.to_sym
    end

    # Symbolizes all keys of `tuple`
    #
    # @param  [Hash]  tuple a tuple, represented by a Hash
    # @return [Tuple] the same tuple, with all keys as Symbols
    def symbolize_keys(tuple)
      Hash[tuple.map{|k,v| [k.to_sym, v] }]
    end

  end # module Support
end # module Alf
