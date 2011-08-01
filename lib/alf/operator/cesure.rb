module Alf
  module Operator
    #
    # Specialization of Operator for implementing operators that rely on a 
    # cesure algorithm.
    #
    module Cesure
      include Unary
      
      protected

      # (see Operator#_each)
      def _each
        receiver, prev_key = Proc.new, nil
        each_input_tuple do |tuple|
          cur_key = project(tuple)
          if cur_key != prev_key
            flush_cesure(prev_key, receiver) unless prev_key.nil?
            start_cesure(cur_key, receiver)
            prev_key = cur_key
          end
          accumulate_cesure(tuple, receiver)
        end
        flush_cesure(prev_key, receiver) unless prev_key.nil?
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
  end # module Operator
end # module Alf
