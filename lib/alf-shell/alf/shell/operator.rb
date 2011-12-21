module Alf
  module Shell
    module Operator

      # Defines a command for `clazz`
      def self.define_operator(clazz)
      
      end
    
      Alf::Operator::Relational.each do |op_class|
        define_operator(op_class)
      end
    
      Alf::Operator::NonRelational.each do |op_class|
        define_operator(op_class)
      end
    
    end
  end
end