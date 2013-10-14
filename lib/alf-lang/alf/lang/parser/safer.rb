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
          check_safety!(expr)
          @lispy.parse(expr, *rest, &bl)
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

          def visit_Constant(node)
            raise SecurityError, "Forbidden: usage of `#{node.token}`"
          end

          def visit_ConstantAssignment(node)
            raise SecurityError, "Forbidden: constant assignment"
          end

        end # class Policy

      end # class Safer
    end # module Parser
  end # module Lang
end # module Alf
