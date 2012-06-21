module Alf
  module Lang
    #
    # Implements a small LISP-like DSL on top of Alf abstract language.
    #
    # The lispy dialect is the functional one used in .alf files and in compiled expressions
    # as below:
    #
    #   Alf.database(...).compile do
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   end
    #
    # The DSL this class provides is part of Alf's public API and won't be broken without a
    # major version change. The class itself and its specific use is not part of the DSL
    # itself, thus not considered as part of the public API, and may therefore evolve
    # at any time. In other words, this class is not intended to be directly outside Alf.
    #
    class Lispy
      alias :ruby_extend :extend

      # The underlying database
      attr_accessor :database

      include Alf::Lang::Algebra
      include Alf::Lang::Aggregation
      include Alf::Lang::Literals

      # Creates a language instance
      def initialize(database)
        @database = database
      end

      # Compiles a query expression given by a String or a block and returns
      # the result (typically a tuple iterator).
      #
      # @see Database.compile
      #
      def _compile(expr = nil, path = nil, line = nil, &block)
        if expr.nil?
          instance_eval(&block)
        else
          path = path.to_s if path
          Kernel.eval expr, *[_clean_binding, path, line].compact, &block
        end
      end

      private

        def _clean_binding
          binding
        end

    end # class Lispy
  end # module Lang
end # module Alf
