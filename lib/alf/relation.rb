module Alf
  #
  # Defines an in-memory relation data structure.
  #
  # A relation is a set of tuples; a tuple is a set of attribute (name, value)
  # pairs. The class implements such a data structure with full relational
  # algebra installed as instance methods.
  #
  # Relation values can be obtained in various ways, for example by invoking
  # a relational operator on an existing relation. Relation literals are simply
  # constructed as follows:
  #
  #     Alf::Relation[
  #       # ... a comma list of ruby hashes ...
  #     ]
  #
  # See main Alf documentation about relational operators.
  #
  class Relation
    include Iterator

    require "alf/relation/class_methods"
    require "alf/relation/instance_methods"

    DEE = Relation.coerce([{}])
    DUM = Relation.coerce([])
  end # class Relation
end # module Alf
