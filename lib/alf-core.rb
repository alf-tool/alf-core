require_relative 'alf/core/loader'
require_relative 'alf/core/version'
require_relative 'alf/errors'
require_relative 'alf/ext'
require_relative 'alf/facade'

module Alf
  TupleLike    = lambda{|t| t.is_a?(Hash) || t.is_a?(Tuple) }
  RelationLike = lambda{|r| Relation===r || Engine::Cog===r || Reader===r || Relvar===r }
end

require_relative 'alf/predicate'
require_relative 'alf/support'
require_relative 'alf/types'
require_relative 'alf/aggregator'
require_relative 'alf/algebra'
require_relative 'alf/compiler'
require_relative "alf/engine"
require_relative 'alf/reader'
require_relative 'alf/renderer'
require_relative 'alf/lang'
require_relative 'alf/relation'
require_relative 'alf/relvar'
require_relative 'alf/optimizer'
require_relative 'alf/update'
require_relative 'alf/adapter'
require_relative 'alf/viewpoint'
require_relative 'alf/database'
require_relative 'alf/adapter/fs'

module Alf
  extend Facade

  DUM = Relation::DUM
  DEE = Relation::DEE
end

require_relative 'alf/dsl'
include Alf::Dsl unless defined?(ALF_NO_CORE_EXTENSIONS)
