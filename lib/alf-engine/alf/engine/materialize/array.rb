module Alf
  module Engine
    #
    # Provides in-memory materialization through a ruby Array.
    #
    # This class acts as a Cog, that it, it is an enumerable of tuples. An 
    # optional ordering can be passed at construction.
    # 
    # Materialization occurs at prepare time, with auto-prepare on first 
    # access.
    #
    # Example:
    #
    #     rel = [
    #       {:name => "Jones", :city => "London"},
    #       {:name => "Smith", :city => "Paris"},
    #       {:name => "Blake", :city => "London"}
    #     ]
    #     
    #     Materialize::Array.new(rel).to_a
    #     # => same as rel, in same order as the source
    #     
    #     Materialize::Array.new(rel, Ordering[[:name, :asc]]).to_a
    #     # => [
    #            {:name => "Blake", :city => "London"},
    #            {:name => "Jones", :city => "London"},
    #            {:name => "Smith", :city => "Paris"}
    #          ]
    #
    class Materialize::Array < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Ordering] Ordering to ensure (optional)
      attr_reader :ordering

      # Creates a Materialize::Array instance
      def initialize(operand, ordering = nil, context=nil)
        super(context)
        @operand = operand
        @ordering = ordering
        @materialized = nil
      end

      # (see Cog#each)
      def each(&block)
        materialized.each(&block)
      end

      # (see Cog#prepare)
      #
      # Prepare through materialization of the operand as an ordered array
      def prepare
        @materialized ||= begin
          arr = operand.to_a
          arr.sort!(&ordering.sorter) if ordering
          arr
        end
      end

      # (see Cog#free)
      #
      # Frees the materizalied hash
      def clean
        @materialized = nil
      end

      private 

      # @return [Array] the materialized array
      def materialized
        prepare
        @materialized
      end

    end # class Materialize::Array
  end # module Engine
end # module Alf
