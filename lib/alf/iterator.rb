module Alf
  #
  # Marker module for all elements implementing tuple iterators.
  #
  # At first glance, an iterator is nothing else than an Enumerable that serves tuples
  # (represented by ruby hashes). However, this module helps Alf's internal classes to
  # recognize enumerables that may safely be considered as tuple iterators from other
  # enumerables. For this reason, all elements that would like to participate to an
  # iteration chain (that is, an logical operator implementation) should be marked with
  # this module. This is the case for all Readers and Operators defined in Alf.
  #
  module Iterator
    include Enumerable

    # Coerces something to an iterator
    def self.coerce(arg, database = nil)
      case arg
      when Iterator, Array
        arg
      when String, Symbol
        Relvar::Base.new(database, arg.to_sym)
      else
        Reader.coerce(arg, database)
      end
    end

    # Converts this iterator to an in-memory Relation.
    #
    # @return [Relation] a relation instance, as the set of tuples that would be yield by
    # this iterator.
    def to_relation
      Relation::new(self.to_set)
    end
    alias :to_rel :to_relation

  end # module Iterator
end # module Alf
