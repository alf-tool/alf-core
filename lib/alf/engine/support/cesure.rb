module Alf
  module Engine
    module Cesure
      include Cog

      # (see Cog#each)
      def each(&receiver)
        return to_enum unless block_given?
        dup._each(&receiver)
      end

      protected

      # (see Cog#each)
      def _each(&receiver)
        prev_key = nil
        operand.each do |tuple|
          cur_key = project(tuple)
          if cur_key != prev_key
            flush_cesure(prev_key, receiver) if prev_key
            start_cesure(cur_key, receiver)
            prev_key = cur_key
          end
          accumulate_cesure(tuple, receiver)
        end
        flush_cesure(prev_key, receiver) if prev_key
      end

      # Projects a given tuple and returns it's cesure projection
      def project(tuple)
      end
      
      # Callback fired every time a new block starts
      def start_cesure(key, receiver)
      end

      # Callback fired on each tuple of the current block 
      def accumulate_cesure(tuple, receiver)
      end

      # Callback fired at end of a block
      def flush_cesure(key, receiver)
      end

    end # module Cesure
  end # module Engine
end # module Alf
