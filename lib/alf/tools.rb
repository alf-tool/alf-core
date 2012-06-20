module Alf
  #
  # Provides tooling methods that are used here and there in Alf.
  #
  module Tools

    extend Tools
  end # module Tools
end # module Alf
require_relative 'tools/coerce'
require_relative 'tools/to_ruby_literal'
require_relative 'tools/to_lispy'
require_relative 'tools/to_relation'
require_relative 'tools/tuple_handle'
require_relative 'tools/miscellaneous'
