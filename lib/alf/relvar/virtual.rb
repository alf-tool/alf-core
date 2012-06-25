module Alf
  class Relvar
    #
    # A virtual relation variable, aka a view.
    #
    class Virtual < Relvar

      # Expression in algebra expression for this view.
      attr_reader :expression

      # Creates a relvar instance.
      #
      # @param [Database] database the database to which this relvar belongs.
      # @param [Symbol] name name of the relation variable.
      def initialize(database, name = nil, expression=nil, &defn)
        super(database, name)
        @expression = expression || database.compile(&defn)
      end

    protected

      # Ask the expression to compile itself.
      def compile(context)
        expression.compile(context)
      end

    end # class Virtual
  end # class Relvar
end # module Alf