module Alf
  module Sequel
    #
    # Specialization of Alg::Iterator to work on a Sequel dataset
    #
    class Iterator
      include Alf::Iterator

      # Creates an iterator instance
      def initialize(dataset)
        @dataset = dataset
      end

      # (see Alf::Iterator#each)
      def each
        @dataset.each(&Proc.new)
      end

    end # class Iterator
  end # module Sequel
end # module Alf
