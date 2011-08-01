module Alf
  class Buffer
    # 
    # Keeps tuples ordered on a specific key
    #
    # Example:
    #
    #   sorted = Buffer::Sorted.new OrderingKey.new(...)
    #   sorted.add_all(...)
    #   sorted.each do |tuple|
    #     # tuples are ordered here 
    #   end
    #
    class Sorted < Buffer
  
      #
      # Creates a buffer instance with an ordering key
      #
      def initialize(ordering_key)
        @ordering_key = ordering_key
        @buffer = []
      end
  
      #
      # Adds all elements of an iterator to the buffer
      #
      def add_all(enum)
        sorter = @ordering_key.sorter
        @buffer = merge_sort(@buffer, enum.to_a.sort(&sorter), sorter)
      end
  
      #
      # (see Buffer#each)
      #
      def each
        @buffer.each(&Proc.new)
      end
  
      private
    
      # Implements a merge sort between two iterators s1 and s2
      def merge_sort(s1, s2, sorter)
        (s1 + s2).sort(&sorter)
      end
  
    end # class Sorted
  end # class Buffer
end # module Alf