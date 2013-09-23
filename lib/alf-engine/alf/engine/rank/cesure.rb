module Alf
  module Engine
    class Rank::Cesure
      include Rank
      include Engine::Cesure

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] List of attributes that form the operand ordering
      attr_reader :by

      # @return [AttrName] Name of the introduced attribute
      attr_reader :as

      # Creates an Rank::Cesure instance
      def initialize(operand, by, as, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @by = by.to_attr_list
        @as = as
      end

      protected

      # (see Cesure#project)
      def project(tuple)
        @by.project_tuple(tuple, false)
      end

      # (see Cesure#start_cesure)
      def start_cesure(key, receiver)
        @rank ||= 0
        @last_block = 0
      end

      # (see Cesure#accumulate_cesure)
      def accumulate_cesure(tuple, receiver)
        receiver.call tuple.merge(@as => @rank)
        @last_block += 1
      end

      # (see Cesure#flush_cesure)
      def flush_cesure(key, receiver)
        @rank += @last_block
      end

    end # class Rank::Cesure
  end # module Engine
end # module Alf
