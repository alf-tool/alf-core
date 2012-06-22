module Alf
  module Tools
    #
    # Provides a handle for implementing a flyweight design pattern on tuples.
    #
    # This class works hand-in-hand with TupleExpression as it provides a scope
    # for their evaluation on tuples.
    #
    # Example:
    #
    #   handle = TupleHandle.new
    #   expr   = TupleExpression["status > 10"]
    #   relation.each do |tuple|
    #     expr.evaluate(handle.set(tuple))
    #   end
    #
    class TupleHandle < BasicObject

      # Creates a handle instance
      def initialize(*args)
        @tuple      = nil
        @extensions = []
        args.each do |arg|
          case arg
            when ::Hash   then __build(@tuple = arg)
            when ::Module then __extend(arg)
            else
              raise ArgumentError, "Unable to use `#{arg}` for scoping"
          end
        end
      end

      # Returns true if the decorated tuple has `name` as key.
      def respond_to?(name)
        return true if @tuple && @tuple.has_key?(name)
        return true if [:__set_tuple, :__build, :__extend].include?(name)
        name = name.to_s if ::RUBY_VERSION < "1.9"
        return true if BasicObject.instance_methods.include?(name)
        return true if @extensions.any?{|m| m.instance_methods.include?(name) }
        false
      end

      # Evaluates a tuple expression on the current tuple.
      #
      # @param [Object] expr a tuple expression (coercions apply)
      # @return [Object] the result of evaluting `expr` on self
      def evaluate(expr = nil, &bl)
        TupleExpression.coerce(expr || bl).evaluate(self)
      end

      ### private section ###

        # Sets the next tuple to use.
        #
        # On first call, this method installs the handle as a side effect.
        #
        # @param [Tuple] tuple the current iterated tuple
        # @return [TupleHandle] self
        def __set_tuple(tuple)
          __build(tuple) if @tuple.nil?
          @tuple = tuple
          self
        end

        # Builds this handle with a tuple.
        #
        # This method should be called only once and installs instance methods on
        # the handle with keys of _tuple_.
        def __build(tuple)
          tuple.keys.each do |k|
            (class << self; self; end).send(:define_method, k) do
              @tuple[k]
            end
          end
          self
        end
        private :__build

        # Extends this handle with a module.
        #
        # Instance methods of `mod` will be accessible in this handle scope. `respond_to?`
        # also support the new added methods
        def __extend(mod)
          mod.send(:extend_object, self)
          @extensions << mod
          self
        end

    end # class TupleHandle
  end # module Tools
end # module Alf
