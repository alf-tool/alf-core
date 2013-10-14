module Alf
  module Algebra
    module Relational

      class << self
        include Support::Registry

        def included(mod)
          super
          register(mod, Relational)
        end
      end

    end # module Relational
  end # module Algebra
end # module Alf
