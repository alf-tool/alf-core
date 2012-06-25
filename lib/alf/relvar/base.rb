module Alf
  class Relvar
    #
    # A base relation variable.
    #
    class Base < Relvar

      # Creates a relvar instance.
      #
      # @param [Database] database the database to which this relvar belongs.
      # @param [Symbol] name name of the relation variable.
      def initialize(database, name)
        super(database, name)
      end

    protected

      # Request a reader through Database#dataset
      def compile(context)
        context.dataset(name)
      end

    end # class Base
  end # class Relvar
end # module Alf