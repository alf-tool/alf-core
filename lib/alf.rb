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
#    require 'alf/operator/relational/project'
#    require 'alf/operator/relational/extend'
#    require 'alf/operator/relational/rename'
#    require 'alf/operator/relational/restrict'
#    require 'alf/operator/relational/join'
#    require 'alf/operator/relational/intersect'
#    require 'alf/operator/relational/minus'
#    require 'alf/operator/relational/union'
#    require 'alf/operator/relational/matching'
#    require 'alf/operator/relational/not_matching'
#    require 'alf/operator/relational/wrap'
#    require 'alf/operator/relational/unwrap'
#    require 'alf/operator/relational/group'
#    require 'alf/operator/relational/ungroup'
#    require 'alf/operator/relational/summarize'
#    require 'alf/operator/relational/rank'
#    require 'alf/operator/relational/quota'

    # 
    # Yields the block with each operator module in turn
    #
    def self.each
      constants.each do |c|
        val = const_get(c)
        yield(val) if val.ancestors.include?(Operator::Relational)
      end
    end
    
    # Relational projection (clip + compact)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Project on name and city attributes
    #   (project :suppliers, [:name, :city])
    #
    #   # Project on all but name and city attributes
    #   (allbut :suppliers, [:name, :city])
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
    #   alf project suppliers -- name city
    #   alf project --allbut suppliers -- name city
    #
    class Project < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
    
      signature [
        [:projection_key, ProjectionKey, []]
      ]
      
      # Builds a Project operator instance
      def initialize(attributes = [], allbut = false)
        @projection_key = coerce(attributes, ProjectionKey)
        @allbut = allbut
      end
    
      # Installs the options
      options do |opt|
        opt.on('-a', '--allbut', 'Apply a ALLBUT projection') do
          @allbut = true
        end
      end
    
      protected 
    
      # (see Operator::Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              Operator::NonRelational::Clip.new(@projection_key, @allbut),
              datasets
      end
    
    end # class Project
    
    #
    # Relational extension (additional, computed attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 EXPR1 ATTR2 EXPR2...
    #
    # API & EXAMPLE
    #
    #   (extend :supplies, :sp  => lambda{ sid + "/" + pid },
    #                      :big => lambda{ qty > 100 ? true : false }) 
    #
    # DESCRIPTION
    #
    # This command extend input tuples with new attributes (named ATTR1, ...)  
    # whose value is the result of evaluating tuple expressions (i.e. EXPR1, ...).
    # See main documentation about the semantics of tuple expressions. When used
    # in shell, the hash of extensions is built from commandline arguments ala
    # Hash[...]. Tuple expressions must be specified as code literals there:
    #
    #   alf extend supplies -- sp 'sid + "/" + pid' big "qty > 100 ? true : false"
    #
    # Attributes ATTRx should not already exist, no behavior is guaranteed if 
    # this precondition is not respected.   
    #
    class Extend < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature [
        [:extensions, TupleComputation, {}]
      ]
      
      protected 
    
      # (see Operator#_prepare)
      def _prepare
        @handle = TupleHandle.new
      end
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple.merge @extensions.evaluate(@handle.set(tuple))
      end
  
    end # class Extend
  
    # 
    # Relational renaming (rename some attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- OLD1 NEW1 ...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   (rename :suppliers, :name => :supplier_name, :city => :supplier_city)
    #
    # DESCRIPTION
    #
    # This command renames OLD attributes as NEW as specified by arguments. 
    # Attributes OLD should exist in source tuples while attributes NEW should 
    # not. When used in shell, renaming attributes are built ala Hash[...] from
    # commandline arguments: 
    #
    #   alf rename suppliers -- name supplier_name city supplier_city
    #
    class Rename < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature [
        [:renaming, Renaming, {}]
      ]
      
      protected 
    
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @renaming.apply(tuple)
      end
  
    end # class Rename
  
    # 
    # Relational restriction (aka where, predicate filtering)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- EXPR
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 VAL1 ...
    #
    # API & EXAMPLE
    #
    #   # Restrict to suppliers with status greater than 20
    #   (restrict :suppliers, lambda{ status > 20 })
    #
    #   # Restrict to suppliers that live in London
    #   (restrict :suppliers, lambda{ city == 'London' })
    #
    # DESCRIPTION
    #
    # This command restricts tuples to those for which EXPR evaluates to true.
    # EXPR must be a valid tuple expression that should return a truth-value.
    # When used in shell, the predicate is taken as a string and coerced to a
    # TupleExpression. We also provide a shortcut for equality expressions. 
    # Note that, in that case, values are expected to be ruby code literals,
    # evaluated with Kernel.eval. Therefore, strings must be doubly quoted.  
    #
    #   alf restrict suppliers -- "status > 20"
    #   alf restrict suppliers -- city "'London'"
    #
    class Restrict < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature [
        [:predicate, Restriction, "true"]
      ]
      
      protected 
    
      # (see Operator#_each)
      def _each
        handle = TupleHandle.new
        each_input_tuple{|t| yield(t) if @predicate.evaluate(handle.set(t)) }
      end
  
    end # class Restrict
  
    # 
    # Relational join (and cross-join)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (join :suppliers, :parts)
    #
    # DESCRIPTION
    #
    # This operator computes the (natural) join of two input iterators. Natural
    # join means that, unlike what is commonly used in SQL, the default behavior 
    # is to join on common attributes. You can use the rename operator if this
    # behavior does not fit your needs.
    #
    #   alf join suppliers supplies 
    #  
    class Join < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      #
      # Performs a Join of two relations through a Hash buffer on the right
      # one.
      #
      class HashBased
        include Operator, Operator::Binary
      
        #
        # Implements a special Buffer for join-based relational operators.
        #
        # Example:
        #
        #   buffer = Buffer::Join.new(...) # pass the right part of the join
        #   left.each do |left_tuple|
        #     key, rest = buffer.split(tuple)
        #     buffer.each(key) do |right_tuple|
        #       #
        #       # do whatever you want with left and right tuples
        #       #
        #     end
        #   end 
        #
        class JoinBuffer
          include Tools
          
          #
          # Creates a buffer instance with the right part of the join.
          #
          # @param [Iterator] enum a tuple iterator, right part of the join. 
          #
          def initialize(enum)
            @buffer = nil
            @key = nil
            @enum = enum
          end
          
          #
          # Splits a left tuple according to the common key.
          #
          # @param [Hash] tuple a left tuple of the join
          # @return [Array] an array of two elements, the key and the rest
          # @see ProjectionKey#split
          #
          def split(tuple)
            _init(tuple) unless @key
            @key.split(tuple)
          end
          
          #
          # Yields each right tuple that matches a given key value.
          #
          # @param [Hash] key a tuple that matches elements of the common key
          #        (typically the first element returned by #split) 
          #
          def each(key)
            @buffer[key].each(&Proc.new) if @buffer.has_key?(key)
          end
          
          private
          
          # Initialize the buffer with a right tuple
          def _init(right)
            @buffer = Hash.new{|h,k| h[k] = []}
            @enum.each do |left|
              @key ||= coerce(left.keys & right.keys, ProjectionKey)
              @buffer[@key.project(left)] << left
            end
            @key ||= coerce([], ProjectionKey)
          end
          
        end # class JoinBuffer
        
        protected
        
        # (see Operator#_each)
        def _each
          buffer = JoinBuffer.new(right)
          left.each do |left_tuple|
            key, rest = buffer.split(left_tuple)
            buffer.each(key) do |right|
              yield(left_tuple.merge(right))
            end
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Join
    
    # 
    # Relational intersection (aka a logical and)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give suppliers that live in Paris and have status >= 20
    #   (intersect \\
    #     (restrict :suppliers, lambda{ status >= 20 }),
    #     (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the intersection between its two operands. The 
    # intersection is simply the set of common tuples between them. Both operands
    # must have the same heading. 
    #
    #   alf intersect ... ...
    #  
    class Intersect < Alf::Operator(__FILE__, __LINE__)
      include Operator, Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      class HashBased
        include Operator, Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) if @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Intersect
  
    # 
    # Relational minus (aka difference)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   # Give all suppliers but those living in Paris
    #   (minus :suppliers, 
    #          (restrict :suppliers, lambda{ city == 'Paris' }))
    #
    # DESCRIPTION
    #
    # This operator computes the difference between its two operands. The 
    # difference is simply the set of tuples in left operands non shared by
    # the right one.
    #
    #   alf minus ... ...
    #  
    class Minus < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      class HashBased
        include Operator, Operator::Binary
      
        protected
        
        def _prepare
          @index = Hash.new
          right.each{|t| @index[t] = true}
        end
        
        def _each
          left.each do |left_tuple|
            yield(left_tuple) unless @index.has_key?(left_tuple)
          end
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Minus
  
    # 
    # Relational union
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (union (project :suppliers, [:city]), 
    #          (project :parts,     [:city]))
    #
    # DESCRIPTION
    #
    # This operator computes the union join of two input iterators. Input 
    # iterators should have the same heading. The result never contain duplicates.
    #
    #   alf union ... ...
    #  
    class Union < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      class DisjointBased
        include Operator, Operator::Binary
      
        protected
        
        def _each
          left.each(&Proc.new)
          right.each(&Proc.new)
        end
        
      end
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain Operator::NonRelational::Compact.new,
              DisjointBased.new,
              datasets 
      end
      
    end # class Union

    # 
    # Relational matching
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (matching :suppliers, :supplies)
    #
    # DESCRIPTION
    #
    # This operator restricts left tuples to those for which there exists at 
    # least one right tuple that joins. This is a shortcut operator for the
    # longer expression:
    #
    #   (project (join xxx, yyy), [xxx's attributes])
    #
    # In shell:
    #
    #   alf matching suppliers supplies 
    #  
    class Matching < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      #
      # Performs a Matching of two relations through a Hash buffer on the right
      # one.
      #
      class HashBased
        include Operator, Operator::Binary
      
        # (see Operator#_each)
        def _each
          seen, key = nil, nil
          left.each do |left_tuple|
            seen ||= begin
              h = Hash.new
              right.each do |right_tuple|
                key ||= coerce(left_tuple.keys & right_tuple.keys, ProjectionKey)
                h[key.project(right_tuple)] = true
              end
              key ||= coerce([], ProjectionKey)
              h
            end
            yield(left_tuple) if seen.has_key?(key.project(left_tuple))
          end
        end
        
      end # class HashBased
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class Matching
        
    # 
    # Relational not matching
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [LEFT] RIGHT
    #
    # API & EXAMPLE
    #
    #   (not_matching :suppliers, :supplies)
    #
    # DESCRIPTION
    #
    # This operator restricts left tuples to those for which there does not 
    # exist any right tuple that joins. This is a shortcut operator for the
    # longer expression: 
    #
    #         (minus xxx, (matching xxx, yyy))
    # 
    # In shell:
    #
    #   alf not-matching suppliers supplies 
    #  
    class NotMatching < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Binary
      
      signature []
      
      #
      # Performs a NotMatching of two relations through a Hash buffer on the 
      # right one.
      #
      class HashBased
        include Operator, Operator::Binary
      
        # (see Operator#_each)
        def _each
          seen, key = nil, nil
          left.each do |left_tuple|
            seen ||= begin
              h = Hash.new
              right.each do |right_tuple|
                key ||= coerce(left_tuple.keys & right_tuple.keys, ProjectionKey)
                h[key.project(right_tuple)] = true
              end
              key ||= coerce([], ProjectionKey)
              h
            end
            yield(left_tuple) unless seen.has_key?(key.project(left_tuple))
          end
        end
        
      end # class HashBased
      
      protected
      
      # (see Shortcut#longexpr)
      def longexpr
        chain HashBased.new,
              datasets 
      end
      
    end # class NotMatching
    
    # 
    # Relational wraping (tuple-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... -- NEWNAME
    #
    # API & EXAMPLE
    #
    #   (wrap :suppliers, [:city, :status], :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator wraps attributes ATTR1 to ATTRN as a new, tuple-based
    # attribute whose name is NEWNAME. When used in shell, names of wrapped 
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf wrap suppliers -- city status -- loc_and_status
    #
    class Wrap < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature [
        [:attributes, ProjectionKey, []],
        [:as, AttrName, :wrapped]
      ]
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        wrapped, others = @attributes.split(tuple)
        others[@as] = wrapped
        others
      end
  
    end # class Wrap
  
    # 
    # Relational un-wraping (inverse of wrap)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
    #
    # API & EXAMPLE
    #
    #   # Assuming wrapped = (wrap :suppliers, [:city, :status], :loc_and_status) 
    #   (unwrap wrapped, :loc_and_status)
    #
    # DESCRIPTION
    #
    # This operator unwraps the tuple-valued attribute named ATTR so as to 
    # flatten its pairs with 'upstream' tuple. The latter should be such so that
    # no name collision occurs. When used in shell, the name of the attribute to
    # unwrap is taken as the first commandline argument:
    #
    #   alf unwrap wrap -- loc_and_status
    #
    class Unwrap < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Transform
  
      signature [
        [:attribute, AttrName, :wrapped]
      ]
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        tuple = tuple.dup
        wrapped = tuple.delete(@attribute) || {}
        tuple.merge(wrapped)
      end
  
    end # class Unwrap
  
    # 
    # Relational grouping (relation-valued attributes)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR1 ATTR2 ... -- NEWNAME
    #
    # API & EXAMPLE
    #
    #   (group :supplies, [:pid, :qty], :supplying)
    #   (group :supplies, [:sid], :supplying, true)
    #
    # DESCRIPTION
    #
    # This operator groups attributes ATTR1 to ATTRN as a new, relation-valued
    # attribute whose name is NEWNAME. When used in shell, names of grouped
    # attributes are taken from commandline arguments, expected the last one
    # which defines the new name to use:
    #
    #   alf group supplies -- pid qty -- supplying
    #   alf group supplies --allbut -- sid -- supplying
    #
    class Group < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature [
        [:attributes, ProjectionKey, []],
        [:as, AttrName, :group]
      ]
      
      # Creates a Group instance
      def initialize(attributes = [], as = :group, allbut = false)
        @attributes = coerce(attributes, ProjectionKey)
        @as = coerce(as, AttrName)
        @allbut = allbut
      end
  
      options do |opt|
        opt.on('--allbut', "Group all but specified attributes"){ 
          @allbut = true 
        }
      end
      
      protected 
  
      # See Operator#_prepare
      def _prepare
        @index = Hash.new{|h,k| h[k] = Set.new} 
        each_input_tuple do |tuple|
          key, rest = @attributes.split(tuple, !@allbut)
          @index[key] << rest
        end
      end
  
      # See Operator#_each
      def _each
        @index.each_pair do |k,v|
          yield(k.merge(@as => Relation.coerce(v)))
        end
      end
  
    end # class Group
  
    # 
    # Relational un-grouping (inverse of group)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] -- ATTR
    #
    # API & EXAMPLE
    #
    #   # Assuming grouped = (group enum, [:pid, :qty], :supplying)
    #   (ungroup grouped, :supplying)
    #
    # DESCRIPTION
    #
    # This operator ungroups the relation-valued attribute named ATTR and outputs
    # tuples as the flattening of each of of its tuples merged with the upstream
    # one. Sub relation should be such so that no name collision occurs. When 
    # used in shell, the name of the attribute to ungroup is taken as the first 
    # commandline argument:
    #
    #   alf ungroup group -- supplying
    #
    class Ungroup < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Unary
      
      signature [
        [:attribute, AttrName, :wrapped]
      ]
      
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
    # Relational summarization (group-by + aggregate ops)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] [--allbut] --by=KEY1,KEY2... -- AGG1 EXPR1...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   (summarize :supplies, [:sid],
    #                         :total_qty => Aggregator.sum(:qty))
    #
    #   # Or, to specify an allbut projection
    #   (summarize :supplies, [:qty, :pid],
    #                         :total_qty => Aggregator.sum(:qty), true)
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
    #   alf summarize supplies --by=sid -- total_qty "sum(:qty)" 
    #   alf summarize supplies --allbut --by=pid,qty -- total_qty "sum(:qty)" 
    #
    class Summarize < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
      
      signature [
        [:summarization, Summarization, {}]
      ]
      
      def initialize(by = [], summarization = {}, allbut = false)
        @by = coerce(by, ProjectionKey)
        @summarization = coerce(summarization, Summarization)
        @allbut = allbut
      end
  
      # Installs the options
      options do |opt|
        opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
          @by = coerce(args, ProjectionKey)
        end
        opt.on('--allbut', 'Make an allbut projection/summarization') do
          @allbut = true
        end
      end
  
      # Summarizes according to a complete order
      class SortBased
        include Operator, Operator::Cesure      
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end
  
        protected 
  
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project(tuple, @allbut)
        end
        
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @aggs = @summarization.least
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @aggs = @summarization.happens(@aggs, tuple)
        end
  
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @aggs = @summarization.finalize(@aggs)
          receiver.call key.merge(@aggs)
        end
  
      end # class SortBased

      # Summarizes in-memory with a hash
      class HashBased
        include Operator, Operator::Relational, Operator::Unary
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end

        protected
        
        def _each
          index = Hash.new{|h,k| @summarization.least}
          each_input_tuple do |tuple|
            key, rest = @by_key.split(tuple, @allbut)
            index[key] = @summarization.happens(index[key], tuple)
          end
          index.each_pair do |key,aggs|
            yield key.merge(@summarization.finalize(aggs))
          end
        end
      
      end
        
      protected 
      
      def longexpr
        if @allbut
          chain HashBased.new(@by, @allbut, @summarization),
                datasets
        else
          chain SortBased.new(@by, @allbut, @summarization),
                Operator::NonRelational::Sort.new(@by.to_ordering_key),
                datasets
        end
      end
  
    end # class Summarize
  
    # 
    # Relational ranking (explicit tuple positions)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] --order=OR1... -- [RANKNAME]
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   # Position attribute => # of tuples with smaller weight 
    #   (rank :parts, [:weight], :position)
    #    
    #   # Position attribute => # of tuples with greater weight 
    #   (rank :parts, [[:weight, :desc]], :position)
    #
    # DESCRIPTION
    #
    # This operator computes the ranking of input tuples, according to an order
    # relation. Precisely, it extends the input tuples with a RANKNAME attribute
    # whose value is the number of tuples which are considered strictly less
    # according to the specified order. For the two examples above:
    #
    #   alf rank parts --order=weight -- position
    #   alf rank parts --order=weight,desc -- position
    #
    # Note that, unless the ordering key includes a candidate key for the input
    # relation, the newly RANKNAME attribute is not necessarily a candidate key
    # for the output one. In the example above, adding the :pid attribute 
    # ensured that position will contain all different values: 
    #
    #   alf rank parts --order=weight,pid -- position
    # 
    # Or even:
    #
    #   alf rank parts --order=weight,desc,pid,asc -- position
    #
    class Rank < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Shortcut, Operator::Unary
  
      signature [
        [:ranking_name, AttrName, :rank]
      ]
      
      def initialize(order = [], ranking_name = :rank)
        @order = coerce(order, OrderingKey)
        @ranking_name = coerce(ranking_name, AttrName)
      end
  
      options do |opt|
        opt.on('--order=x,y,z', 'Specify ranking order', Array) do |args|
          @order = coerce(args, OrderingKey)
        end
      end
  
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(order, ranking_name)
          @by_key = ProjectionKey.coerce(order)
          @ranking_name = ranking_name
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project(tuple, false)
        end
    
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @rank ||= 0
          @last_block = 0
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          receiver.call tuple.merge(@ranking_name => @rank)
          @last_block += 1
        end
        
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @rank += @last_block
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        chain SortBased.new(@order, @ranking_name),
              Operator::NonRelational::Sort.new(@order),
              datasets
      end 
  
    end # class Rank
    
    # 
    # Relational quota-queries (position, sum progression, etc.)
    #
    # SYNOPSIS
    #   #{program_name} #{command_name} [OPERAND] --by=KEY1,... --order=OR1... -- AGG1 EXPR1...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # API & EXAMPLE
    #
    #   (quota :supplies, [:sid], [:qty],
    #                     :position => Aggregator.count,
    #                     :sum_qty  => Aggregator.sum(:qty))
    #
    # DESCRIPTION
    #
    # This operator computes quota values on input tuples.
    #
    #   alf quota supplies --by=sid --order=qty -- position count sum_qty "sum(:qty)"
    #
    class Quota < Alf::Operator(__FILE__, __LINE__)
      include Operator::Relational, Operator::Experimental,
              Operator::Shortcut, Operator::Unary
  
      signature [
        [:summarization, Summarization, {}]
      ]
      
      def initialize(by = [], order = [], summarization = {})
        @by = coerce(by, ProjectionKey)
        @order = coerce(order, OrderingKey)
        @summarization = coerce(summarization, Summarization)
      end
  
      options do |opt|
        opt.on('--by=x,y,z', 'Specify by attributes', Array) do |args|
          @by = coerce(args, ProjectionKey)
        end
        opt.on('--order=x,y,z', 'Specify order attributes', Array) do |args|
          @order = coerce(args, OrderingKey)
        end
      end
  
      class SortBased
        include Operator, Operator::Cesure
        
        def initialize(by, order, summarization)
          @by, @order, @summarization  = by, order, summarization
        end
        
        protected
        
        # (see Operator::Cesure#project)
        def project(tuple)
          @by.project(tuple, false)
        end
        
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @aggs = @summarization.least
        end
    
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @aggs = @summarization.happens(@aggs, tuple)
          receiver.call tuple.merge(@summarization.finalize(@aggs))
        end
  
      end # class SortBased
  
      protected
      
      def longexpr
        sort_key = @by.to_ordering_key + @order
        chain SortBased.new(@by, @order, @summarization),
              Operator::NonRelational::Sort.new(sort_key),
              datasets
      end 
  
    end # class Quota
  
  end

  #
  # Aggregation operator.
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
      basename = Tools.ruby_case(Tools.class_name(clazz))
      instance_eval <<-EOF
        def #{basename}(*args, &block)
          #{clazz}.new(*args, &block)
        end
      EOF
    end

    #
    # Coerces `arg` as an Aggregator
    #
    def self.coerce(arg)
      case arg
      when Aggregator
        arg
      when String
        instance_eval(arg)
      else
        raise ArgumentError, "Invalid arg `arg` for Aggregator()"
      end
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
      @handle = Tools::TupleHandle.new
      @options = default_options.merge(options)
      @functor = Tools.coerce(attribute || block, TupleExpression)
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
      _happens(memo, @functor.evaluate(@handle.set(tuple)))
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
    class Group < Aggregator
      def initialize(*attrs)
        super(nil, {}){
          Tools.tuple_collect(attrs){|k| [k, self.send(k)] }
        }
      end
      def least(); Set.new; end
      def _happens(memo, val)
        memo << val
      end
      def finalize(memo)
        Relation.coerce memo
      end
    end
    
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
  
  #
  # Base class for implementing buffers.
  # 
  class Buffer
  
    # 
    # Keeps tuples ordered on a specific key
    #
    # Example:
    #
    #   sorted = Buffer::Sorted.new OrderingKey.new(...)
    #   sorted.add_all(...)
    #   sorted.each do |tuple|
    #     # tuples are ordered here 
    #   end
    #
    class Sorted < Buffer
  
      #
      # Creates a buffer instance with an ordering key
      #
      def initialize(ordering_key)
        @ordering_key = ordering_key
        @buffer = []
      end
  
      #
      # Adds all elements of an iterator to the buffer
      #
      def add_all(enum)
        sorter = @ordering_key.sorter
        @buffer = merge_sort(@buffer, enum.to_a.sort(&sorter), sorter)
      end
  
      #
      # (see Buffer#each)
      #
      def each
        @buffer.each(&Proc.new)
      end
  
      private
    
      # Implements a merge sort between two iterators s1 and s2
      def merge_sort(s1, s2, sorter)
        (s1 + s2).sort(&sorter)
      end
  
    end # class Buffer::Sorted
    
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
