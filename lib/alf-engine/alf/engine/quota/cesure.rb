module Alf
  module Engine
    class Quota::Cesure
      include Engine::Cesure

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] List of attributes for 'quota by'
      attr_reader :by

      # @return [Summarization] Quota computations as a summarization
      attr_reader :summarization

      # Creates an Quota::Cesure instance
      def initialize(operand, by, summarization, expr = nil)
        super(expr)
        @operand = operand
        @by = by.to_attr_list
        @summarization = summarization
      end

      protected

      # (see Cesure#project)
      def project(tuple)
        @by.project_tuple(tuple, false)
      end

      # (see Cesure#start_cesure)
      def start_cesure(key, receiver)
        @scope = tuple_scope unless @scope
        @aggs  = @summarization.least
      end

      # (see Cesure#accumulate_cesure)
      def accumulate_cesure(tuple, receiver)
        @aggs = @summarization.happens(@aggs, @scope.__set_tuple(tuple))
        receiver.call tuple.merge(@summarization.finalize(@aggs))
      end

      # (see Cesure#flush_cesure)
      def flush_cesure(key, receiver)
        @scope = nil
      end

    end # class Quota::Cesure
  end # module Engine
end # module Alf
