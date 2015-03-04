module Alf
  module Engine
    #
    # Provides in-memory materialization through a ruby Hash.
    #
    # This class acts as a Cog, that it, it is an enumerable of tuples. No 
    # particular ordering is guaranteed. In addition, the class provides 
    # indexed access through the `[]` method. 
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
    #     op = Materialize::Hash.new(rel, AttrList[:city])
    #
    #     op.to_a 
    #     # => same as rel, no ordering guaranteed
    #
    #     op[:city => "London"].to_a
    #     # => [
    #            {:name => "Jones", :city => "London"},
    #            {:name => "Blake", :city => "London"}
    #          ]
    #
    #     op[:city => "London"].to_a
    #     # => [
    #            {:name => "Jones", :city => "London"},
    #            {:name => "Blake", :city => "London"}
    #          ]
    #
    #     op[:city => "Athens"].to_a
    #     # => []
    #
    class Materialize::Hash
      include Materialize
      include Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList|Proc] Attributes for the hash key
      attr_accessor :key

      # @return [Boolean] Hash on all but specified attributes?
      attr_accessor :allbut

      # @return [Proc] a proc that returns the neural value for newly found index
      # keys
      attr_accessor :neutral

      # @return [Proc] a proc that accumulates tuples (key, accumulator, tuple)
      attr_accessor :accumulate

      # Creates a Materialize::Hash instance
      def initialize(operand, key = [], allbut = false, expr = nil, compiler = nil)
        super(expr, compiler)
        @operand = operand
        @key = key
        @allbut = allbut
        @neutral = ->(key){
          []
        }
        @accumulate = ->(key, accumulator, tuple){
          accumulator << tuple
        }
        @materialized = nil
      end

      # (see Cog#each)
      def _each(&block)
        materialized.each_value do |rel|
          rel.each(&block)
        end
      end

      # Yields indexed (key, tuples) pairs in turn.
      def each_pair(&block)
        materialized.each_pair(&block)
      end

      # Returns tuples that match a given key.
      #
      # This method returns a Cog instance in all case. En empty Cog is 
      # returned if no tuples match the key.
      #
      # @param [Tuple] key_tuple a key tuple
      # @param [Boolean] project project `key_tuple` on key first?
      # @return [Cog] the tuples from operand that match `key_tuple`
      def [](key_tuple, project = false)
        key_tuple = key_for(key_tuple) if project
        m = materialized
        m.has_key?(key_tuple) ? m[key_tuple] : []
      end

      # (see Cog#prepare)
      #
      # Prepare through materialization of the operand as a hash
      def prepare
        @materialized ||= begin
          h = ::Hash.new{|h,k| h[k] = @neutral.call(h) }
          operand.each do |tuple|
            index_key = key_for(tuple)
            @accumulate.call(index_key, h[index_key], tuple)
          end
          h
        end
        self
      end

      # (see Cog#free)
      #
      # Frees the materizalied hash
      def clean
        @materialized = nil
      end

      private

      # Projects `tuple` to get the indexing key
      def key_for(tuple)
        @key = @key.call(tuple) unless @key.is_a?(AttrList)
        @key.project_tuple(tuple, @allbut)
      end

      # @return [Hash] the materialized hash
      def materialized
        prepare
        @materialized
      end

    end # class Materialize::Hash
  end # module Engine
end # module Alf
