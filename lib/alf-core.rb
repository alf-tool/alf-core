require_relative 'alf-core/loader'
require_relative 'alf-core/version'
require_relative 'alf-core/errors'
require_relative 'alf-core/ext'
require_relative 'alf-core/facade'

module Alf
  TupleLike    = lambda{|t| t.is_a?(Hash) || t.is_a?(Tuple) }
  RelationLike = lambda{|r| Relation===r || Engine::Cog===r || Reader===r || Relvar===r }
end

require_relative 'alf-predicate/alf/predicate'
require_relative 'alf-support/alf/support'
require_relative 'alf-types/alf/types'
require_relative 'alf-aggregator/alf/aggregator'
require_relative 'alf-algebra/alf/algebra'
require_relative "alf-engine/alf/engine"
require_relative 'alf-io/alf/io'
require_relative 'alf-lang/alf/lang'
require_relative 'alf-relation/alf/relation'
require_relative 'alf-relvar/alf/relvar'
require_relative 'alf-optimizer/alf/optimizer'
require_relative 'alf-update/alf/update'
require_relative 'alf-adapter/alf/adapter'
require_relative 'alf-viewpoint/alf/viewpoint'
require_relative 'alf-database/alf/database'
require_relative 'alf-shell/alf/shell'
require_relative 'alf-adapter-fs/alf/adapter/fs'

module Alf
  extend Facade

  DUM = Relation::DUM
  DEE = Relation::DEE
end

require_relative 'alf-core/dsl'
include Alf::Dsl unless defined?(ALF_NO_CORE_EXTENSIONS)
