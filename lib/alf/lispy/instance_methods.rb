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
      compiled = compile(expr, path, &block)
      case compiled
      when Iterator
        compiled.to_rel
      else
        compiled
      end
    end

    #
    # Coerces `h` to a valid tuple.
    #
    # @param [Hash] h, a hash mapping symbols to values
    #
    def Tuple(h)
      unless h.keys.all?{|k| k.is_a?(Symbol)} &&
             h.values.all?{|v| !v.nil?}
        raise ArgumentError, "Invalid tuple literal #{h.inspect}"
      end
      h
    end

    #
    # Coerces `args` to a valid relation.
    #
    def Relation(first, *args)
      if args.empty?
        if first.is_a?(Symbol)
          environment.dataset(first).to_rel
        elsif first.is_a?(Hash)
          Alf::Relation[first]
        else
          raise ArgumentError, "Unable to coerce `#{first.inspect}` to a relation"
        end
      else
        Alf::Relation[*args.unshift(first)] 
      end
    end

    # 
    # Install the DSL through iteration over defined operators
    #
    Operator.each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |child, *args|
          child = Iterator.coerce(child, environment)
          op_class.new([child], *args)
        end
      elsif op_class.binary?
        define_method(meth_name) do |left, right, *args|
          operands = [left, right].map{|x| Iterator.coerce(x, environment)}
          op_class.new(operands, *args)
        end
      elsif op_class.nullary?
        define_method(meth_name) do |*args|
          op_class.new([], *args)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each

    # 
    # Install the DSL through iteration over defined aggregators
    #
    Aggregator.each do |agg_class|
      agg_name = Tools.ruby_case(Tools.class_name(agg_class)).to_sym
      if method_defined?(agg_name)
        raise "Unexpected method clash on Lispy: #{agg_name}"
      else
        define_method(agg_name) do |*args, &block|
          agg_class.new(*args, &block)
        end
      end
    end

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
      argv = Quickl.parse_commandline_args(argv) if argv.is_a?(String)
      argv = Quickl.split_commandline_args(argv, '|')
      argv.inject(nil) do |cmd,arr|
        arr.shift if arr.first == "alf"
        main = Alf::Command::Main.new(environment)
        main.stdin_reader = cmd unless cmd.nil?
        main.run(arr, requester)
      end
    end

    private 

    def _clean_binding
      binding
    end

  end # module Lispy
end # module Alf
