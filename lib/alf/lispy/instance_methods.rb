module Alf
  module Lispy
    alias :ruby_extend :extend

    # The environment
    attr_accessor :environment

    include Alf::Lang::Algebra
    include Alf::Lang::Aggregation

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
        main = Alf::Shell::Main.new(environment)
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
