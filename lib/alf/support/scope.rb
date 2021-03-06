module Alf
  module Support
    #
    # Implements a sandboxed scope abstraction through a BasicObject.
    #
    # Example:
    #
    #     module Foo; ... end
    #     module Bar; ... end
    # 
    #     Scope.new([Foo, Bar]).evaluate{
    #       # Foo and Bar instance methods are available
    #       # Kernel's methods are not
    #     }
    #
    class Scope < BasicObject

      module OwnMethods

        # Delegated to ::Kernel
        def lambda(*args, &block)
          ::Kernel.lambda(*args, &block)
        end

        # Evaluates an expression in the scope.
        #
        # @param [Proc] bl an expression to evaluate as a Proc.
        # @return [Object] the result of evaluting `expr` on self
        def evaluate(expr = nil, path=nil, line=nil, &bl)
          return instance_exec(&bl) if bl
          ::Kernel.eval expr, __eval_binding, *[path, line].compact
        end

      ### private section ###

        # Returns true if the decorated tuple has `name` as key.
        def respond_to?(name, include_private = false)
          return true if @extensions.any?{|m| m.method_defined?(name) }
          return true if BasicObject.method_defined?(name)
          @parent && @parent.respond_to?(name)
        end

        # Returns true.
        def respond_to_missing?(symbol, include_private = false)
          @parent && @parent.respond_to?(symbol, include_private)
        end

        # Delegated to parent if any.
        def method_missing(name, *args, &bl)
          @parent ? @parent.__send__(name, *args, &bl) : super
        rescue NoMethodError => ex
          name = ex.message[/`(.*?)'/, 1]
          ::Kernel.raise NoMethodError, "Not found `#{name}` on #{self}"
        end

        # Returns the binding to use for an evaluation
        #
        # @return [Binding] a binding object that captures this scope.
        def __eval_binding
          RUBY_VERSION < "1.9" ? binding : ::Kernel.binding
        end

        # Branches this scope with `arg`, returning a child scope of this one.
        def __branch(arg)
          case arg
          when ::Hash then TupleScope.new(arg, [], self)
          else
            Kernel::raise NotImplementedError, "Unable to branch with `#{arg}`"
          end
        end

      end # module OwnMethods

      # Creates a scope instance
      def initialize(extensions = [], parent = nil)
        @extensions = [ OwnMethods ] + extensions
        @extensions.each do |ext|
          ext.send(:extend_object, self)
        end
        @parent = parent
      end

    end # class Scope
  end # module Support
end # module Alf
