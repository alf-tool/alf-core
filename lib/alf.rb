require "alf/version"
require "alf/loader"

require "enumerator"
require "stringio"
require "set"

require 'myrrha/to_ruby_literal'
require 'myrrha/coerce'

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf

  #
  # Encapsulates all types
  #
  module Types
    require 'alf/types/attr_name'
    require 'alf/types/boolean'
    require 'alf/types/heading'
    require 'alf/types/ordering'
    require 'alf/types/attr_list'
    require 'alf/types/renaming'
    require 'alf/types/tuple_expression'
    require 'alf/types/restriction'
    require 'alf/types/summarization'
    require 'alf/types/tuple_computation'

    # Install all types on Alf now
    constants.each do |s|
      Alf.const_set(s, const_get(s))
    end
  end

  #
  # Provides tooling methods that are used here and there in Alf.
  # 
  module Tools
    require 'alf/tools/coerce'
    require 'alf/tools/to_ruby_literal'
    require 'alf/tools/tuple_handle'
    require 'alf/tools/signature'
    require 'alf/tools/miscellaneous'

    extend Tools
  end # module Tools
  
  #
  # Encapsulates the interface with the outside world, providing base iterators
  # for named datasets, among others.
  #
  # An environment is typically obtained through the factory defined by this
  # class:
  #
  #   # Returns the default environment (examples, for now)
  #   Alf::Environment.default
  #
  #   # Returns an environment on Alf's examples
  #   Alf::Environment.examples
  #
  #   # Returns an environment on a specific folder, automatically
  #   # resolving datasources via Readers' recognized file extensions
  #   Alf::Environment.folder('path/to/a/folder')
  #
  # You can implement your own environment by subclassing this class and 
  # implementing the {#dataset} method. As additional support is implemented 
  # in the base class, Environment should never be mimiced.
  #
  # This class provides an extension point allowing to participate to auto 
  # detection and resolving of the --env=... option when alf is used in shell.
  # See Environment.register, Environment.autodetect and Environment.recognizes?
  # for details. 
  # 
  class Environment
    require 'alf/environment/class_methods'
    require 'alf/environment/base'
    require 'alf/environment/explicit'
    require 'alf/environment/folder'

  end # class Environment

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
  end # module Iterator

  #
  # Implements an Iterator at the interface with the outside world.
  #
  # The contrat of a Reader is simply to be an Iterator. Unlike operators, 
  # however, readers are not expected to take other iterators as input, but IO 
  # objects, database tables, or something similar instead. This base class 
  # provides a default behavior for readers that works with IO objects. It can 
  # be safely extended, overriden, or even mimiced (provided that you include 
  # and implement the Iterator contract).
  #
  # This class also provides a registration mechanism to help getting Reader 
  # instances for specific file extensions. A typical scenario for using this
  # registration mechanism is as follows:
  #
  #   # Registers a reader kind named :foo, associated with ".foo" file 
  #   # extensions and the FooFileDecoder class (typically a subclass of 
  #   # Reader)
  #   Reader.register(:foo, [".foo"], FooFileDecoder)   
  #
  #   # Later on, you can request a reader instance for a .foo file, as 
  #   # illustrated below.  
  #   r = Reader.reader('/a/path/to/a/file.foo')
  #
  #   # Also, a factory method is automatically installed on the Reader class
  #   # itself. This factory method can be used with a String, or an IO object.
  #   r = Reader.foo([a path or a IO object])
  #
  class Reader
    include Iterator

    require 'alf/reader/class_methods'
    require 'alf/reader/base'
    require 'alf/reader/rash'
    require 'alf/reader/alf_file'
  end # class Reader

  #
  # Renders a relation (given by any Iterator) in a specific format.
  #
  # A renderer takes an Iterator instance as input and renders it on an output
  # stream. Renderers are **not** iterators themselves, even if they mimic the
  # {#pipe} method. Their usage is made via the {#execute} method.
  #
  # Similarly to the {Reader} class, this one provides a registration mechanism
  # for specific output formats. The common scenario is as follows:
  #
  #   # Register a new renderer for :foo format (automatically provides the 
  #   # '--foo   Render output as a foo stream' option of 'alf show') and with
  #   # the FooRenderer class for handling rendering.  
  #   Renderer.register(:foo, "as a foo stream", FooRenderer)
  #
  #   # Later on, you can request a renderer instance for a specific format
  #   # as follows (wiring input is optional) 
  #   r = Renderer.renderer(:foo, [an Iterator])
  #
  #   # Also, a factory method is automatically installed on the Renderer class
  #   # itself.
  #   r = Renderer.foo([an Iterator])
  #
  class Renderer
    require 'alf/renderer/class_methods'
    require 'alf/renderer/base'
    require 'alf/renderer/rash'
    require 'alf/renderer/text'

  end # class Renderer

  #
  # Marker module and namespace for Alf main commands, those that are **not** 
  # operators at all. 
  #
  module Command

    # Main documentation folder
    DOC_FOLDER = File.expand_path('../../doc/commands', __FILE__)

    # This is the main documentation extractor
    DOC_EXTRACTOR = lambda{|cmd, options|
      file = File.join(DOC_FOLDER, "#{cmd.command_name}.md")
      if File.exists?(file)
        text = File.read(file)
        cmd.instance_eval("%Q{#{text}}", file, 0)
      else
        "Sorry, no documentation available for #{cmd.command_name}"
      end
    }

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
    def Alf.Command(file = nil, line = nil) 
      if file
        Quickl::Command(file, line){|builder|
          builder.command_parent = Alf::Command::Main
          yield(builder) if block_given?
        }
      else
        Quickl::Command(){|builder|
          builder.command_parent = Alf::Command::Main
          builder.doc_extractor  = DOC_EXTRACTOR
          yield(builder) if block_given?
        }
      end
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
    def Alf.Operator(file, line)
      Alf.Command(file, line) do |b|
        b.instance_module Alf::Operator
      end
    end

    require 'alf/operator/class_methods'
    require 'alf/operator/base'
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
      require 'alf/operator/relational/project'
      require 'alf/operator/relational/extend'
      require 'alf/operator/relational/rename'
      require 'alf/operator/relational/restrict'
      require 'alf/operator/relational/join'
      require 'alf/operator/relational/intersect'
      require 'alf/operator/relational/minus'
      require 'alf/operator/relational/union'
      require 'alf/operator/relational/matching'
      require 'alf/operator/relational/not_matching'
      require 'alf/operator/relational/wrap'
      require 'alf/operator/relational/unwrap'
      require 'alf/operator/relational/group'
      require 'alf/operator/relational/ungroup'
      require 'alf/operator/relational/summarize'
      require 'alf/operator/relational/rank'
      require 'alf/operator/relational/quota'
  
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
    require 'alf/aggregator/base'
    require 'alf/aggregator/aggregators'

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
    
    Agg = Alf::Aggregator
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
