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
    class Lispy < Tools::Scope

      module OwnMethods

        def database
          @database
        end

      end # OwnMethods

      # Creates a language instance
      def initialize(database = nil, helpers = [ Lang::Algebra, Lang::Aggregation, Lang::Literals ])
        super [ OwnMethods ] + helpers
        @database = database
      end

    end # class Lispy
  end # module Lang
end # module Alf
