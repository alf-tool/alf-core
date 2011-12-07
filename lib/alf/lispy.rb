module Alf
  #
  # Implements a small LISP-like DSL on top of Alf.
  #
  # The lispy dialect is the functional one used in .alf files and in compiled
  # expressions as below:
  #
  #   Alf.lispy.compile do
  #     (restrict :suppliers, lambda{ city == 'London' })
  #   end
  #
  # The DSL this module provides is part of Alf's public API and won't be broken 
  # without a major version change. The module itself and its inclusion pre-
  # conditions are not part of the DSL itself, thus not considered as part of 
  # the API, and may therefore evolve at any time. In other words, this module 
  # is not intended to be directly included by third-party classes. 
  #
  module Lispy
    require 'alf/lispy/instance_methods'

    DUM = Relation::DUM
    DEE = Relation::DEE
  end # module Lispy
end # module Alf
