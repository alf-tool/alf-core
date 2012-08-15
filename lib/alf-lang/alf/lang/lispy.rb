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
    class Lispy < Tools::Scope

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

        def query(expr = nil, path = nil, line = nil, &block)
          expr = parse(expr, path, line, &block)
          expr = context.optimizer.call(expr)
          cog  = context.compiler.call(expr)
          Tools.to_relation(cog)
        end

        def tuple_extract(*args, &bl)
          query(*args, &bl).tuple_extract
        end

        def relvar(expr = nil, path = nil, line = nil, &block)
          Relvar.new context, parse(expr, path, line, &block)
        end

      end # OwnMethods

      # Creates a language instance
      def initialize(context = nil, helpers = [ Lang::Functional ])
        @context = context
        super [ OwnMethods ] + helpers
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
