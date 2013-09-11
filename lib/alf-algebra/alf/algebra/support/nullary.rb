module Alf
  module Algebra
    #
    # Specialization of Operator for operators without operands
    #
    module Nullary

      # Class-level methods
      module ClassMethods

        # (see Operator::ClassMethods#arity)
        def arity
          0
        end

      end # module ClassMethods

      def self.included(mod)
        super
        mod.extend(ClassMethods)
      end

      def to_cog
        Engine::Compilable.new(nil).to_cog(self)
      end

    end # module Nullary
  end # module Algebra
end # module Alf
