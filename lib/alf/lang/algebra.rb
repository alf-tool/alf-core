module Alf
  module Lang
    module Algebra

      # Install the DSL through iteration over defined operators
      Operator.listen do |op_name, op_class|

        define_method(op_name) do |*args|
          operands  = args[0...op_class.arity].map{|x| Iterator.coerce(x, _context) }
          arguments = args[op_class.arity..-1]
          op_class.new(_context, operands, *arguments)
        end

      end # Operators::each

      # (see Algebra#project)
      def allbut(child, attributes)
        Operator::Relational::Project.new _context, [child], attributes, :allbut => true
      end

      private

        def _context
          respond_to?(:context) ? context : nil
        end

    end # module Algebra
  end # module Lang
end # module Alf
