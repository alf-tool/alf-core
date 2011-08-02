module Alf
  module Lispy
    
    alias :ruby_extend :extend
    
    # The environment
    attr_accessor :environment
    
    #
    # Compiles a query expression given by a String or a block and returns
    # the result (typically a tuple iterator)
    #
    # Example
    #
    #   # with a string
    #   op = compile "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   op = compile {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    # @param [String] expr a Lispy expression to compile
    # @return [Iterator] the iterator resulting from compilation
    #
    def compile(expr = nil, path = nil, &block)
      if expr.nil? 
        instance_eval(&block)
      else 
        b = _clean_binding
        (path ? Kernel.eval(expr, b, path) : Kernel.eval(expr, b))
      end
    end
  
    #
    # Evaluates a query expression given by a String or a block and returns
    # the result as an in-memory relation (Alf::Relation)
    #
    # Example:
    #
    #   # with a string
    #   rel = evaluate "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   rel = evaluate {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    def evaluate(expr = nil, path = nil, &block)
      compile(expr, path, &block).to_rel
    end
    
    #
    # Delegated to the current environment
    #
    # This method returns the dataset associated to a given name. The result
    # may depend on the current environment, but is generally an Iterator, 
    # often a Reader instance.
    #
    # @param [Symbol] name name of the dataset to retrieve
    # @return [Iterator] the dataset as an iterator
    # @see Environment#dataset
    #
    def dataset(name)
      raise "Environment not set" unless @environment
      @environment.dataset(name)
    end

    # Functional equivalent to Alf::Relation[...]
    def relation(*tuples)
      Relation.coerce(tuples)
    end
   
    # 
    # Install the DSL through iteration over defined operators
    #
    Operator::each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |child, *args|
          child = Iterator.coerce(child, environment)
          op_class.new(*args).pipe(child, environment)
        end
      elsif op_class.binary?
        define_method(meth_name) do |left, right, *args|
          operands = [left, right].collect{|x| Iterator.coerce(x, environment)}
          op_class.new(*args).pipe(operands, environment)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each
      
    def allbut(child, attributes)
      (project child, attributes, :allbut => true)
    end
  
    # 
    # Runs a command as in shell.
    #
    # Example:
    #
    #     lispy = Alf.lispy(Alf::Environment.examples)
    #     op = lispy.run(['restrict', 'suppliers', '--', "city == 'Paris'"])
    #
    def run(argv, requester = nil)
      Alf::Command::Main.new(environment).run(argv, requester)
    end

    private 
    
    def _clean_binding
      binding
    end
  
  end # module Lispy
end # module Alf
