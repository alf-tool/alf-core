module Alf
  module Engine

    Cogable = lambda{|arg| arg.respond_to?(:to_cog) }

  end # module Engine
end # module Alf
require_relative 'engine/cog'
require_relative 'engine/support/cesure'

require_relative 'engine/leaf'
require_relative 'engine/autonum'
require_relative 'engine/clip'
require_relative 'engine/coerce'
require_relative 'engine/generator'
require_relative 'engine/compact'
require_relative 'engine/defaults'
require_relative 'engine/sort'
require_relative 'engine/set_attr'
require_relative 'engine/filter'
require_relative 'engine/hierarchize'
require_relative 'engine/concat'
require_relative 'engine/aggregate'
require_relative 'engine/rename'
require_relative 'engine/materialize'
require_relative 'engine/group'
require_relative 'engine/join'
require_relative 'engine/semi'
require_relative 'engine/wrap'
require_relative 'engine/unwrap'
require_relative 'engine/summarize'
require_relative 'engine/rank'
require_relative 'engine/quota'
require_relative 'engine/take'
require_relative 'engine/ungroup'
require_relative 'engine/infer_heading'
require_relative 'engine/type_safe'
require_relative 'engine/to_array'
