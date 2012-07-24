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
      def initialize(context, name, &builder)
        super(context, name)
        @builder = builder
      end

      # Returns the relvar heading
      def heading
        context.heading(name)
      end

      # Returns the relvar keys
      def keys
        context.keys(name)
      end

    protected

      # Request a reader through the builder
      def compile(context)
        @builder.call(context)
      end

    end # class Base
  end # class Relvar
end # module Alf