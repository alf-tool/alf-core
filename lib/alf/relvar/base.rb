module Alf
  class Relvar
    #
    # A base relation variable.
    #
    class Base < Relvar

      # Creates a relvar instance.
      #
      # @param [Object] context the context that served this relvar.
      # @param [Symbol] name name of the relation variable.
      def initialize(context, name)
        super(context, name)
      end

    protected

      # Request a reader through Database#dataset
      def compile(context)
        context.dataset(name)
      end

    end # class Base
  end # class Relvar
end # module Alf