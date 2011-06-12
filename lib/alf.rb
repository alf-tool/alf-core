def alf_required(retried)
  ["enumerator", 
   "quickl"].each{|req| require req}
rescue LoadError
  raise if retried
  require "rubygems"
  alf_required(true)
end
alf_required(false)

#
# alf - A commandline tool for relational inspired data manipulation
#
# SYNOPSIS
#   #{program_name} [--version] [--help] 
#   #{program_name} help COMMAND
#   #{program_name} COMMAND [cmd opts] ARGS ...
#
# OPTIONS
# #{summarized_options}
#
# COMMANDS
# #{summarized_subcommands}
#
# See '#{program_name} help COMMAND' for more information on a specific command.
#
class Alf < Quickl::Delegator(__FILE__, __LINE__)

  ##############################################################################
  #
  # PUBLIC API
  #
  # Alf's public APIs are defined below. 
  #
  
  # Alf's version 
  VERSION = "1.0.0"

  #
  # Provides a factory over Alf operators and handles the interface with
  # Quickl for commandline support.
  # 
  module Factory

    # @see Quickl::Command
    def Command(file, line)
      res = Quickl::Command(file, line)
      Quickl.command_builder{|b| yield(b)} if block_given?
      res
    end

    # @see Operator
    def Operator(file, line)
      Command(file, line) do |b|
        b.instance_module Alf::Operator
      end
    end

    # @see TransformOperator
    def TransformOperator(file, line)
      Command(file, line) do |b|
        b.instance_module Alf::TransformOperator
      end
    end

    # @see ShortcutOperator
    def ShortcutOperator(file, line)
      Command(file, line) do |b|
        b.instance_module Alf::ShortcutOperator
      end
    end

    # @see CesureOperator
    def CesureOperator(file, line)
      Command(file, line) do |b|
        b.instance_module Alf::CesureOperator
      end
    end

    extend Factory
  end # module Factory

  # 
  # Implements a small LISP-like DSL on top of Alf
  #
  module Lispy

    # Factors a DEFAULTS operator
    def defaults(child, defaults)
      _pipe(Defaults.new{|d| d.defaults = defaults}, child)
    end

    # Factors an EXTEND operator
    def extend(child, extensions)
      _pipe(Extend.new{|op| op.extensions = extensions}, child)
    end

    # Factors a PROJECT operator
    def project(child, *attrs)
      _pipe(Project.new{|p| p.attributes = attrs.flatten}, child)
    end

    # Factors a PROJECT-ALLBUT operator
    def allbut(child, *attrs)
      _pipe(Project.new{|p| p.attributes = attrs.flatten; p.allbut = true}, child)
    end

    # Factors a RENAME operator
    def rename(child, renaming)
      _pipe(Rename.new{|r| r.renaming = renaming}, child)
    end

    # Factors a RESTRICT operator
    def restrict(child, functor)
      _pipe(Restrict.new{|r| r.functor = Restrict.functor(functor)}, child)
    end

    # Factors a NEST operator
    def nest(child, nesting)
      _pipe(Nest.new{|r| r.attributes = nesting[nesting.keys.first]
                        r.as = nesting.keys.first}, child)
    end

    # Factors an UNNEST operator
    def unnest(child, attribute)
      _pipe(Unnest.new{|r| r.attribute = attribute}, child)
    end

    # Factors a GROUP operator
    def group(child, grouping)
      _pipe(Group.new{|r| r.attributes = grouping[grouping.keys.first]
                         r.as = grouping.keys.first}, child)
    end

    # Factors an UNGROUP operator
    def ungroup(child, attribute)
      _pipe(Ungroup.new{|r| r.attribute = attribute}, child)
    end

    # Factors an SORT operator
    def sort(child, ordering)
      _pipe(Sort.new{|r| r.ordering = ordering}, child)
    end

    private

    def _pipe(parent, child)
      child = case child
        when IO
          HashReader.new(child)
        when Array, Pipeable
          child
        else
          raise ArgumentError, "Unable to pipe with #{child}"
      end
      parent.pipe(child)
    end

    extend Lispy
  end # module Lispy

  ##############################################################################
  #
  # TOOLS
  #
  # The following modules and classes provide tools for implementing dataflow
  # elements.
  #
  
  #
  # Included by all elements of a tuple chain
  #
  module Pipeable

    # Input stream
    attr_reader :input

    #
    # Pipes with an input stream, typically a IO object
    #
    # This method simply sets _input_ under a variable instance of
    # same name and returns self.
    #
    def pipe(input)
      @input = input
      self
    end

    protected

    #
    # Yields the block with each input tuple.
    #
    # This method should be preferred to <code>input.each</code> when possible.
    #
    def each_input_tuple
      input.each &Proc.new
    end

  end # module Pipeable

  #
  # Provides a handle to implement a (TODO) fly design pattern on tuples.
  #
  class TupleHandle

    # Creates an handle instance
    def initialize
      @tuple = nil
    end

    #
    # Sets the next tuple to use.
    #
    # This method installs the handle as a side effect 
    # on first call. 
    #
    def set(tuple)
      build(tuple) if @tuple.nil?
      @tuple = tuple
      self
    end

    # 
    # Compiles a tuple expression and returns a lambda
    # instance that can be passed to evaluate later.
    # 
    def self.compile(expr)
      # TODO: refactor this to avoid relying on Kernel.eval
      expr.is_a?(Proc) ? expr : Kernel.eval("lambda{ #{expr} }")
    end

    #
    # Evaluates an expression on the current tuple. Expression
    # can be a lambda or a string (immediately compiled in the
    # later case).
    # 
    def evaluate(expr)
      if RUBY_VERSION < "1.9"
        instance_eval &TupleHandle.compile(expr)
      else
        instance_exec &TupleHandle.compile(expr)
      end
    end

    private

    #
    # Builds this handle with a tuple.
    #
    # This method should be called only once and installs 
    # instance methods on the handle with keys of _tuple_.
    #
    def build(tuple)
      # TODO: refactor me to avoid instance_eval
      tuple.keys.each do |k|
        self.instance_eval <<-EOF
          def #{k}; @tuple[#{k.inspect}]; end
        EOF
      end
    end

  end # class TupleHandle

  #
  # Provides tools for manipulating tuples
  #
  module TupleTools

    #
    # Iterates over enum and yields the block on each element. 
    # Collect block results as key/value pairs returns them as 
    # a Hash.
    #
    def tuple_collect(enum)
      tuple = {}
      enum.each do |elm| 
        k, v = yield(elm)
        tuple[k] = v
      end
      tuple
    end

  end # module TupleTools

  # 
  # Defines a projection key
  # 
  class ProjectionKey
    include TupleTools

    # Projection attributes
    attr_accessor :attributes

    # Allbut projection?
    attr_accessor :allbut

    def initialize(attributes, allbut = false)
      @attributes = attributes
      @allbut = allbut
    end

    def project(tuple)
      split(tuple).first
    end

    def split(tuple)
      projection, rest = {}, tuple.dup
      attributes.each do |a|
        projection[a] = tuple[a]
        rest.delete(a)
      end
      @allbut ? [rest, projection] : [projection, rest]
    end

  end # class ProjectionKey

  #
  # Encapsulates tools for computing orders on tuples
  #
  class OrderingKey

    def initialize(ordering = [])
      @ordering = ordering
      @sorter = nil
    end

    def self.coerce(arg)
      OrderingKey.new(arg)
    end

    def order_by(attr, order = :asc)
      @ordering << [attr, order]
      @sorter = nil
      self
    end

    def compare(t1,t2)
      @ordering.each do |attr,order|
        comp = (t1[attr] <=> t2[attr])
        comp *= -1 if order == :desc
        return comp unless comp == 0
      end
      return 0
    end

    def sorter
      @sorter ||= lambda{|t1,t2| compare(t1, t2)}
    end

  end # class OrderingKey

  ##############################################################################
  #
  # AGGREGATORS
  #
  # Aggregators collect computation on tuples.
  #

  #
  # Base class for implementing operators.
  #
  class Aggregator

    # Aggregate options 
    attr_reader :options

    #
    # Automatically installs factory methods for inherited classes.
    #
    # Example: 
    #   class Sum < Aggregate   # will give a method Aggregator.sum
    #     ...
    #   end
    #   Aggregator.sum(:size)   # factor an Sum aggregator on tuple[:size]
    #   Aggregator.sum{ size }  # idem but works on any tuple expression
    # 
    def self.inherited(clazz)
      # TODO: refactor this to use define_method
      clazz.name.to_s =~ /([A-Za-z0-9_]+)$/
      basename = $1.downcase.to_sym
      instance_eval <<-EOF
        def #{basename}(*args, &block)
          #{clazz}.new(*args, &block)
        end
      EOF
    end

    #
    # Creates an Aggregator instance.
    #
    # This constructor can be used either by passing an attribute
    # argument or a block that will be evaluated on a TupleHandle
    # instance set on each aggregated tuple.
    #
    #   Aggregator.new(:size) # will aggregate on tuple[:size]
    #   Aggregator.new{ size * price } # ... on tuple[:size] * tuple[:price]
    #
    def initialize(attribute = nil, options = {}, &block)
      attribute, options = nil, attribute if attribute.is_a?(Hash)
      @handle = TupleHandle.new
      @options = default_options.merge(options)
      @functor = TupleHandle.compile(attribute || block)
    end

    #
    # Returns the default options to use
    #
    def default_options
      {}
    end

    #
    # Returns the least value, which is the one to use on an empty
    # set.
    #
    # This method is intended to be overriden by subclasses; default 
    # implementation returns nil.
    # 
    def least
      nil
    end

    # 
    # This method is called on each aggregated tuple and must return
    # an updated _memo_ value. It can be seen as the block typically
    # given to Enumerable.inject.
    #
    # The default implementation collects the pre-value on the tuple 
    # and delegates to _happens.
    #
    def happens(memo, tuple)
      _happens(memo, @handle.set(tuple).evaluate(@functor))
    end

    #
    # This method finalizes a computation.
    #
    # Argument _memo_ is either _least_ or the result of aggregating 
    # through _happens_. The default implementation simply returns
    # _memo_. The method is intended to be overriden for complex 
    # aggregations that need statefull information. See Avg for an 
    # example 
    #
    def finalize(memo)
      memo
    end

    #
    # Aggregates over an enumeration of tuples. 
    #
    def aggregate(enum)
      finalize(
        enum.inject(least){|memo,tuple| 
          happens(memo, tuple)
        })
    end

    protected

    #
    # @see happens.
    #
    # This method is intended to be overriden and returns _value_
    # by default, making this aggregator a "Last" one...
    #
    def _happens(memo, value)
      value
    end

    # 
    # Defines a COUNT aggregation operator
    #
    class Count < Aggregator
      def least(); 0; end
      def happens(memo, tuple) memo + 1; end
    end # class Count

    # 
    # Defines a SUM aggregation operator
    #
    class Sum < Aggregator
      def least(); 0; end
      def _happens(memo, val) memo + val; end
    end # class Sum

    # 
    # Defines an AVG aggregation operator
    #
    class Avg < Aggregator
      def least(); [0.0, 0.0]; end
      def _happens(memo, val) [memo.first + val, memo.last + 1]; end
      def finalize(memo) memo.first / memo.last end
    end # class Sum

    # 
    # Defines a MIN aggregation operator
    #
    class Min < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo < val ? memo : val) 
      end
    end # class Min

    # 
    # Defines a MAX aggregation operator
    #
    class Max < Aggregator
      def least(); nil; end
      def _happens(memo, val) 
        memo.nil? ? val : (memo > val ? memo : val) 
      end
    end # class Max

    #
    # Defines a COLLECT aggregation operator
    #
    class Collect < Aggregator
      def least(); []; end
      def _happens(memo, val) 
        memo << val
      end
    end

    # 
    # Defines a CONCAT aggregation operator
    # 
    class Concat < Aggregator
      def least(); ""; end
      def default_options
        {:before => "", :after => "", :between => ""}
      end
      def _happens(memo, val) 
        memo << options[:between].to_s unless memo.empty?
        memo << val.to_s
      end
      def finalize(memo)
        options[:before].to_s + memo + options[:after].to_s
      end
    end

  end # class Aggregator

  ##############################################################################
  #
  # BUFFERS
  #
  # Buffers allow holding tuples in memory or on disk and provided efficient
  # accesses to them.
  #

  #
  # Provides a basis buffer implementation and a factory over
  # the different kinds of buffers available.
  # 
  class Buffer
  end # class Buffer

  # 
  # Keeps tuples ordered on a specific key
  #
  class SortedBuffer < Buffer

    def initialize(ordering_key)
      @ordering_key = ordering_key
      @buffer = []
    end

    def add_all(enum)
      sorter = @ordering_key.sorter
      @buffer = merge_sort(@buffer, enum.to_a.sort(&sorter), sorter)
    end

    def each
      @buffer.each &Proc.new
    end

    private
  
    def merge_sort(s1, s2, sorter)
      (s1 + s2).sort(&sorter)
    end

  end # class SortedBuffer
  
  ##############################################################################
  #
  # READERS
  #
  # Readers are dataflow elements at the input boundary with the outside world.
  # They typically convert IO streams as Enumerable tuple streams. All readers
  # should follow the basis given by TupleReader.
  #
  
  #
  # Marker for chain elements converting input streams to enumerable 
  # of tuples.
  #
  module TupleReader
    include Pipeable, Enumerable

    #
    # Yields the block with each tuple (converted from the
    # input stream) in turn.
    #
    # Default implementation reads lines of the input stream and
    # yields the block with <code>_line2tuple(line)</code> on each
    # of them
    #
    def each
      input.each_line do |line| 
        tuple = _line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end

    protected

    #
    # Converts a line previously read from the input stream
    # to a tuple.
    #
    # This method MUST be implemented by subclasses.
    #
    def _line2tuple(line)
    end
    undef_method :_line2tuple

  end # module TupleReader

  #
  # Implements the TupleReader contract for a stream where each line is 
  # a ruby hash literal, as a tuple physical representation.
  #
  class HashReader
    include TupleReader

    # @see TupleReader#_line2tuple
    def _line2tuple(line)
      begin
        h = Kernel.eval(line)
        raise "hash expected, got #{h}" unless h.is_a?(Hash)
      rescue Exception => ex
        $stderr << "Skipping #{line.strip}: #{ex.message}\n"
        nil
      else
        return h
      end
    end

  end # class HashReader

  ##############################################################################
  #
  # OPERATORS
  #
  # Operators are dataflow elements that transform input tuples. They are all
  # Enumerable of tuples.
  #
  
  #
  # Marker for all operators on relations.
  # 
  module Operator
    include Pipeable, Enumerable, TupleTools

    #
    # Yields each tuple in turn 
    #
    # This method is implemented in a way that ensures that all operators are 
    # thread safe. It is not intended to be overriden, use _each instead.
    # 
    def each
      op = self.dup
      op._prepare
      op._each &Proc.new
    end

    # 
    # Executes this operator as a commandline
    #
    def execute(args)
      set_args(args)
      [ HashReader.new, self, HashWriter.new ].inject($stdin) do |chain,n|
        n.pipe(chain)
      end.execute($stdout)
    end

    #
    # Configures the operator from arguments taken from command line. 
    #
    # This method is intended to be overriden by subclasses and must return the 
    # operator itself.
    #
    def set_args(args)
      self
    end

    protected

    #
    # Prepares the iterator before subsequent call to _each.
    #
    # This method is intended to be overriden by suclasses to install what's 
    # need for successful iteration. The default implementation does nothing.
    #
    def _prepare 
    end

    # 
    # Internal implementation of the iterator.
    #
    # This method must be implemented by subclasses. It is safe to use instance
    # variables (typically initialized in _prepare) here.
    # 
    def _each
    end
    undef_method :_each

  end # module Operator

  #
  # Specialization of Operator for operators that simply convert single tuples 
  # to single tuples.
  #
  module TransformOperator
    include Operator

    protected 

    # @see Operator#_each
    def _each
      each_input_tuple do |tuple|
        yield _tuple2tuple(tuple)
      end
    end

    #
    # Transforms an input tuple to an output tuple
    #
    def _tuple2tuple(tuple)
    end
    undef_method :_tuple2tuple

  end # module TransformOperator

  #
  # Specialization of Operator for implementing operators that rely on a 
  # cesure algorithm.
  #
  module CesureOperator
    include Operator
    
    protected

    # @see Operator#_each
    def _each
      receiver, proj_key, prev_key = Proc.new, cesure_key, nil
      each_input_tuple do |tuple|
        cur_key = proj_key.project(tuple)
        if cur_key != prev_key
          flush_cesure(prev_key, receiver) unless prev_key.nil?
          start_cesure(cur_key, receiver)
          prev_key = cur_key
        end
        accumulate_cesure(tuple, receiver)
      end
      flush_cesure(prev_key, receiver) unless prev_key.nil?
    end

    def cesure_key
    end

    def start_cesure(key, receiver)
    end

    def accumulate_cesure(tuple, receiver)
    end

    def flush_cesure(key, receiver)
    end

  end # module CesureOperator

  #
  # Specialization of Operator for operators that are 
  # shortcuts on longer expressions.
  # 
  module ShortcutOperator
    include Operator, Lispy

    protected 

    def _each
      longexpr.each &Proc.new
    end

  end # module ShortcutOperator

  # 
  # Normalize the input tuple stream by forcing default values
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator rewrites tuples so as to ensure that all specified 
  # attributes ATTR are defined and not nil. Missing or nil attributes
  # are replaced by the associated default value. 
  #
  class Defaults < Factory::TransformOperator(__FILE__, __LINE__)

    # Hash of source -> target attribute renamings
    attr_accessor :defaults

    # Builds a Defaults operator instance
    def initialize
      @defaults = {}
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      args.each_with_index{|a,i| args[i] = a.to_sym if i % 2 == 0}
      @defaults = Hash[*args]
      self
    end

    protected 

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      @defaults.merge tuple_collect(tuple){|k,v| 
        [k, v.nil? ? @defaults[k] : v]
      }
    end

  end # class Defaults

  # 
  # Extend input tuples with attributes whose value is computed
  # with tuple expressions.
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 EXPR1 ATTR2 EXPR2...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command extend input tuples with new attributes names ATTR1 
  # ATTR2, and so on. Values of those attributes are the result of
  # evaluating EXPR1, EXPR2, etc on input tuples.
  #
  class Extend < Factory::TransformOperator(__FILE__, __LINE__)

    # Extensions as a Hash attr => lambda{...}
    attr_accessor :extensions

    # Builds an Extend operator instance
    def initialize
      @extensions = {}
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @extensions = tuple_collect(args.each_slice(2)){|k,v|
        [k.to_sym, TupleHandle.compile(v)]
      }
      self
    end

    protected 

    # @see Operator#_prepare
    def _prepare
      @handle = TupleHandle.new
    end

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple.merge tuple_collect(@extensions){|k,v|
        [k, @handle.set(tuple).evaluate(v)]
      }
    end

  end # class Extend

  # 
  # Project input tuples on some attributes only
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator projects tuples on attributes whose names are specified 
  # as arguments. Note that, so far, this operator does NOT remove 
  # duplicate tuples in the result and is therefore not equivalent to a
  # true relational projection.
  #
  class Project < Factory::TransformOperator(__FILE__, __LINE__)

    # Builds a Project operator instance
    def initialize
      @projection_key = ProjectionKey.new([], false)
      yield self if block_given?
    end

    def attributes=(attrs)
      @projection_key.attributes = attrs
    end

    def allbut=(allbut)
      @projection_key.allbut = allbut
    end

    # Installs the options
    options do |opt|
      opt.on('-a', '--allbut', 'Apply a ALLBUT projection') do
        self.allbut = true
      end
    end

    # @see Operator#set_args
    def set_args(args)
      self.attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      @projection_key.project(tuple)
    end

  end # class Project

  # 
  # Rename some tuple attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} OLD1 NEW1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command renames OLD attributes as NEW as specified by 
  # arguments. Attributes OLD should exist in the source relation 
  # while attributes NEW should not.
  #
  # Example:
  #   {:id => 1} -> alf rename id identifier -> {:identifier => 1}
  #   {:a => 1, :b => 2} -> alf rename a A b B -> {:A => 1, :B => 2}
  #
  class Rename < Factory::TransformOperator(__FILE__, __LINE__)

    # Hash of source -> target attribute renamings
    attr_accessor :renaming

    # Builds a Rename operator instance
    def initialize
      @renaming = {}
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @renaming = Hash[*args.collect{|c| c.to_sym}]
      self
    end

    protected 

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple_collect(tuple){|k,v| [@renaming[k] || k, v]}
    end

  end # class Rename

  # 
  # Restrict input tuples to those for which an expression is true
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} EXPR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This command restricts tuples to those for which EXPR evaluates
  # to true.
  #
  class Restrict < Factory::Operator(__FILE__, __LINE__)

    # Hash of source -> target attribute renamings
    attr_accessor :functor

    # Builds a Rename operator instance
    def initialize
      @functor = TupleHandle.compile("true")
      yield self if block_given?
    end

    def self.functor(arg)
      case arg
        when String
          TupleHandle.compile(arg)
        when NilClass
          TupleHandle.compile("true")
        when Array
          code = arg.empty? ?
            "true" :
            arg.each_slice(2).collect{|pair| "(" + pair.join("==") + ")"}.join(" and ")
          TupleHandle.compile(code)
        when Proc
          arg
      end
    end

    # @see Operator#set_args
    def set_args(args)
      @functor = Restrict.functor(args.size > 1 ? args : args.first)
      self
    end

    protected 

    # @see Operator#_each
    def _each
      handle = TupleHandle.new
      each_input_tuple{|t| yield(t) if handle.set(t).evaluate(@functor) }
    end

  end # class Restrict

  # 
  # Nest some attributes as a new TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator nests attributes ATTR1 to ATTRN as a new, tuple-based
  # attribute whose name is NEWNAME
  #
  class Nest < Factory::TransformOperator(__FILE__, __LINE__)

    # Array of nesting attributes
    attr_accessor :attributes

    # New name for the nested attribute
    attr_accessor :as

    # Builds a Nest operator instance
    def initialize
      @attributes = []
      @as = :nested
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      others = tuple_collect(tuple.keys - @attributes){|k| [k,tuple[k]] }
      others[as] = tuple_collect(attributes){|k| [k, tuple[k]] }
      others
    end

  end # class Nest

  # 
  # Unnest a TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator unnests a tuple-valued attribute ATTR so as to 
  # flatten it pairs with 'upstream' tuple.
  #
  class Unnest < Factory::TransformOperator(__FILE__, __LINE__)

    # Name of the attribute to unnest
    attr_accessor :attribute

    # Builds a Rename operator instance
    def initialize
      @attribute = "nested"
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @attribute = args.last.to_sym
      self
    end

    protected 

    # @see TransformOperator#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple = tuple.dup
      nested = tuple.delete(@attribute) || {}
      tuple.merge(nested)
    end

  end # class Unnest

  # 
  # Group some attributes as a new RELATION-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator groups attributes ATTR1 to ATTRN as a new, relation-values
  # attribute whose name is NEWNAME
  #
  class Group < Factory::Operator(__FILE__, __LINE__)

    # Attributes on which grouping applies
    attr_accessor :projection_key
  
    # Attribute name for grouping tuple 
    attr_accessor :as

    # Creates a Group instance
    def initialize
      @projection_key = ProjectionKey.new([], true)
      yield self if block_given?
    end

    def attributes=(attrs)
      @projection_key.attributes = attrs
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      self.attributes = args.collect{|a| a.to_sym}
      self
    end

    protected

    # See Operator#_prepare
    def _prepare
      @index = Hash.new{|h,k| h[k] = []} 
      each_input_tuple do |tuple|
        key, rest = @projection_key.split(tuple)
        @index[key] << rest
      end
    end

    # See Operator#_each
    def _each
      @index.each_pair do |k,v|
        yield(k.merge(@as => v))
      end
    end

  end # class Group

  # 
  # Ungroup a RELATION-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator ungroup the relation-valued attribute whose
  # name is ATTR
  #
  class Ungroup < Factory::Operator(__FILE__, __LINE__)

    # Relation-value attribute to ungroup
    attr_accessor :attribute
  
    # Creates a Group instance
    def initialize
      @attribute = :grouped
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @attribute = args.pop.to_sym
      self
    end

    protected 

    # See Operator#_each
    def _each
      each_input_tuple do |tuple|
        tuple = tuple.dup
        subrel = tuple.delete(@attribute)
        subrel.each do |subtuple|
          yield(tuple.merge(subtuple))
        end
      end
    end

  end # class Ungroup

  # 
  # Remove tuple duplicates from input tuples
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator remove duplicates from input tuples.
  #
  class NoDuplicates < Factory::Operator(__FILE__, __LINE__)

    # Removes duplicates according to a complete order
    class SortBased
      include Alf::CesureOperator      

      def cesure_key
        @cesure_key ||= ProjectionKey.new([],true)
      end

      def accumulate_cesure(tuple, receiver)
        @tuple = tuple
      end

      def flush_cesure(key, receiver)
        receiver.call(@tuple)
      end

    end # class SortBased

    # Removes duplicates by loading all in memory and filtering 
    # them there 
    class BufferBased
      include Alf::Operator

      def _prepare
        @tuples = input.to_a.uniq
      end

      def _each
        @tuples.each &Proc.new
      end

    end # class BufferBased

    protected 
    
    def _each
      BufferBased.new.pipe(input).each &Proc.new
    end

  end # class NoDuplicates

  # 
  # Summarize tuples by a given subset of attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator summarizes tuples and compute additional aggregations.
  #
  class Summarize < Factory::Operator(__FILE__, __LINE__)

    def initialize
      @by_key = ProjectionKey.new([], false)
    end

    def by=(attrs)
      @by_key.attributes = attrs
    end

    def allbut=(allbut)
      @by_key.allbut = allbut
    end

    # Installs the options
    options do |opt|
      opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
        self.by = args.collect{|a| a.to_sym}
      end
      opt.on('-a', '--allbut', 'Apply a ALLBUT summarize') do
        self.allbut = true
      end
    end

    # @see Operator#set_args
    def set_args(args)
      self
    end

    # Summarizes according to a complete order
    class SortBased
      include Alf::CesureOperator      

      attr_reader :cesure_key
      attr_reader :aggregators     

      def initialize(by_key, aggregators)
        @cesure_key, @aggregators = by_key, aggregators
      end

      protected 

      def start_cesure(key, receiver)
        @aggregations = tuple_collect(@aggregators) do |a,agg|
          [a, agg.least]
        end
      end

      def accumulate_cesure(tuple, receiver)
        @aggregations = tuple_collect(@aggregators) do |a,agg|
          [a, agg.happens(@aggregations[a], tuple)]
        end
      end

      def flush_cesure(key, receiver)
        @aggregations = tuple_collect(@aggregators) do |a,agg|
          [a, agg.finalize(@aggregations[a])]
        end
        receiver.call key.merge(@aggregations)
      end

    end # class SortBased

    protected 
    
    def _each
      SortBased.new.pipe(input).each &Proc.new
    end

  end # class Summarize

  # 
  # Sort input tuples in memory and output them sorted
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ORDER1 ATTR2 ORDER2...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #
  # This operator sorts input tuples on ATTR1 then ATTR2, etc.
  # and outputs them sorted after that.
  #
  class Sort < Factory::Operator(__FILE__, __LINE__)

    def initialize
      @ordering_key = OrderingKey.coerce([])
      yield self if block_given?
    end

    def ordering=(ordering)
      @ordering_key = OrderingKey.coerce(ordering)
    end

    def order_by(attr, order = :asc)
      @ordering_key.order_by(attr, order)
    end

    def set_args(args)
      args.collect{|c| c.to_sym}.
           each_slice(2).
           each do |attr, order|
        order_by(attr, order)
      end
      self
    end

    protected 

    def _prepare
      @buffer = SortedBuffer.new(@ordering_key)
      @buffer.add_all(input)
    end

    def _each
      @buffer.each(&Proc.new)
    end

  end # class Sort

  ##############################################################################
  #
  # WRITERS
  #
  # Writers are dataflow elements at the output boundary with the outside world.
  # They typically convert Enumerable tuple streams as IO output streams. All
  # writers should follow the basis given by TupleWriter.
  #
  
  #
  # Marker for chain elements converting tuple streams
  #
  module TupleWriter
    include Pipeable

    #
    # Executes the writing, outputting the resulting relation. 
    #
    # This method must be implemented by subclasses.
    #
    def execute(output = $stdout)
    end

  end # module TupleWriter

  #
  # Implements the TupleWriter contract through inspect
  #
  class HashWriter 
    include TupleWriter

    # @see TupleWriter#execute
    def execute(output = $stdout)
      each_input_tuple do |tuple|
        output << tuple.inspect << "\n"
      end
    end

  end # class HashWriter

  # 
  # Render input tuples with a given strategy
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # OPTIONS
  # #{summarized_options}
  #
  class Render < Factory::Command(__FILE__, __LINE__)

    options do |opt|
      @output = :ruby
      opt.on("--ruby", "Render as ruby hashes"){ @output = :ruby }
      opt.on("--text", "Render as a text table"){ @output = :text }
      opt.on("--yaml", "Render as yaml"){ @output = :yaml }
      opt.on("--plot", "Render as a plot"){ @output = :plot }
    end

    def output(res)
      case @output
        when :text
          Renderer::Text.render(res.to_a, $stdout)
        when :yaml
          require 'yaml'
          $stdout << res.to_a.to_yaml
        when :plot
          Renderer::Plot.render(res.to_a, $stdout)
        when :ruby
          res.each{|t| $stdout << t.inspect << "\n"}
      end
    end

    def execute(args)
      output HashReader.new.pipe($stdin)
    end

  end # class Render


  ##############################################################################
  #
  # OTHER COMMANDS
  #
  # Below are general purpose commands provided by alf.
  #

  # Install options
  options do |opt|
    opt.on_tail("--help", "Show help") do
      raise Quickl::Help
    end
    opt.on_tail("--version", "Show version") do
      raise Quickl::Exit, "#{program_name} #{Alf::VERSION} (c) 2011, Bernard Lambeau"
    end
  end # Alf's options

  # 
  # Show help about a specific command
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} COMMAND
  #
  class Help < Factory::Command(__FILE__, __LINE__)
    
    # Let NoSuchCommandError be passed to higher stage
    no_react_to Quickl::NoSuchCommand
    
    # Command execution
    def execute(args)
      if args.size != 1
        puts super_command.help
      else
        cmd = has_command!(args.first, super_command)
        puts cmd.help
      end
    end
    
  end # class Help

end # class Alf
require "alf/renderer/text"
require "alf/renderer/plot"
