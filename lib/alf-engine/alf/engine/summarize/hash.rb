module Alf
  module Engine
    class Summarize::Hash
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Summarization key
      attr_reader :by

      # @return [Summarization] The summarization to use
      attr_reader :summarization

      # @return [Boolean] Make an allbut summarization?
      attr_reader :allbut

      # Creates an Summarize::Hash instance
      def initialize(operand, by, summarization, allbut)
        @operand = operand
        @by = by
        @summarization = summarization
        @allbut = allbut
      end

      # (see Cog#each)
      def each
        index = Materialize::Hash.new(operand, by, allbut)
        index.each_pair do |k, v|
          yield k.merge(summarization.summarize(v))
        end
      end

    end # class Summarize::Cesure
  end # module Engine
end # module Alf
