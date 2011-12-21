module Alf
  module Shell
    module Operator
      module ClassMethods

        attr_accessor :operator_class

        # Returns the ruby case name of this operator
        def rubycase_name 
          Tools.ruby_case(Tools.class_name(self))
        end
        
        # @return false
        def command?
          false
        end

        # @return true
        def operator?
          true
        end

        # @return true if the underlying operator is relational
        def relational?
          operator_class.relational?
        end

        # @return true if the underlying operator is experimental
        def experimental?
          operator_class.experimental?
        end
        
        def run(argv, req = nil)
        end

      end # module ClassMethods

      # Defines a command for `clazz`
      def self.define_operator(clazz)
        superclass = Shell::Operator() do |b|
          b.callback do |cmd|
            cmd.operator_class = clazz
          end
        end
        Operator.const_set(Tools.class_name(clazz), Class.new(superclass)) 
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