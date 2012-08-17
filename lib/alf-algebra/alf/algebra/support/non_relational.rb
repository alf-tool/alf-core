module Alf
  module Algebra
    module NonRelational

      class << self
        include Support::Registry

        def included(mod)
          super
          register(mod, NonRelational)
        end
      end

    end # NonRelational
  end # module Algebra
end # module Alf
