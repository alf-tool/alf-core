def alf_required(retried)
  ["enumerator", 
   "stringio", 
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

  ############################################################################# PUBLIC API
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

    extend Factory
  end # module Factory
  
  # 
  # Implements a small LISP-like DSL on top of Alf
  #
  module Lispy
    
    [:Defaults,
     :NoDuplicates,
     :Sort,
     :Clip,
     :Project,
     :Extend, 
     :Rename,
     :Restrict,
     :Nest,
     :Unnest,
     :Group,
     :Ungroup,
     :Summarize,
     :Quota ].each do |op_name|
      meth_name = op_name.to_s.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1].to_sym
      define_method(meth_name) do |child, *args|
        pipe(Alf.const_get(op_name).new(*args), child)
      end
    end

    # @see Project
    def allbut(child, attributes)
      pipe(Project.new(attributes, true), child)
    end

    private

    # Coerces _arg_ as something that can be piped, an iterator of tuples
    def to_iterator(arg)
      case arg
        when IO
          Reader::RubyHash.new(arg)
        when Array, Reader, Operator
          arg
        when String, Symbol
          if respond_to?(:environment)
            environment.dataset(arg)
          else
            raise "No environment set"
          end
        else
          raise ArgumentError, "Unable to pipe with #{arg.inspect}"
      end
    end
    
    def pipe(*elements)
      elements = elements.reverse
      elements[1..-1].inject(elements.first) do |chain, elm|
        elm.input = to_iterator(chain)
        elm
      end
    end

    extend Lispy
  end # module Lispy

  #
  # Encapsulates the interface with the outside world, providing base iterators
  # among others.
  # 
  class Environment
    
    #
    # Specialization of Environment to work on files of a given folder
    #
    class Folder < Environment
      
      def initialize(folder)
        @folder = folder
      end
      
      def dataset(name)
        file = Dir[File.join(@folder, "**/#{name}.rb")].first
        if file
          Reader::RubyHash.new(file)
        else
          raise "No such dataset #{name}"
        end
      end
      
    end # class Folder
    
    # Returns the default environment
    def self.default
      Folder.new File.expand_path('../../examples', __FILE__)
    end
    
  end # class Environment

  ############################################################################# TOOLS
  #
  # The following modules and classes provide tools for implementing dataflow
  # elements.
  #

  #
  # Provides a handle, implementing a flyweight design pattern on tuples.
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
      case expr
      when Proc
        expr
      when NilClass
        compile('true')
      when Hash
        if expr.empty?
          compile(nil)
        else
          # TODO: replace inspect by to_ruby
          compile expr.each_pair.collect{|k,v| 
            "(#{k} == #{v.inspect})"
          }.join(" && ")
        end
      when Array
        compile(Hash[*expr])
      when String, Symbol
        eval("lambda{ #{expr} }")
      else
        raise ArgumentError, "Unable to compile #{expr} to a TupleHandle"
      end
    end

    #
    # Evaluates an expression on the current tuple. Expression
    # can be a lambda or a string (immediately compiled in the
    # later case).
    # 
    def evaluate(expr)
      if RUBY_VERSION < "1.9"
        instance_eval(&TupleHandle.compile(expr))
      else
        instance_exec(&TupleHandle.compile(expr))
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
      tuple.keys.each do |k|
        (class << self; self; end).send(:define_method, k) do
          @tuple[k]
        end
      end
    end

  end # class TupleHandle

  #
  # Provides tools for manipulating tuples
  #
  module TupleTools

    #
    # Returns the first non nil values from arguments
    #
    def coalesce(*args)
      args.find{|x| !x.nil?}
    end
    
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

    def self.coerce(arg)
      case arg
        when Array
          ProjectionKey.new(arg, false)
        when OrderingKey
          ProjectionKey.new(arg.attributes, false)
        when ProjectionKey
          arg
        else
          raise ArgumentError, "Unable to coerce #{arg} to a projection key"
      end
    end

    def to_ordering_key
      OrderingKey.new attributes.collect{|arg|
        [arg, :asc]
      }
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

    attr_reader :ordering

    def initialize(ordering = [])
      @ordering = ordering
      @sorter = nil
    end

    def self.coerce(arg)
      case arg
        when Array
          if arg.all?{|a| a.is_a?(Symbol)}
            arg = arg.collect{|a| [a, :asc]}
          end
          OrderingKey.new(arg)
        when ProjectionKey
          arg.to_ordering_key
        when OrderingKey
          arg
        else
          raise ArgumentError, "Unable to coerce #{arg} to an ordering key"
      end
    end

    def attributes
      @ordering.collect{|arg| arg.first}
    end

    def order_by(attr, order = :asc)
      @ordering << [attr, order]
      @sorter = nil
      self
    end

    def order_of(attr)
      @ordering.find{|arg| arg.first == attr}.last
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

    def +(other)
      other = OrderingKey.coerce(other)
      OrderingKey.new(@ordering + other.ordering)
    end

  end # class OrderingKey

  ############################################################################# AGGREGATORS
  #
  # Aggregators collect computation on tuples.
  #

  #
  # Base class for implementing aggregation operators.
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

  ############################################################################# BUFFERS
  #
  # Buffers allow holding tuples in memory or on disk and provided efficient
  # accesses to them.
  #

  #
  # Base class for implementing buffers.
  # 
  class Buffer

    # 
    # Keeps tuples ordered on a specific key
    #
    class Sorted < Buffer
  
      def initialize(ordering_key)
        @ordering_key = ordering_key
        @buffer = []
      end
  
      def add_all(enum)
        sorter = @ordering_key.sorter
        @buffer = merge_sort(@buffer, enum.to_a.sort(&sorter), sorter)
      end
  
      def each
        @buffer.each(&Proc.new)
      end
  
      private
    
      def merge_sort(s1, s2, sorter)
        (s1 + s2).sort(&sorter)
      end
  
    end # class Buffer::Sorted
    
  end # class Buffer

  ############################################################################# READERS
  #
  # Readers are dataflow elements at the input boundary with the outside world.
  # They typically convert IO streams as Enumerable tuple streams. All readers
  # should follow the basis given by Reader.
  #
  
  #
  # Base class for implementing tuple readers.
  #
  # The contrat of a Reader is simply to be an Enumerable of tuple. Unlike 
  # operators, however, readers are not expected to take tuple enumerators
  # as input but IO objects, database tables, or something similar instead.
  # This base class provides a default behavior for readers that works with 
  # IO objects. It can be safely extended, overriden, or mimiced.
  #
  class Reader
    include Enumerable
    
    # Input IO, or file name
    attr_accessor :input

    #
    # Creates a reader instance, with an optional input
    #
    def initialize(input = nil)
      @input = input
    end

    #
    # Yields the block with each tuple (converted from the input stream) in 
    # turn.
    #
    # The default implementation reads lines of the input stream and yields the 
    # block with <code>_line2tuple(line)</code> on each of them. This method
    # may be overriden if this behavior does not fit reader's needs.
    #
    def each
      each_input_line do |line| 
        tuple = _line2tuple(line)
        yield tuple unless tuple.nil?
      end
    end

    protected
    
    def each_input_line
      case input
      when String
        File.open(input, 'r') do |io|
          io.each_line &Proc.new
        end
      when IO, StringIO
        input.each_line &Proc.new
      else 
        raise "Unable to convert #{input} to an IO object"
      end
    end

    #
    # Converts a line previously read from the input stream to a tuple. 
    #
    # The line is simply ignored is this method return nil. Errors should be
    # properly handled by raising exceptions. This method MUST be implemented 
    # by subclasses unless each is overriden.
    #
    def _line2tuple(line)
    end

    #
    # Implements the Reader contract for a stream where each line is a ruby 
    # hash literal (taken as a tuple physical representation).
    #
    class RubyHash < Reader
  
      # @see Reader#_line2tuple
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
  
    end # class RubyHash

  end # module Reader

  ############################################################################# RENDERERS
  #
  # Renderers are dataflow elements at the output boundary with the outside 
  # world. They typically output Enumerable tuple streams on IO streams. 
  # All renderers should follow the basis given by Renderer.
  #
  
  #
  # Base class for implementing renderers.
  #
  # A renderer takes a tuple iterator as input and renders it on an output
  # stream. Unlike operators, renderers are not tuple enumerators anymore
  # and are typically used as chain end elements. 
  #
  class Renderer

    # Writer input
    attr_accessor :input
    
    def initialize(input = nil)
      @input = input
    end
    
    #
    # Executes the rendering, outputting the resulting tuples. 
    #
    # This method must be implemented by subclasses.
    #
    def execute(output = $stdout)
    end

    #
    # Implements the Renderer contract through inspect
    #
    class RubyHash < Renderer
  
      # @see Renderer#execute
      def execute(output = $stdout)
        input.each do |tuple|
          output << tuple.inspect << "\n"
        end
      end
  
    end # class RubyHash

  end # module Renderer

  ############################################################################# OPERATORS
  #
  # Operators are dataflow elements that transform input tuples. They are all
  # Enumerable of tuples.
  #
  
  #
  # Marker for all operators on relations.
  # 
  module Operator
    include Enumerable, TupleTools

    # Operator input
    attr_accessor :input
    
    #
    # Yields each tuple in turn 
    #
    # This method is implemented in a way that ensures that all operators are 
    # thread safe. It is not intended to be overriden, use _each instead.
    # 
    def each
      op = self.dup
      op._prepare
      op._each(&Proc.new)
    end

    # 
    # Executes this operator as a commandline
    #
    def execute(args)
      set_args(args)
      if r = requester
        # TODO: remove r.input.first hardcoding here
        chain = [
          Renderer::RubyHash.new,
          self,
          r.input.first,
        ]
        r.send(:pipe, *chain).execute($stdout)
      else
        self
      end
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

    # Internal implementation of the iterator.
    #
    # This method must be implemented by subclasses. It is safe to use instance
    # variables (typically initialized in _prepare) here.
    # 
    def _each
    end

    # 
    #
    # Yields the block with each input tuple.
    #
    # This method should be preferred to <code>input.each</code> when possible.
    #
    def each_input_tuple
      input.each(&Proc.new)
    end

    #
    # Specialization of Operator for operators that simply convert single tuples 
    # to single tuples.
    #
    module Transform
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
  
    end # module Transform

    #
    # Specialization of Operator for implementing operators that rely on a 
    # cesure algorithm.
    #
    module Cesure
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

    end # module Cesure

    #
    # Specialization of Operator for operators that are 
    # shortcuts on longer expressions.
    # 
    module Shortcut
      include Operator, Lispy

      protected 

      def _each
        longexpr.each(&Proc.new)
      end

    end # module Shortcut

  end # module Operator

  #################################################### non relational operators
  
  # 
  # Normalize input tuples by forcing default values on missing 
  # attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Non strict mode
  #   (defaults enum, :x => 1, :y => 'hello')
  #
  #   # Strict mode (--strict)
  #   (defaults enum, {:x => 1, :y => 'hello'}, true)
  #
  # DESCRIPTION
  #
  # This operator rewrites tuples so as to ensure that all values for specified 
  # attributes ATTRx are defined and not nil. Missing or nil attributes are 
  # replaced by the associated default value VALx.
  #
  # When used in shell, the hash of default values is built from commandline
  # arguments ala Hash[...]. However, to keep type safety VALx are interpreted
  # as ruby literals and built with Kernel.eval. This means that strings must 
  # be doubly quoted. For the example of the API section:
  #
  #   alf defaults x 1 y "'hello'"
  #
  # When used in --strict mode, the operator simply project resulting tuples on
  # attributes for which a default value has been specified. Using the strict 
  # mode guarantess that the heading of all tuples is the same, and that no nil
  # value ever remains. However, this operator never remove duplicates. 
  #
  class Defaults < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Default values as a ATTR -> VAL hash 
    attr_accessor :defaults
    
    # Strict mode?
    attr_accessor :strict
    
    # Builds a Defaults operator instance
    def initialize(defaults = {}, strict = false)
      @defaults = defaults
      @strict = strict
    end
    
    options do |opt|
      opt.on('-s', '--strict', 'Strictly restrict to default attributes'){ 
        self.strict = true 
      }
    end

    # @see Operator#set_args
    def set_args(args)
      @defaults = tuple_collect(args.each_slice(2)) do |k,v|
        [k.to_sym, Kernel.eval(v)]
      end
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      if strict
        tuple_collect(@defaults){|k,v| 
          [k, coalesce(tuple[v], v)] 
        }
      else
        @defaults.merge tuple_collect(tuple){|k,v| 
          [k, coalesce(v, @defaults[k])]
        }
      end
    end

  end # class Defaults

  # 
  # 
  # Remove tuple duplicates from input tuples
  #
  # SYNOPSIS
  #   #{program_name} #{command_name}
  #
  # API & EXAMPLE
  #
  #   (no_duplicates enum)
  #
  # DESCRIPTION
  #
  # This operator remove duplicates from input tuples. As defaults, it is a non
  # relational operator that helps normalizing input for implementing relational
  # operators. This one is centric in converting bags of tuples to sets of 
  # tuples, as required by true relations.
  #
  class NoDuplicates < Factory::Operator(__FILE__, __LINE__)

    # Removes duplicates according to a complete order
    class SortBased
      include Alf::Operator::Cesure      

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
        @tuples.each(&Proc.new)
      end

    end # class BufferBased

    protected 
    
    def _each
      op = BufferBased.new
      op.input = input
      op.each(&Proc.new)
    end

  end # class NoDuplicates

  # 
  # Sort input tuples according to a sort key
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ORDER1 ATTR2 ORDER2...
  #
  # API & EXAMPLE
  #
  #   # sort on supplier name in ascending order
  #   (sort [:name])
  #
  #   # sort on city then on name
  #   (sort [:city, :name])
  # 
  #   # sort on city DESC then on name ASC
  #   (sort [[:city, :desc], [:name, :asc]])
  #
  #   => See OrderingKey about specifying orderings
  #
  # DESCRIPTION
  #
  # This operator sorts input tuples on ATTR1 then ATTR2, etc. and outputs 
  # them sorted after that. This is, of course, a non relational operator as 
  # relations are unordered sets. It is provided to implement operators that
  # need tuples to be sorted to work correctly. When used in shell, the key 
  # ordering must be specified in its longest form:
  #
  #   alf sort name asc
  #   alf sort city desc name asc
  #
  # LIMITATIONS
  #
  # The fact that the ordering must be completely specified with commandline
  # arguments is a limitation, shortcuts could be provided in the future.
  #
  class Sort < Factory::Operator(__FILE__, __LINE__)
  
    def initialize(ordering_key = [])
      @ordering_key = OrderingKey.coerce(ordering_key)
      yield self if block_given?
    end
  
    def ordering=(ordering)
      @ordering_key = OrderingKey.coerce(ordering)
    end
  
    def set_args(args)
      self.ordering = args.collect{|c| c.to_sym}.each_slice(2).to_a
      self
    end
  
    protected 
  
    def _prepare
      @buffer = Buffer::Sorted.new(@ordering_key)
      @buffer.add_all(input)
    end
  
    def _each
      @buffer.each(&Proc.new)
    end
  
  end # class Sort

  # 
  # Clip input tuples to some attributes only
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Keep only name and city attributes
  #   (clip enum, [:name, :city])
  #
  #   # Keep all but name and city attributes
  #   (clip enum, [:name, :city], true)
  #
  # DESCRIPTION
  #
  # This operator clips tuples on attributes whose names are specified as 
  # arguments. This is similar to the relational PROJECT operator, expect
  # that this one does not removed duplicates that can occur from clipping.
  # In other words, clipping may lead to bags of tuples instead of sets.
  # 
  # When used in shell, the clipping/projection key is simply taken from
  # commandline arguments:
  #
  #   alf clip name city
  #   alf clip --allbut name city
  #
  class Clip < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Builds a Clip operator instance
    def initialize(attributes = [], allbut = false)
      @projection_key = ProjectionKey.new(attributes, allbut)
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
      opt.on('-a', '--allbut', 'Apply a ALLBUT clipping') do
        self.allbut = true
      end
    end

    # @see Operator#set_args
    def set_args(args)
      self.attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      @projection_key.project(tuple)
    end

  end # class Clip

  ################################################################## relational

  # 
  # Relational projection
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   # Project on name and city attributes
  #   (project enum, [:name, :city])
  #
  #   # Project on all but name and city attributes
  #   (allbut enum, [:name, :city])
  #
  # DESCRIPTION
  #
  # This operator projects tuples on attributes whose names are specified as 
  # arguments. This is similar to clip, except that this ones is a truly 
  # relational one, that is, it also removes duplicates tuples. 
  # 
  # When used in shell, the clipping/projection key is simply taken from
  # commandline arguments:
  #
  #   alf project name city
  #   alf project --allbut name city
  #
  class Project < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut
  
    # Builds a Project operator instance
    def initialize(attributes = [], allbut = false)
      @projection_key = ProjectionKey.new(attributes, allbut)
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
  
    # @see Operator::Shortcut#longexpr
    def longexpr
      pipe NoDuplicates.new,
           Clip.new(@projection_key.attributes, @projection_key.allbut),
           input
    end
  
  end # class Project
  
  # Extend input tuples with attributes whose value is computed
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 EXPR1 ATTR2 EXPR2...
  #
  # API & EXAMPLE
  #
  #   (extend enum, :total => lambda{ qty * price },
  #                 :big   => lambda{ qty > 100 ? true : false }) 
  #
  # DESCRIPTION
  #
  # This command extend input tuples with new attributes (named ATTR1, ...)  
  # whose value is the result of evaluating tuple expressions (i.e. EXPR1, ...).
  # See main documentation about the semantics of tuple expressions. When used
  # in shell, the hash of extensions is built from commandline arguments ala
  # Hash[...]. Tuple expressions must be specified as code literals there:
  #
  #   alf extend total "qty * price" big "qty > 100 ? true : false"
  #
  # Attributes ATTRx should not already exist, no behavior is guaranteed if 
  # this precondition is not respected.   
  #
  class Extend < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Extensions as a Hash attr => lambda{...}
    attr_accessor :extensions

    # Builds an Extend operator instance
    def initialize(extensions = {})
      @extensions = extensions
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

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple.merge tuple_collect(@extensions){|k,v|
        [k, @handle.set(tuple).evaluate(v)]
      }
    end

  end # class Extend

  # 
  # Rename attributes
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} OLD1 NEW1 ...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (rename enum, :name => :supplier_name, :city => supplied_city)
  #
  # DESCRIPTION
  #
  # This command renames OLD attributes as NEW as specified by arguments. 
  # Attributes OLD should exist in source tuples while attributes NEW should 
  # not. When used in shell, renaming attributes are built ala Hash[...] from
  # commandline arguments: 
  #
  #   alf rename name supplier_name city supplier_city
  #
  class Rename < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Hash of source -> target attribute renamings
    attr_accessor :renaming

    # Builds a Rename operator instance
    def initialize(renaming = {})
      @renaming = renaming
    end

    # @see Operator#set_args
    def set_args(args)
      @renaming = Hash[*args.collect{|c| c.to_sym}]
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
    def _tuple2tuple(tuple)
      tuple_collect(tuple){|k,v| [@renaming[k] || k, v]}
    end

  end # class Rename

  # 
  # Restrict input tuples to those to which a predicate evaluates to true
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} EXPR
  #   #{program_name} #{command_name} ATTR1 VAL1 ...
  #
  # API & EXAMPLE
  #
  #   # Restrict to suppliers with status greater than 20
  #   (restrict enum, lambda{ status > 20 })
  #
  #   # Restrict to suppliers that live in London
  #   (restrict enum, lambda{ city == 'London' })
  #
  # DESCRIPTION
  #
  # This command restricts tuples to those for which EXPR evaluates to true.
  # EXPR must be a valid tuple expression that should return a truth-value.
  # When used in shell, the predicate is taken as a string and compiled with
  # TupleHandle.compile. We also provide a shortcut for equality expressions. 
  # Note that, in that case, values are expected to be ruby code literals,
  # evaluated with Kernel.eval. Therefore, strings must be doubly quoted.  
  #
  #   alf restrict "status > 20"
  #   alf restrict city "'London'"
  #
  class Restrict < Factory::Operator(__FILE__, __LINE__)

    # Restriction predicate
    attr_accessor :predicate

    # Builds a Restrict operator instance
    def initialize(predicate = "true")
      @predicate = TupleHandle.compile(predicate)
      yield self if block_given?
    end

    # @see Operator#set_args
    def set_args(args)
      @predicate = if args.size > 1
        TupleHandle.compile  tuple_collect(args.each_slice(2)){|a,expr|
          [a, Kernel.eval(expr)]
        }
      else
        TupleHandle.compile(args.first)
      end
      self
    end

    protected 

    # @see Operator#_each
    def _each
      handle = TupleHandle.new
      each_input_tuple{|t| yield(t) if handle.set(t).evaluate(@predicate) }
    end

  end # class Restrict

  # 
  # Nest some attributes as a new TUPLE-valued attribute
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} ATTR1 ATTR2 ... NEWNAME
  #
  # API & EXAMPLE
  #
  #   (nest enum, [:city, :status], :loc_and_status)
  #
  # DESCRIPTION
  #
  # This operator nests attributes ATTR1 to ATTRN as a new, tuple-based
  # attribute whose name is NEWNAME. When used in shell, names of nested 
  # attributes are taken from commandline arguments, expected the last one
  # which defines the new name to use:
  #
  #   alf nest city status loc_and_status
  #
  class Nest < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Array of nesting attributes
    attr_accessor :attributes

    # New name for the nested attribute
    attr_accessor :as

    # Builds a Nest operator instance
    def initialize(attributes = [], as = :nested)
      @attributes = attributes
      @as = as
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
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
  # API & EXAMPLE
  #
  #   # On result of (nest enum, [:city, :status], :loc_and_status) 
  #   (unnest enum, :loc_and_status)
  #
  # DESCRIPTION
  #
  # This operator unnests the tuple-valued attribute named ATTR so as to 
  # flatten its pairs with 'upstream' tuple. The latter should be such so that
  # no name collision occurs. When used in shell, the name of the attribute to
  # unnest is taken as the first commandline argument:
  #
  #   alf unnest loc_and_status
  #
  class Unnest < Factory::Operator(__FILE__, __LINE__)
    include Operator::Transform

    # Name of the attribute to unnest
    attr_accessor :attribute

    # Builds a Rename operator instance
    def initialize(attribute = :nested)
      @attribute = attribute
    end

    # @see Operator#set_args
    def set_args(args)
      @attribute = args.first.to_sym
      self
    end

    protected 

    # @see Operator::Transform#_tuple2tuple
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
  # API & EXAMPLE
  #
  #   # Assuming supplies as input
  #   (group enum, [:part_id, :quantity], :supplying)
  #
  # DESCRIPTION
  #
  # This operator groups attributes ATTR1 to ATTRN as a new, relation-valued
  # attribute whose name is NEWNAME. When used in shell, names of grouped
  # attributes are taken from commandline arguments, expected the last one
  # which defines the new name to use:
  #
  #   alf group part_id quantity supplying
  #
  class Group < Factory::Operator(__FILE__, __LINE__)

    # Attributes on which grouping applies
    attr_accessor :attributes
  
    # Attribute name for grouping tuple 
    attr_accessor :as

    # Creates a Group instance
    def initialize(attributes = [], as = :group)
      @attributes = attributes
      @as = as
    end

    # @see Operator#set_args
    def set_args(args)
      @as = args.pop.to_sym
      @attributes = args.collect{|a| a.to_sym}
      self
    end

    protected

    # See Operator#_prepare
    def _prepare
      pkey = ProjectionKey.new(attributes, as)
      @index = Hash.new{|h,k| h[k] = []} 
      each_input_tuple do |tuple|
        key, rest = pkey.split(tuple)
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
  # API & EXAMPLE
  #
  #   # On result of (group enum, [:part_id, :quantity], :supplying)
  #   (ungroup enum, :supplying)
  #
  # DESCRIPTION
  #
  # This operator ungroups the relation-valued attribute named ATTR and outputs
  # tuples as the flattening of each of of its tuples merged with the upstream
  # one. Sub relation should be such so that no name collision occurs. When 
  # used in shell, the name of the attribute to ungroup is taken as the first 
  # commandline argument:
  #
  #   alf ungroup supplying
  #
  class Ungroup < Factory::Operator(__FILE__, __LINE__)

    # Relation-value attribute to ungroup
    attr_accessor :attribute
  
    # Creates a Group instance
    def initialize(attribute = :grouped)
      @attribute = attribute
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
  # Summarize tuples by a key and compute aggregations
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} --by=KEY1,KEY2... AGG1 EXPR1...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (summarize enum, [:supplier_id],
  #                    :total_qty => Aggregator.sum(:quantity))
  #
  # DESCRIPTION
  #
  # This operator summarizes input tuples on the projection on KEY1,KEY2,...
  # attributes and applies aggregate operators on sets of matching tuples.
  # Introduced names AGG should be disjoint from KEY attributes.
  #
  # When used in shell, the aggregations are taken from commandline arguments
  # AGG and EXPR, where AGG is the name of a new attribute and EXPR is an
  # aggregation expression evaluated on Aggregator:
  #
  #   alf summarize --by=supplier_id total_qty "sum(:quantity)" 
  #
  class Summarize < Factory::Operator(__FILE__, __LINE__)
    include Operator::Shortcut
    
    # By attributes
    attr_accessor :by
    
    # Aggregations as a AGG => Aggregator(EXPR) hash 
    attr_accessor :aggregators

    def initialize(by = [], aggregators = {})
      @by = by
      @aggregators = aggregators
    end

    # Installs the options
    options do |opt|
      opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
        @by = args.collect{|a| a.to_sym}
      end
    end

    # @see Operator#set_args
    def set_args(args)
      @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
        [a.to_sym, Aggregator.instance_eval(expr)]
      end
      self
    end

    # Summarizes according to a complete order
    class SortBased
      include Alf::Operator::Cesure      

      attr_reader :cesure_key
      attr_reader :aggregators     

      def initialize(by_key, aggregators)
        @cesure_key, @aggregators = by_key, aggregators
      end

      protected 

      def start_cesure(key, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.least]
        end
      end

      def accumulate_cesure(tuple, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.happens(@aggs[a], tuple)]
        end
      end

      def flush_cesure(key, receiver)
        @aggs = tuple_collect(@aggregators) do |a,agg|
          [a, agg.finalize(@aggs[a])]
        end
        receiver.call key.merge(@aggs)
      end

    end # class SortBased

    protected 
    
    def longexpr
      by_key = ProjectionKey.new(@by, false)
      pipe SortBased.new(by_key, @aggregators),
           Sort.new(by_key.to_ordering_key),
           input
    end

  end # class Summarize

  # 
  # Compute quota values on input tuples
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} --by=KEY1,... --order=OR1... AGG1 EXPR1...
  #
  # OPTIONS
  # #{summarized_options}
  #
  # API & EXAMPLE
  #
  #   (quota enum, [:supplier_id], [:quantity],
  #                :position => Aggregator.count,
  #                :sum_qty  => Aggregator.sum(:quantity))
  #
  # DESCRIPTION
  #
  # This operator computes quota values on input tuples.
  #
  #   alf quota --by=supplier_id --order=quantity position count sum_qty "sum(:qty)"
  #
  class Quota < Factory::Operator(__FILE__, __LINE__)
    include Operator::Cesure

    # Quota by
    attr_accessor :by

    # Quota order
    attr_accessor :order
    
    # Quota aggregations
    attr_accessor :aggregators

    def initialize(by = [], order = [], aggregators = {})
      @by, @order, @aggregators  = by, order, aggregators
    end

    options do |opt|
      opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
        @by = args.collect{|a| a.to_sym}
      end
      opt.on('--order=x,y,z', 'Specify order attributes', Array) do |args|
        @order = args.collect{|a| a.to_sym}
      end
    end

    # @see Operator#set_args
    def set_args(args)
      @aggregators = tuple_collect(args.each_slice(2)) do |a,expr|
        [a.to_sym, Aggregator.instance_eval(expr)]
      end
      self
    end

    # TODO: remove this (find another way)!!
    def input=(i)
      sort = Sort.new(cesure_key.to_ordering_key + ordering_key)
      sort.input = i
      super(sort)
    end

    protected 
    
    def cesure_key
      ProjectionKey.coerce @by
    end
    
    def ordering_key
      OrderingKey.coerce @order
    end

    def start_cesure(key, receiver)
      @aggs = tuple_collect(@aggregators) do |a,agg|
        [a, agg.least]
      end
    end

    def accumulate_cesure(tuple, receiver)
      @aggs = tuple_collect(@aggregators) do |a,agg|
        [a, agg.happens(@aggs[a], tuple)]
      end
      thisone = tuple_collect(@aggregators) do |a,agg|
        [a, agg.finalize(@aggs[a])]
      end
      receiver.call tuple.merge(thisone)
    end

  end # class Quota
  
  ############################################################################# OTHER COMMANDS
  #
  # Below are general purpose commands provided by alf.
  #

  # 
  # Show input tuples in a friendly text rendering
  #
  # SYNOPSIS
  #   #{program_name} #{command_name} [DATASET...]
  #
  # DESCRIPTION
  #
  # When dataset names are specified as commandline args, request the environment 
  # to provide those datasets and print them. Otherwise, take what alf main command 
  # would provide from its --input option (defaults to stdin).
  #
  # Note that this command is not an operator and should not be piped anymore.
  #
  class Show < Factory::Command(__FILE__, __LINE__)
  
    def execute(args)
      args = if args.empty?
        requester.input
      else
        args
      end
      args.each do |input|
        chain = [
          Renderer::Text.new,
          input
        ]
        requester.send(:pipe, *chain).execute($stdout)
      end
    end
  
  end # class Show

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

  ############################################################################# MAIN
  #
  # Below is alf main command
  #
  include Lispy

  # Environment instance to use to get base iterators
  attr_reader :environment
  
  # Input dataset names
  attr_reader :input
  
  # Creates a command instance
  def initialize(env = Environment.default)
    @environment = env
  end
  
  # Install options
  options do |opt|
    @input = [ $stdin ]
    opt.on('--input=x,y,z', 
           'Specify input dataset names (defaults to stdin)', Array) do |input|
      @input = input
    end
    opt.on_tail("--help", "Show help") do
      raise Quickl::Help
    end
    opt.on_tail("--version", "Show version") do
      raise Quickl::Exit, "#{program_name} #{Alf::VERSION}"\
                          " (c) 2011, Bernard Lambeau"
    end
  end # Alf's options

end # class Alf
require "alf/renderer/text"
require "alf/renderer/plot"
