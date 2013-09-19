module Alf
  #
  # This module defines a namespace for useful datatypes as well as a few typing tools.
  # Defined types are automatically defined as constants on the Alf module itself.
  #
  module Types

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
      if x = (c1 <=> c2)
        x >= 0 ? c1 : c2
      else
        ancestors = [c1, c2].map{|c| c.ancestors.select{|a| a.is_a?(Class)} }
        (ancestors[0] & ancestors[1]).first
      end
    end
    module_function :common_super_type

    require_relative 'types/boolean'
    require_relative 'types/size'
    require_relative 'types/attr_name'
    require_relative 'types/selector'
    require_relative 'types/selection'
    require_relative 'types/attr_list'
    require_relative 'types/heading'
    require_relative 'types/ordering'
    require_relative 'types/renaming'
    require_relative 'types/summarization'
    require_relative 'types/tuple_expression'
    require_relative 'types/tuple_computation'
    require_relative 'types/keys'
    require_relative 'types/type_check'

    # Install all types on Alf now
    constants.each do |s|
      Alf.const_set(s, const_get(s))
    end

  end # module Types
end # module Alf
