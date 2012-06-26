module Alf
  module Lang
    module Support

    private

      def _operator_output(op)
        op
      end

      def _context
        respond_to?(:context) ? context : nil
      end

    end # module Support
  end # module Lang
end # module Alf