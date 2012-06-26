module Alf
  module Lang
    module Functional

      class << self
        def def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block)
          end
        end

        def def_operator_method(name, clazz)
          define_method(name) do |*args|
            operands  = args[0...clazz.arity].map{|x| Iterator.coerce(x, _context) }
            arguments = args[clazz.arity..-1]
            clazz.new(_context, operands, *arguments)
          end
        end
      end

      # Coerces `h` to a valid tuple.
      #
      # @param [Hash] h, a hash mapping symbols to values
      def Tuple(h)
        unless h.keys.all?{|k| k.is_a?(::Symbol) } && h.values.all?{|v| !v.nil? }
          ::Kernel.raise ArgumentError, "Invalid tuple literal #{h.inspect}"
        end
        h
      end

      # Coerces `args` to a valid relation.
      def Relation(first, *args)
        if args.empty?
          ::Kernel.raise "(Relation :relvar_name) is no longer supported." if first.is_a?(::Symbol)
          Alf::Relation(first)
        else
          Alf::Relation[*args.unshift(first)]
        end
      end

      Aggregator.listen do |name, clazz|
        def_aggregator_method(name, clazz)
      end

      Operator.listen do |name, clazz|
        def_operator_method(name, clazz)
      end

      # (see #project)
      def allbut(child, attributes)
        project(child, attributes, :allbut => true)
      end

    private

      def _context
        respond_to?(:context) ? context : nil
      end

    end
  end
end