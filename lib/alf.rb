require "alf/version"
require "alf/loader"
require "alf/errors"

require "enumerator"
require "stringio"
require "set"

require 'myrrha/to_ruby_literal'
require 'myrrha/coerce'

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf
  require 'alf/types'
  require 'alf/tools'
  require 'alf/environment'
  require 'alf/iterator'
  require 'alf/reader'
  require 'alf/renderer'

  require 'alf/command'
  require 'alf/operator'

  #
  # Aggregation operator.
  #
  class Aggregator
    require 'alf/aggregator/class_methods'
    require 'alf/aggregator/instance_methods'
    require 'alf/aggregator/count'
    require 'alf/aggregator/sum'
    require 'alf/aggregator/min'
    require 'alf/aggregator/max'
    require 'alf/aggregator/avg'
    require 'alf/aggregator/variance'
    require 'alf/aggregator/stddev'
    require 'alf/aggregator/collect'
    require 'alf/aggregator/concat'

  end # class Aggregator
  
  #
  # Base class for implementing buffers.
  # 
  class Buffer
    require 'alf/buffer/sorted'

  end # class Buffer

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

  #
  # Builds and returns a lispy engine on a specific environment.
  #
  # Example(s):
  #
  #   # Returns a lispy instance on the default environment
  #   lispy = Alf.lispy
  #
  #   # Returns a lispy instance on the examples' environment
  #   lispy = Alf.lispy(Alf::Environment.examples)
  #
  #   # Returns a lispy instance on a folder environment of your choice
  #   lispy = Alf.lispy(Alf::Environment.folder('path/to/a/folder'))
  #
  # @see Alf::Environment about available environments and their contract
  #
  def self.lispy(env = Environment.default)
    lispy = Object.new.extend(Lispy)
    lispy.environment = Environment.coerce(env)
    lispy
  end
  
end # module Alf
require "alf/extra"
