module Alf
  #
  # This module defines a namespace for useful datatypes as well as a few 
  # typing tools. Defined types are automatically defined as constants on the 
  # Alf module itself.
  #
  module Types
    require 'alf/types/boolean'
    require 'alf/types/size'
    require 'alf/types/attr_name'
    require 'alf/types/attr_list'
    require 'alf/types/heading'
    require 'alf/types/ordering'
    require 'alf/types/renaming'
    require 'alf/types/summarization'
    require 'alf/types/tuple_expression'
    require 'alf/types/tuple_predicate'
    require 'alf/types/tuple_computation'

    # Returns the (least) common super type of c1 and c2.
    #
    # The least common super type is defined as the lowest ancestor shared 
    # between c1 and c2.
    #
    # Examples:
    #
    #     Types.common_super_type(String, String)  # => String
    #     Types.common_super_type(Integer, Float)  # => Numeric
    #     Types.common_super_type(Integer, String) # => Object
    #
    # @param [Class] c1 a data type, respresented by a ruby class
    # @param [Class] c2 a data type, respresented by a ruby class
    # @return [Class] the least common super type of c1 and c2
    def common_super_type(c1, c2)
      return c1 if c1 == c2
      ancestors = [c1, c2].map{|c| 
        c.ancestors.select{|a| a.is_a?(Class)}
      }
      (ancestors[0] & ancestors[1]).first
    end
    module_function :common_super_type

    # Install all types on Alf now
    constants.each do |s|
      Alf.const_set(s, const_get(s))
    end

  end # module Types
end # module Alf
