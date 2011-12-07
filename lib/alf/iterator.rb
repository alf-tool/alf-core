module Alf
  #
  # Marker module for all elements implementing tuple iterators.
  #
  # At first glance, an iterator is nothing else than an Enumerable that serves
  # tuples (represented by ruby hashes). However, this module helps Alf's
  # internal classes to recognize enumerables that may safely be considered as
  # tuple iterators from other enumerables. For this reason, all elements that
  # would like to participate to an iteration chain (that is, an logical
  # operator implementation) should be marked with this module. This is the case
  # for all Readers and Operators defined in Alf.
  #
  # Moreover, an Iterator should always define a {#pipe} method, which is the
  # natural way to define the input and execution environment of operators and 
  # readers.
  #
  module Iterator
    include Enumerable

    require 'alf/iterator/class_methods'
    require 'alf/iterator/base'
    require 'alf/iterator/proxy'
  end # module Iterator
end # module Alf
