require_relative "alf/version"
require_relative "alf/loader"
require_relative "alf/errors"

require "enumerator"
require "stringio"
require "set"

require 'myrrha/to_ruby_literal'
require 'myrrha/coerce'

require_relative 'alf/types'
require_relative 'alf/tools'
require_relative 'alf/environment'
require_relative 'alf/iterator'
require_relative 'alf/reader'
require_relative 'alf/renderer'
require_relative 'alf/operator'
require_relative 'alf/aggregator'
require_relative 'alf/lang'
require_relative 'alf/relation'
require_relative 'alf/lispy'
require_relative 'alf/ext'

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf

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

  # Loads `source` as an in-memory Relation instance.
  #
  # @param [...] source a String, a Path or an IO denoting a relation physical source.
  # @param [Array] args optional reader arguments
  # @return [Relation] a relation instance loaded from `source`
  # @raise [ArgumentError] if `source` is not recognized or no reader can be found.
  #
  def self.load(source, *args)
    reader(source, *args).to_relation
  end

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

  #
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
  def self.Relation(*args)
    Alf::Tools.to_relation(*args)
  end

end # module Alf

require_relative 'alf-shell/alf/shell'
require_relative "alf-engine/alf/engine"
require_relative "alf-sequel/alf/sequel"
require_relative 'alf-yaml/alf/yaml'
require_relative 'alf-csv/alf/csv'
require_relative 'alf-logs/alf/logs'
