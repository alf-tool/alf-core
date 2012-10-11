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
          expr = expr.bind(connection)              if expr.is_a?(Support::Bindable) && connection
          expr
        end

        attr_reader :connection

        def connection!
          connection.tap{|c| ::Kernel.raise UnboundError unless c }
        end

        def to_s
          "Lispy(#{@extensions.map(&:name).reject{|x| x =~ /OwnMethods/}.join(',')})"
        end
        alias_method :inspect, :to_s

      end # OwnMethods

      # Creates a language instance
      def initialize(helpers = [ ], connection = nil)
        @connection = connection
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
