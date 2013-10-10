module Alf
  module Support
    class Tree

      def initialize(root)
        @root = root
      end
      attr_reader :root

      def label(node)
        node.first.to_s
      end

      def children(node)
        node[1..-1]
      end

      def to_text(buffer = '', node = root, depth = 0, open = [])
        depth.times do |i|
          buffer << ((i==depth-1) ? "+-- " : (open[i] ? "|  " : '   '))
        end
        buffer << label(node) << "\n"
        children = children(node)
        children.each_with_index do |child, index|
          open[depth] = (index != children.size-1)
          to_text(buffer, child, depth+1, open)
        end
        buffer
      end
      alias :to_s :to_text

    end # class Tree
  end # module Support
end # module Alf
