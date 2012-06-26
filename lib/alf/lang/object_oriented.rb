module Alf
  module Lang
    module ObjectOriented
      include Support

      class << self
        def def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block).aggregate(self)
          end
        end

        def def_operator_method(name, clazz)
          define_method(name) do |*args|
            args.unshift(self)
            operands  = args[0...clazz.arity].map{|x| Iterator.coerce(x, _context) }
            arguments = args[clazz.arity..-1]
            _operator_output clazz.new(_context, operands, *arguments)
          end
        end
      end

      Aggregator.listen do |name, clazz|
        def_aggregator_method(name, clazz)
      end

      Operator.listen do |name, clazz|
        def_operator_method(name, clazz)
      end

      def allbut(attributes)
        project(attributes, :allbut => true)
      end

      def +(other)
        union(other)
      end
      alias :| :+

      def -(other)
        minus(other)
      end

      def *(other)
        join(other)
      end

      def &(other)
        intersect(other)
      end

      def =~(other)
        matching(other)
      end

      def to_relation
        Tools.to_relation(self)
      end

      def to_array(options = {})
        _with_ordering(options) do |o|
          Alf::Engine::ToArray.new(self, o).to_a
        end
      end

      def to_a(options = nil)
        options.nil? ? super() : to_array(options)
      end

    end # module ObjectOriented
  end # module Lang
end # module Alf