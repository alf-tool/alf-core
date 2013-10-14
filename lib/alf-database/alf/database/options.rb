module Alf
  class Database
    class Options < Support::Config

      # Cache results of native schema queries?
      option :schema_cache, Boolean, true

      # What viewpoint to use by default?
      option :viewpoint, Module, Viewpoint::NATIVE

      # What parser (class) to use for parsing expressions
      option :parser, Class, Lang::Parser::Lispy

      # Where migrations are located
      option :migrations_folder, Path, nil

    end # class Options
  end # class Database
end # module Alf
