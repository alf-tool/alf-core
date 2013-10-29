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
        label << self.class.name.to_s[/Engine::(.*?)$/, 1].to_s
        label << " ..."
        unless (args = arguments).empty?
          label << ", "
          label << args.map{|arg| Support.to_lispy(arg, "[unsupported]") }.join(', ')
        end
        unless (opts = options).empty?
          label << ", "
          label << Support.to_lispy(options, "[unsupported]")
        end
        label
      end

      def arguments
        EMPTY_CHILDREN
      end

      def options
        EMPTY_OPTIONS
      end

    protected

      def tuple_scope(tuple = nil)
        Support::TupleScope.new tuple, []
      end

      def symbolize(tuple)
        tuple = Support.symbolize_keys(tuple) if tuple.keys.any?{|k| String===k }
        tuple
      end

    end # module Cog
  end # module Engine
end # module Alf
