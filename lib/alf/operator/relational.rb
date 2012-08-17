module Alf
  module Operator
    module Relational

      class << self
        include Support::Registry

        def included(mod)
          super
          register(mod, Relational)
        end
      end

    end # module Relational
  end # module Operator
end # module Alf
require_relative 'relational/extend'
require_relative 'relational/project'
require_relative 'relational/restrict'
require_relative 'relational/rename'
require_relative 'relational/union'
require_relative 'relational/minus'
require_relative 'relational/intersect'
require_relative 'relational/join'
require_relative 'relational/matching'
require_relative 'relational/not_matching'
require_relative 'relational/wrap'
require_relative 'relational/unwrap'
require_relative 'relational/group'
require_relative 'relational/ungroup'
require_relative 'relational/summarize'
require_relative 'relational/rank'
require_relative 'relational/quota'
require_relative 'relational/infer_heading'
