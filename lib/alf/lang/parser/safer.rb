require 'ruby_cop'
module Alf
  module Lang
    module Parser
      class Safer
        include Parser

        def initialize(helpers = [], connection = nil)
          @lispy = Lispy.new(helpers, connection)
        end

        def parse(expr = nil, *rest, &bl)
          if expr.nil? and bl
            raise SecurityError, "Parsing of ruby blocks forbidden"
          end
          return expr if expr.is_a?(Algebra::Operand)
          check_safety!(expr.to_s)
          @lispy.parse(expr.to_s, *rest, &bl)
        end

      private

        def check_safety!(query)
          policy = Policy.new
          ast    = RubyCop::NodeBuilder.build(query)
          unless ast.accept(policy)
            raise SecurityError, "Forbidden for security reasons"
          end
          query
        end

        class Policy < RubyCop::Policy

          ALF_CALL_BLACKLIST = %w[
            gem
            to_cog
            to_relvar
            to_relation
            insert
            delete
            update
          ].to_set.freeze

          def visit_Call(node)
            super && !ALF_CALL_BLACKLIST.include?(node.identifier.token.to_s)
          end

          ALF_CONSTANT_WHITELIST = %w[
            DEE
            DUM
          ].to_set.freeze

          def visit_Constant(node)
            ALF_CONSTANT_WHITELIST.include?(node.token.to_s)
          end

          def visit_ConstantAssignment(node)
            raise SecurityError, "Forbidden: constant assignment"
          end

        end # class Policy

      end # class Safer
    end # module Parser
  end # module Lang
end # module Alf
