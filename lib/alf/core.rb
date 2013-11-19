require_relative 'core/loader'
require_relative 'core/version'
require_relative 'errors'
require_relative 'ext'
require_relative 'facade'

module Alf
  TupleLike    = lambda{|t| t.is_a?(Hash) || t.is_a?(Tuple) }
  RelationLike = lambda{|r| Relation===r || Engine::Cog===r || Reader===r || Relvar===r }
end

require_relative 'predicate'
require_relative 'support'
require_relative 'types'
require_relative 'aggregator'
require_relative 'algebra'
require_relative 'compiler'
require_relative 'engine'
require_relative 'reader'
require_relative 'renderer'
require_relative 'lang'
require_relative 'relation'
require_relative 'relvar'
require_relative 'optimizer'
require_relative 'update'
require_relative 'adapter'
require_relative 'viewpoint'
require_relative 'database'
require_relative 'adapter/fs'

module Alf
  extend Facade

  DUM = Relation::DUM
  DEE = Relation::DEE
end

require_relative 'dsl'
include Alf::Dsl unless defined?(ALF_NO_CORE_EXTENSIONS)
