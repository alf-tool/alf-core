module Alf
  module Lang
    module Support

    private

      def _with_ordering(options, &bl)
        case options
        when Array, Ordering
          _with_ordering(:sort => options, &bl)
        when Hash
          ordering = options.delete(:order) || options.delete(:sort)
          ordering = Ordering.coerce(ordering || [])
          yield(ordering)
        else
          ::Kernel.raise "Invalid ordering `#{options}`"
        end
      end

      def _operator_output(op)
        op
      end

      def _context
        respond_to?(:context) ? context : nil
      end

    end # module Support
  end # module Lang
end # module Alf