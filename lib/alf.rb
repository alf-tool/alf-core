require "alf/version"
require "alf/loader"
require "alf/errors"

require "enumerator"
require "stringio"
require "set"
require "forwardable"
require 'time'

require 'myrrha/to_ruby_literal'
require 'myrrha/coerce'

require_relative "alf-predicate/alf/predicate"
require_relative 'alf-types/alf/types'
require_relative 'alf-support/alf/support'
require_relative 'alf-aggregator/alf/aggregator'
require_relative 'alf/iterator'
require_relative 'alf-io/alf/io'
require_relative 'alf-csv/alf/csv'
require_relative 'alf/operator'
require_relative "alf-lang/alf/lang"

require_relative 'alf/relation'
require_relative 'alf/relvar'

require_relative 'alf/schema'
require_relative 'alf/connection'

require_relative 'alf/ext'

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf

  # Connects to a database instance from `args`.
  #
  # Alf::Connection's autodetection system is used here to choose which connection
  # handler to use.
  #
  # @param [Array] args arguments for the Connection constructor
  # @return [Connection] an connection instance
  # @raise [ArgumentError] when no registered class recognizes the arguments
  #
  # @see Connection.connect for more about recognized formats.
  #
  def self.connect(*args, &block)
    Connection.connect(*args, &block)
  end

  # Connects to the examples database.
  #
  # @return [Connection] a connection to the examples database
  #
  # @see connect for more about recognized formats.
  def self.examples(&bl)
    Connection.connect Path.backfind('examples/suppliers_and_parts'), &bl
  end

  # Connects to the default database.
  #
  # @return [Connection] a connection to the default database
  #
  # @see connect for more about recognized formats.
  def self.default(&bl)
    Connection.connect Path.pwd, &bl
  end

  # Returns a Reader on `source` denoting a physical representation of a relation.
  #
  # @param [...]     source a String, a Path or an IO denoting a relation physical source.
  # @param [Array]   args optional reader arguments
  # @return [Reader] a reader instance built from arguments
  # @raise [ArgumentError] if `source` is not recognized or no reader can be found.
  #
  # @see Alf::Reader for more about readers.
  #
  def self.reader(source, *args)
    Alf::Reader.reader(source, *args)
  end

  # Coerces some arguments to a relation.
  #
  # The following coercions are supported:
  #
  #   Alf::Relation(x)
  #   # x.to_relation if it exists
  #
  #   Alf::Relation(:attr => [val1, ..., valn])
  #   # Relation([{:attr => val1}, ..., {:attr => valn}])
  #
  #   Alf::Relation(:attr1 => val1, ..., :attrn => valn)
  #   # Relation([{:attr1 => val1, ..., :attrn => valn}])
  #
  #   Alf::Relation([ {...}, ..., {...} ])
  #   # the common coercion from an array of tuples
  #
  #   Alf::Relation(Path)
  #   Alf::Relation(IO)
  #   # loaded through available readers
  #
  def self.Relation(*args, &bl)
    Alf::Support.to_relation(*args, &bl)
  end

  # Coerces some arguments to a tuple.
  #
  # The following coercions are supported:
  #
  #   Alf::Tuple(:attr1 => val1, ..., :attrn => valn)
  #   # the same Hash
  #
  #   Alf::Tuple('attr1' => val1, ..., 'attrn' => valn)
  #   # the same Hash with symbolized keys
  #
  def self.Tuple(*args, &bl)
    Alf::Support.to_tuple(*args, &bl)
  end

  # Coerces some arguments to a heading.
  #
  def self.Heading(*args, &bl)
    Alf::Heading.coerce(*args, &bl)
  end

  class << self
    alias :relation :Relation
  end

  DUM = Relation::DUM
  DEE = Relation::DEE
end # module Alf

require_relative 'alf-shell/alf/shell'
require_relative "alf-engine/alf/engine"
require_relative "alf-optimizer/alf/optimizer"
require_relative "alf-update/alf/update"
require_relative 'alf/platform'

