module Alf
  module Lang
    module Algebra

      # Install the DSL through iteration over defined operators
      Operator.each do |op_class|

        define_method(op_class.rubycase_name.to_sym) do |*args|
          operands  = args[0...op_class.arity].map{|x| 
            Iterator.coerce(x, _environment)
          }
          arguments = args[op_class.arity..-1]
          op_class.new(operands, *arguments)
        end

      end # Operators::each

      # (see Algebra#project)
      def allbut(child, attributes)
        Operator::Relational::Project.new [child], attributes, :allbut => true
      end

      private

      def _environment
        respond_to?(:environment) ? environment : nil
      end

    end # module Algebra
  end # module Lang
end # module Alf
