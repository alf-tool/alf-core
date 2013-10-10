module Alf
  module Engine
    module Cog
      include Compiler::Cog
      include Enumerable

      EMPTY_CHILDREN = [].freeze

      EMPTY_OPTIONS = {}.freeze

      def each(&bl)
        return to_enum unless block_given?
        _each(&bl)
      end

      def children
        return operands  if respond_to?(:operands)
        return [operand] if respond_to?(:operand)
        EMPTY_CHILDREN
      end

      def to_s
        label = ""
        label << Support.class_name(self.class).to_s
        label << " ..."
        unless (args = arguments).empty?
          label << ", "
          label << args.map{|arg| Support.to_lispy(arg) }.join(', ')
        end
        unless (opts = options).empty?
          label << ", "
          label << Support.to_lispy(options)
        end
        label
      end

      def arguments
        EMPTY_CHILDREN
      end

      def options
        EMPTY_OPTIONS
      end

      def to_dot(buffer = "")
        Engine::ToDot.new.call(self, buffer)
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

    end # module Cog
  end # module Engine
end # module Alf
