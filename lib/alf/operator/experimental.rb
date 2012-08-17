module Alf
  module Operator
    #
    # Marker for experimental operators
    #
    module Experimental

      class << self
        include Support::Registry

        def included(mod)
          super
          register(mod, Experimental)
        end
      end

    end # module Experimental
  end # module Operator
end # module Alf
