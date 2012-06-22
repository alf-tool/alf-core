module Alf
  module Tools
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

        # Returns true if the decorated tuple has `name` as key.
        def respond_to?(name)
          name = name.to_s if ::RUBY_VERSION < "1.9"
          return true if @extensions.any?{|m| m.instance_methods.include?(name) }
          return true if BasicObject.instance_methods.include?(name)
          false
        end

        # Evaluates an expression in the scope.
        #
        # @param [Proc] bl an expression to evaluate as a Proc.
        # @return [Object] the result of evaluting `expr` on self
        def evaluate(expr = nil, path=nil, line=nil, &bl)
          return instance_exec(&bl) if bl
          ::Kernel.eval expr, __eval_binding, *[path, line].compact
        end

        # Returns the binding to use for an evaluation
        #
        # @return [Binding] a binding object that captures this scope.
        def __eval_binding
          RUBY_VERSION < "1.9" ? binding : ::Kernel.binding
        end

      end # module OwnMethods

      # Creates a handle instance
      def initialize(extensions = [])
        @extensions = [ OwnMethods ] + extensions
        @extensions.each do |ext|
          ext.send(:extend_object, self)
        end
      end

    end # class Scope
  end # module Tools
end # module Alf