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

#
# Classy data-manipulation dressed in a DSL (+ commandline)
#
module Alf

  TupleLike    = lambda{|t| t.is_a?(Hash) || t.is_a?(Tuple) }
  RelationLike = lambda{|r| Relation===r || Engine::Cog===r || Reader===r || Relvar===r }

  def self.database(*args, &bl)
    Database.new(*args, &bl)
  end

  def self.connect(*args, &bl)
    Database.connect(*args, &bl)
  end

  def self.examples(&bl)
    Database.connect Path.backfind('examples/suppliers_and_parts'), &bl
  end

  def self.reader(source, *args)
    Alf::Reader.reader(source, *args)
  end

  def self.Relation(*args, &bl)
    Alf::Relation.coerce(*args, &bl)
  end

  def self.Tuple(*args, &bl)
    tuple = Alf::Tuple.coerce(*args)
    tuple = tuple.remap(&bl) if bl
    tuple
  end

  def self.Heading(*args, &bl)
    Alf::Heading.coerce(*args, &bl)
  end

end # module Alf

require_relative "alf-predicate/alf/predicate"
require_relative 'alf-support/alf/support'
require_relative 'alf-types/alf/types'
require_relative 'alf-aggregator/alf/aggregator'
require_relative 'alf-algebra/alf/algebra'
require_relative "alf-engine/alf/engine"
require_relative 'alf-io/alf/io'
require_relative "alf-lang/alf/lang"
require_relative 'alf-relation/alf/relation'
require_relative 'alf-relvar/alf/relvar'
require_relative "alf-optimizer/alf/optimizer"
require_relative "alf-update/alf/update"
require_relative "alf-adapter/alf/adapter"
require_relative 'alf-viewpoint/alf/viewpoint'
require_relative "alf-database/alf/database"
require_relative 'alf-shell/alf/shell'
require_relative "alf-adapter-fs/alf/adapter/fs"

module Alf
  DUM = Relation::DUM
  DEE = Relation::DEE
end
require_relative 'alf/ext'
