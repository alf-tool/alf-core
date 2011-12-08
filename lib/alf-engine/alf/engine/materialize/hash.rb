module Alf
  module Engine
    module Materialize
      class Hash < Cog

        # @return [Enumerable] The operand
        attr_reader :operand

        # @return [AttrList] Attributes for the hash key
        attr_reader :key

        # Creates a Hash instance
        def initialize(operand, key)
          @operand = operand
          @key = key
          @materialized = nil
        end

        # (see Cog#each)
        def each(&block)
          materialize.each_value do |rel|
            rel.each(&block)
          end
        end

        # Returns tuples that match a given key.
        #
        # This method returns a Cog instance in all case. En empty Cog is 
        # returned if no tuples match the key.
        #
        # @param [Tuple] key a tuple key
        # @return [Cog] the tuples from operand that match `key`
        def [](key)
          m = materialize
          m.has_key?(key) ? m[key] : []
        end

        private

        # Materializes the operand as a hash
        def materialize
          @materialized ||= begin
            h = ::Hash.new{|h,k| h[k] = []}
            operand.each do |tuple|
              k = @key.project_tuple(tuple)
              h[k] << tuple
            end
            h
          end
        end

      end # class Hash
    end # module Materialize
  end # module Engine
end # module Alf
