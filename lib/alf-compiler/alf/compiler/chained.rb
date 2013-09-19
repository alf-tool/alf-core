module Alf
  class Compiler
    class Chained < Compiler

      def initialize(head, tail)
        @head = head
        @tail = tail
      end

      def __call(expr, compiled, &fallback)
        @head.__call(expr, compiled){
          @tail.__call(expr, compiled)
        }
      end

      def &(other)
        raise ArgumentError unless other.is_a?(Chained)
        return self if other == self
        return self if head  == other.head
        return tail if tail  == other.tail
        tail & other.tail
      end

    end # class Chained
  end # class Compiler
end # module Alf
