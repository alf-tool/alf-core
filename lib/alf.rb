[ "alf-csv", "alf-sequel", "alf-logs", "alf-yaml" ].each do |contrib|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), contrib))
end

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
  require 'alf/aggregator'
  require 'alf/buffer'
  require 'alf/relation'
  require 'alf/lispy'

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
require "alf/sequel"
require 'alf/yaml'
require 'alf/csv'
require 'alf/logs'
