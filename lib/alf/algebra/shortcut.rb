module Alf
  module Algebra
    module Shortcut

      module DelegationMethods

        def type_check(options = {})
          expand.type_check(options = {})
        end

        def heading
          expand.heading
        end

        def keys
          expand.keys
        end

        Algebra::Operator.listen do |name, clazz|
          define_method(name) do |*args|
            operands, arguments = args[0...clazz.arity], args[clazz.arity..-1]
            clazz.new(operands, *arguments)
          end
        end

      end # module DelegationMethods

      def self.included(mod)
        super
        mod.instance_eval{
          include(Operator)
          include(Relational)
          include(DelegationMethods)
        }
      end

    end # module Shortcut
  end # module Algebra
end # module Alf
require_relative 'shortcut/allbut'
