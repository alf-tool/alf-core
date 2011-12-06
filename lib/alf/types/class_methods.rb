module Alf
  module Types

    def common_super_type(c1, c2)
      return c1 if c1 == c2
      ancestors = [c1, c2].map{|c| 
        c.ancestors.select{|a| a.is_a?(Class)}
      }
      (ancestors[0] & ancestors[1]).first
    end
    module_function :common_super_type

  end # module Types
end # module Alf
