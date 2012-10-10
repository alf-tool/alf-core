module Alf
  module Lang
    class Lispy < Support::Scope

      module OwnMethods

        def parse(expr = nil, path = nil, line = nil, &block)
          if (expr && block) || (expr.nil? and block.nil?)
            raise ArgumentError, "Either `expr` or `block` should be specified"
          end
          expr = evaluate(expr, path, line, &block) if block or expr.is_a?(String)
          expr = __send__(expr)                     if expr.is_a?(Symbol)
          expr
        end

      end # OwnMethods

      # Creates a language instance
      def initialize(helpers = [ ])
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
