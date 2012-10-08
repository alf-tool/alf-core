module Alf
  module Lang
    #
    # Implements a small LISP-like DSL on top of Alf abstract language.
    #
    # The lispy dialect is the functional one used in .alf files and in compiled expressions
    # as below:
    #
    #   Alf.connect(...).query do
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   end
    #
    # The DSL this class provides is part of Alf's public API and won't be broken without a
    # major version change. The class itself and its specific use is not part of the DSL
    # itself, thus not considered as part of the public API, and may therefore evolve
    # at any time. In other words, this class is not intended to be directly outside Alf.
    #
    class Lispy < Support::Scope

      module OwnMethods

        def context
          @context
        end

        def parse(expr = nil, path = nil, line = nil, &block)
          if (expr && block) || (expr.nil? and block.nil?)
            raise ArgumentError, "Either `expr` or `block` should be specified"
          end
          expr = evaluate(expr, path, line, &block) if block or expr.is_a?(String)
          expr = __send__(expr)                     if expr.is_a?(Symbol)
          expr
        end

        def optimize(expr)
          context.optimizer.call(expr)
        end

        def compile(expr)
          context.compiler.call(expr)
        end

        def query(expr = nil, path = nil, line = nil, &block)
          expr = parse(expr, path, line, &block)
          expr = optimize(expr)
          cog  = compile(expr)
          Relation.coerce(cog)
        end

        def assert!(*args, &bl)
          relvar(*args, &bl).not_empty!
        end

        def fact!(*args, &bl)
          relvar(*args, &bl).tuple_extract
        rescue NoSuchTupleError
          Kernel.raise ::Alf::FactAssertionError
        end

        def deny!(*args, &bl)
          relvar(*args, &bl).empty!
        end

        def tuple_extract(*args, &bl)
          query(*args, &bl).tuple_extract
        end

        def relvar(expr = nil, path = nil, line = nil, &block)
          expr = parse(expr, path, line, &block)
          expr.respond_to?(:to_relvar) ? expr.to_relvar : Relvar::Virtual.new(context, expr)
        end

      end # OwnMethods

      # Creates a language instance
      def initialize(context = nil, helpers = [ ])
        @context = context
        super [ OwnMethods, Functional, Predicates ] + helpers
      end

      # Resolve DUM and DEE in ruby 1.9.2 context
      def self.const_missing(name)
        case name.to_s
        when 'DEE' then ::Alf::Relation::DEE
        when 'DUM' then ::Alf::Relation::DUM
        else
          super
        end
      end

    end # class Lispy
  end # module Lang
end # module Alf
