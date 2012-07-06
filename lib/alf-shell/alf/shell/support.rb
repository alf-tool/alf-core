module Alf
  module Shell
    module Support

      def database
        requester && requester.database
      end

      def operand(op)
        Iterator.coerce(op, database)
      end

      def operands(argv, size = nil)
        operands = [ stdin_reader ] + Array(argv).map{|arg| operand(arg)}
        size ? operands[(operands.size - size)..-1] : operands
      end

      def stdin_reader
        if requester && requester.respond_to?(:stdin_reader)
          requester.stdin_reader
        else
          Reader.coerce($stdin)
        end
      end

    end # module Support
  end # module Shell
end # module Alf
