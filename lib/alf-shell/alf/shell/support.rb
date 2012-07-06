module Alf
  module Shell
    module Support

      def database
        requester && requester.database
      end

      def compiler
        @compiler ||= Engine::Compiler.new(database)
      end

      def operands(argv, size = nil)
        operands = [ stdin_operand ] + Array(argv)
        operands = operands[(operands.size - size)..-1] if size
        operands = operands.map{|arg| compiler.compile(arg) }
      end

      def stdin_operand
        requester.stdin_operand rescue $stdin
      end

    end # module Support
  end # module Shell
end # module Alf
