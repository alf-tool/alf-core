module Alf
  module Lang
    module ObjectOriented
      include Support

      def self.new(self_operand)
        Module.new{
          include ObjectOriented
          define_method(:_self_operand) do
            self_operand
          end
          private :_self_operand
        }
      end

      class << self
        def def_aggregator_method(name, clazz)
          define_method(name) do |*args, &block|
            clazz.new(*args, &block).aggregate(_self_operand)
          end
        end

        def def_operator_method(name, clazz)
          define_method(name) do |*args|
            args.unshift(_self_operand)
            operands, arguments = args[0...clazz.arity], args[clazz.arity..-1]
            _operator_output clazz.new(operands, *arguments)
          end
        end

        def def_renderer_method(name, clazz)
          define_method(:"to_#{name}") do |*args|
            options, io = nil
            args.each do |arg|
              options ||= arg if arg.is_a?(Hash)
              io      ||= arg if arg.respond_to?(:<<)
            end
            to_array(options || {}) do |arr|
              io ||= ""
              clazz.new(arr, options).execute(io)
              io
            end
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
        Tools.to_relation(_self_operand)
      end

      def to_array(options = {})
        _with_ordering(options) do |o|
          op = Alf::Engine::ToArray.new(_compile, o)
          block_given? ? yield(op) : op.to_a
        end
      end

      def to_a(options = nil)
        options.nil? ? super() : to_array(options)
      end

      Renderer.listen do |name,clazz|
        def_renderer_method(name, clazz)
      end

      def tuple_extract
        tuple = nil
        each do |t|
          raise NoSuchTupleError if tuple
          tuple = t
        end
        tuple ||= yield if block_given?
        raise NoSuchTupleError unless tuple or block_given?
        Tuple(tuple)
      end
      alias :'tuple!' :tuple_extract

    private

      def _compile
        Alf::Engine::Compiler.new.call(_self_operand)
      end

      def _self_operand
        self
      end

    end # module ObjectOriented
  end # module Lang
end # module Alf
