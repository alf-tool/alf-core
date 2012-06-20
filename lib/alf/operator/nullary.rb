module Alf
  module Operator
    # 
    # Specialization of Operator for operators without operands
    #
    module Nullary
      include Operator

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

    end # module Nullary
  end # module Operator
end # module Alf
