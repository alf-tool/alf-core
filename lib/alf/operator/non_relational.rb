module Alf
  module Operator
    module NonRelational

      class << self
        include Support::Registry

        def included(mod)
          super
          register(mod, NonRelational)
        end
      end

    end # NonRelational
  end # module Operator
end # module Alf
require_relative 'non_relational/autonum'
require_relative 'non_relational/defaults'
require_relative 'non_relational/compact'
require_relative 'non_relational/sort'
require_relative 'non_relational/clip'
require_relative 'non_relational/coerce'
require_relative 'non_relational/generator'
