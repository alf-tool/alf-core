module Alf
  module Predicate
    class ProcParser
      class Expr < Tools::Scope

        module OwnMethods

          attr_reader :__ast

          def method_missing(name, *args, &bl)
            if args.empty? and bl.nil?
              __null_arity(name)
            else
              args = args.map{|arg| 
                arg.respond_to?(:__ast) ? arg.__ast : [:_literal, arg]
              }
              __expr([name, __ast] + args)
            end
          end

          def ==(other)
            method_missing(:==, other)
          end

          def !=(other)
            method_missing(:!=, other)
          end

          if RUBY_VERSION >= "1.9"
            def !
              __expr [:!, __ast]
            end
          end

        private

          def __null_arity(name)
            __expr(@__scope.respond_to?(name) ? [:_var_ref, name] : [name])
          end

          def __expr(ast)
            Expr.new(@__scope, ast)
          end

        end # OwnMethods

        def initialize(scope, ast = nil)
          super([ OwnMethods ])
          @__scope = scope
          @__ast   = ast
        end

      end # Expr

      def initialize(scope)
        @scope = scope
      end
      attr_reader :scope

      def parse(proc)
        Expr.new(scope, nil).evaluate(&proc).__ast
      end

    end # class ProcParser
  end # module Predicate
end # module Alf