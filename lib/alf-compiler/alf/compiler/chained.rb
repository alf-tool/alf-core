module Alf
  class Compiler
    class Chained < Compiler

      def initialize(head, tail)
        @head = head
        @tail = tail
      end

      def _call(expr, compiled)
        @head._call(expr, compiled){
          @tail._call(expr, compiled)
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
