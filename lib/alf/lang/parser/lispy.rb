module Alf
  module Lang
    module Parser
      class Lispy
        include Parser
        include Functional
        include Predicates

        def initialize(helpers = [], connection = nil)
          @connection = connection
          @extensions = helpers
          helpers.each do |helper|
            helper.send(:extend_object, self)
          end
        end
        attr_reader :connection

        def connection!
          connection.tap{|c|
            ::Kernel.raise(UnboundError, "#{self} not bound") unless c
          }
        end

        def parse(expr = nil, path = nil, line = nil, &block)
          if (expr && block) || (expr.nil? and block.nil?)
            raise ArgumentError, "Either `expr` or `block` should be specified"
          end
          expr = evaluate(expr, path, line, &block) if block or expr.is_a?(String)
          expr = __send__(expr)                     if expr.is_a?(Symbol)
          expr
        end

        def to_s
          "Lispy(#{@extensions.map(&:name).compact.join(',')})"
        end

        def inspect
          "Lispy(#{@extensions.inspect})"
        end

      private

        def evaluate(expr = nil, path=nil, line=nil, &bl)
          return instance_exec(&bl) if bl
          instance_eval(expr, *[path, line].compact.map(&:to_s))
        end

      public

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
    end # module Parser
  end # module Lang
end # module Alf
