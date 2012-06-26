require_relative 'lang/algebra'
require_relative 'lang/aggregation'
require_relative 'lang/literals'
module Alf
  module Lang
    include Algebra
    include Aggregation
    include Literals

  end # module Lang
end # module Alf
require_relative 'lang/lispy'
