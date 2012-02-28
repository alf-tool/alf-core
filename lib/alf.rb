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
  require 'alf/operator'
  require 'alf-shell/alf/shell'
  require 'alf/aggregator'
  require 'alf/relation'
  require 'alf/lispy'
  require 'alf/ext'

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

require_relative "alf-engine/alf/engine"
require_relative "alf-sequel/alf/sequel"
require_relative 'alf-yaml/alf/yaml'
require_relative 'alf-csv/alf/csv'
require_relative 'alf-logs/alf/logs'
