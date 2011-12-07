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

  #
  # Marker module for all elements implementing tuple iterators.
  #
  # At first glance, an iterator is nothing else than an Enumerable that serves 
  # tuples (represented by ruby hashes). However, this module helps Alf's internal
  # classes to recognize enumerables that may safely be considered as tuple 
  # iterators from other enumerables. For this reason, all elements that would
  # like to participate to an iteration chain (that is, an logical operator 
  # implementation) should be marked with this module. This is the case for 
  # all Readers and Operators defined in Alf.
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

  require 'alf/reader'
  require 'alf/renderer'

  #
  # Marker module and namespace for Alf main commands, those that are **not** 
  # operators at all. 
  #
  module Command
    require 'alf/command/class_methods'
    require 'alf/command/doc_manager'

    # This is the main documentation extractor
    DOC_EXTRACTOR = DocManager.new

    #
    # Delegator command factory
    #
    def Alf.Delegator() 
      Quickl::Delegator(){|builder|
        builder.doc_extractor = DOC_EXTRACTOR
        yield(builder) if block_given?
      }
    end

    #
    # Command factory
    #
    def Alf.Command() 
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Command::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        yield(builder) if block_given?
      }
    end

    require 'alf/command/main'
    require 'alf/command/exec'
    require 'alf/command/help'
    require 'alf/command/show'
  end # module Command
  
  #
  # Marker for all operators, relational and non-relational ones.
  # 
  module Operator
    include Iterator, Tools

    #
    # Operator factory
    #
    def Alf.Operator()
      Alf.Command() do |b|
        b.instance_module Alf::Operator
      end
    end

    require 'alf/operator/class_methods'
    require 'alf/operator/signature'
    require 'alf/operator/base'
    require 'alf/operator/nullary'
    require 'alf/operator/unary'
    require 'alf/operator/binary'
    require 'alf/operator/cesure'
    require 'alf/operator/transform'
    require 'alf/operator/shortcut'
    require 'alf/operator/experimental'

    
    #
    # Marker module and namespace for non relational operators
    #
    module NonRelational
      require 'alf/operator/non_relational/autonum'
      require 'alf/operator/non_relational/defaults'
      require 'alf/operator/non_relational/compact'
      require 'alf/operator/non_relational/sort'
      require 'alf/operator/non_relational/clip'
      require 'alf/operator/non_relational/coerce'
      require 'alf/operator/non_relational/generator'
  
      #
      # Yields the block with each operator module in turn
      #
      def self.each
        constants.each do |c|
          val = const_get(c)
          yield(val) if val.ancestors.include?(Operator::NonRelational)
        end
      end
      
    end # NonRelational
    
    #
    # Marker module and namespace for relational operators
    #
    module Relational
      require 'alf/operator/relational/extend'
      require 'alf/operator/relational/project'
      require 'alf/operator/relational/restrict'
      require 'alf/operator/relational/rename'

      require 'alf/operator/relational/union'
      require 'alf/operator/relational/minus'
      require 'alf/operator/relational/intersect'
      require 'alf/operator/relational/join'

      require 'alf/operator/relational/matching'
      require 'alf/operator/relational/not_matching'

      require 'alf/operator/relational/wrap'
      require 'alf/operator/relational/unwrap'

      require 'alf/operator/relational/group'
      require 'alf/operator/relational/ungroup'

      require 'alf/operator/relational/summarize'
      require 'alf/operator/relational/rank'
      require 'alf/operator/relational/quota'

      require 'alf/operator/relational/heading'
  
      # 
      # Yields the block with each operator module in turn
      #
      def self.each
        constants.each do |c|
          val = const_get(c)
          yield(val) if val.ancestors.include?(Operator::Relational)
        end
      end
    
    end # module Relational
    
  end # module Operator

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
