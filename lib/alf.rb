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
    require 'alf/types/ordering_key'
    require 'alf/types/projection_key'
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
    require 'alf/environment/explicit'
    require 'alf/environment/folder'
    
    #
    # Returns a dataset whose name is provided.
    #
    # This method resolves named datasets to tuple enumerables. When the 
    # dataset exists, this method must return an Iterator, typically a 
    # Reader instance. Otherwise, it must throw a NoSuchDatasetError.
    #
    # @param [Symbol] name the name of a dataset
    # @return [Iterator] an iterator, typically a Reader instance
    # @raise [NoSuchDatasetError] when the dataset does not exists
    #
    def dataset(name)
    end
    undef :dataset
    
    #
    # Branches this environment and puts some additional explicit 
    # definitions.
    #
    # This method is provided for (with ...) expressions and should not
    # be overriden by subclasses.
    #
    # @param [Hash] a set of (name, Iterator) pairs.
    # @return [Environment] an environment instance with new definitions set
    #
    def branch(defs)
      Explicit.new(defs, self)
    end
    
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

    #
    # Wire the iterator input and an optional execution environment.
    #
    # Iterators (typically Reader and Operator instances) work from input data 
    # that come from files, or other operators, and so on. This method wires 
    # this input data to the iterator. Wiring is required before any attempt
    # to call each, unless autowiring occurs at construction. The exact kind of
    # input object is left at discretion of Iterator implementations.
    #
    # @param [Object] input the iterator input, at discretion of the Iterator
    #        implementation.
    # @param [Environment] environment an optional environment for resolving
    #        named datasets if needed.
    # @return [Object] self
    #
    def pipe(input, environment = nil)
      self
    end
    undef :pipe
    
    # 
    # Coerces something to an iterator
    #
    def self.coerce(arg, environment = nil)
      case arg
      when Iterator, Array
        arg
      else
        Reader.coerce(arg, environment)
      end
    end
    
    #
    # Converts this iterator to an in-memory Relation.
    #
    # @return [Relation] a relation instance, as the set of tuples
    #         that would be yield by this iterator.
    #
    def to_rel
      Relation::coerce(self)
    end
    
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
  end # module Reader

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
  end # module Renderer

  #
  # Marker module and namespace for Alf main commands, those that are **not** 
  # operators at all. 
  #
  module Command
    def Alf.Command(file, line) 
      Quickl::Command(file, line){|builder|
        builder.command_parent = Alf::Command::Main
        yield(builder) if block_given?
      }
    end
    require 'alf/command/main'
    require 'alf/command/exec'
    require 'alf/command/help'
    require 'alf/command/show'
  end
  
  #
  # Marker for all operators, relational and non-relational ones.
  # 
  module Operator
    def Alf.Operator(file, line)
      Alf.Command(file, line) do |b|
        b.instance_module Alf::Operator
      end
    end
    include Iterator, Tools
    require 'alf/operator/class_methods'
    require 'alf/operator/base'
    require 'alf/operator/unary'
    require 'alf/operator/binary'
    require 'alf/operator/cesure'
    require 'alf/operator/transform'
    require 'alf/operator/shortcut'
    require 'alf/operator/experimental'
  end # module Operator

  #
  # Marker module and namespace for non relational operators
  #
  module Operator::NonRelational
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
    
  end # Operator::NonRelational
  
  #
  # Marker module and namespace for relational operators
  #
  module Operator::Relational
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
  
  end

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
    
    protected
    
    # @return [Set] the set of tuples
    attr_reader :tuples
    
    public
    
    #
    # Creates a Relation instance.
    #
    # @param [Set] tuples a set of tuples
    #
    def initialize(tuples)
      raise ArgumentError unless tuples.is_a?(Set)
      @tuples = tuples
    end
    
    #
    # Coerces `val` to a relation.
    #
    # Recognized arguments are: Relation (identity coercion), Set of ruby hashes, 
    # Array of ruby hashes, Alf::Iterator.
    #
    # @return [Relation] a relation instance for the given set of tuples
    # @raise [ArgumentError] when `val` is not recognized
    #
    def self.coerce(val)
      case val
      when Relation
        val
      when Set
        Relation.new(val)
      when Array
        Relation.new val.to_set
      when Iterator
        Relation.new val.to_set
      else
        raise ArgumentError, "Unable to coerce #{val} to a Relation"
      end
    end
    
    # (see Relation.coerce)
    def self.[](*tuples)
      coerce(tuples)
    end
    
    #
    # (see Iterator#each)
    #
    def each(&block)
      tuples.each(&block)
    end
    
    #
    # Returns relation's cardinality (number of tuples).
    #
    # @return [Integer] relation's cardinality 
    # 
    def cardinality
      tuples.size
    end
    alias :size :cardinality
    alias :count :cardinality
    
    # Returns true if this relation is empty
    def empty?
      cardinality == 0
    end
    
    # 
    # Install the DSL through iteration over defined operators
    #
    Operator::each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |*args|
          op = op_class.new(*args).pipe(self)
          Relation.coerce(op)
        end
      elsif op_class.binary?
        define_method(meth_name) do |right, *args|
          op = op_class.new(*args).pipe([self, Iterator.coerce(right)])
          Relation.coerce(op)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each
      
    alias :+ :union
    alias :- :minus

    # Shortcut for project(attributes, true)
    def allbut(attributes)
      project(attributes, true)
    end
        
    #
    # (see Object#hash)
    #
    def hash
      @tuples.hash
    end
    
    #
    # (see Object#==)
    #
    def ==(other)
      return nil unless other.is_a?(Relation)
      other.tuples == self.tuples
    end
    alias :eql? :==
    
    #
    # Returns a textual representation of this relation
    #
    def to_s
      Alf::Renderer.text(self).execute("")
    end
    
    #
    # Returns an array with all tuples in this relation.
    #
    # @param [Tools::OrderingKey] an optional ordering key (any argument 
    #        recognized by OrderingKey.coerce is supported here). 
    # @return [Array] an array of hashes, in requested order (if specified)
    #
    def to_a(okey = nil)
      okey = Tools.coerce(okey, OrderingKey) if okey
      ary = tuples.to_a
      ary.sort!(&okey.sorter) if okey
      ary
    end
    
    #
    # Returns a  literal representation of this relation
    #
    def to_ruby_literal
      "Alf::Relation[" +
        tuples.collect{|t| Tools.to_ruby_literal(t)}.join(', ') + "]"
    end
    alias :inspect :to_ruby_literal
  
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
    
    alias :ruby_extend :extend
    
    # The environment
    attr_accessor :environment
    
    #
    # Compiles a query expression given by a String or a block and returns
    # the result (typically a tuple iterator)
    #
    # Example
    #
    #   # with a string
    #   op = compile "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   op = compile {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    # @param [String] expr a Lispy expression to compile
    # @return [Iterator] the iterator resulting from compilation
    #
    def compile(expr = nil, path = nil, &block)
      if expr.nil? 
        instance_eval(&block)
      else 
        b = _clean_binding
        (path ? Kernel.eval(expr, b, path) : Kernel.eval(expr, b))
      end
    end
  
    #
    # Evaluates a query expression given by a String or a block and returns
    # the result as an in-memory relation (Alf::Relation)
    #
    # Example:
    #
    #   # with a string
    #   rel = evaluate "(restrict :suppliers, lambda{ city == 'London' })"
    #
    #   # or with a block
    #   rel = evaluate {
    #     (restrict :suppliers, lambda{ city == 'London' })
    #   }
    #
    def evaluate(expr = nil, path = nil, &block)
      compile(expr, path, &block).to_rel
    end
    
    #
    # Delegated to the current environment
    #
    # This method returns the dataset associated to a given name. The result
    # may depend on the current environment, but is generally an Iterator, 
    # often a Reader instance.
    #
    # @param [Symbol] name name of the dataset to retrieve
    # @return [Iterator] the dataset as an iterator
    # @see Environment#dataset
    #
    def dataset(name)
      raise "Environment not set" unless @environment
      @environment.dataset(name)
    end

    # Functional equivalent to Alf::Relation[...]
    def relation(*tuples)
      Relation.coerce(tuples)
    end
   
    # 
    # Install the DSL through iteration over defined operators
    #
    Operator::each do |op_class|
      meth_name = Tools.ruby_case(Tools.class_name(op_class)).to_sym
      if op_class.unary?
        define_method(meth_name) do |child, *args|
          child = Iterator.coerce(child, environment)
          op_class.new(*args).pipe(child, environment)
        end
      elsif op_class.binary?
        define_method(meth_name) do |left, right, *args|
          operands = [left, right].collect{|x| Iterator.coerce(x, environment)}
          op_class.new(*args).pipe(operands, environment)
        end
      else
        raise "Unexpected operator #{op_class}"
      end
    end # Operators::each
      
    def allbut(child, attributes)
      (project child, attributes, true)
    end
  
    # 
    # Runs a command as in shell.
    #
    # Example:
    #
    #     lispy = Alf.lispy(Alf::Environment.examples)
    #     op = lispy.run(['restrict', 'suppliers', '--', "city == 'Paris'"])
    #
    def run(argv, requester = nil)
      Alf::Command::Main.new(environment).run(argv, requester)
    end
    
    Agg = Alf::Aggregator
    DUM = Relation::DUM
    DEE = Relation::DEE
    
    private 
    
    def _clean_binding
      binding
    end
    
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
require "alf/text"
require "alf/yaml"
require "alf/csv"
