module Alf
  class Database
    class Options < Support::Config

      # Cache results of native schema queries?
      option :schema_cache, Boolean, true

      # What viewpoint to use by default?
      option :default_viewpoint, Module, Viewpoint::NATIVE

    end # class Options
  end # class Database
end # module Alf