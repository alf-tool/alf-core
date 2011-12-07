module Alf
  module Engine
    #
    # Renames tuples from the operand according to a Renaming info.
    # 
    # Example:
    #
    #     rel = [
    #       {:name => "Jones", :city => "London"}
    #     ]
    #     Rename.new(rel, Renaming[:name => :last_name]).to_a
    #     # => [
    #     #      {:last_name => "Jones", :city => "London"}
    #     #    ]
    #
    class Rename < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [Renaming] Renaming info
      attr_reader :renaming

      # Creates a Rename instance
      def initialize(operand, renaming)
        @operand = operand
        @renaming = renaming
      end

      # (see Cog#each)
      def each
        operand.each do |tuple|
          yield @renaming.rename_tuple(tuple)
        end
      end

    end # class Rename
  end # module Engine
end # module Alf
