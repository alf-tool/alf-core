module Alf
  class Database
    class Options < Support::Config

      # Cache results of native schema queries?
      option :schema_cache, Boolean, true

      # What viewpoint to use by default?
      option :viewpoint, Module, Viewpoint::NATIVE

      alias :default_viewpoint  :viewpoint
      alias :default_viewpoint= :viewpoint=

      # Path to a folder where debugging graphs can be found
      option :debug_folder, Path, nil

      # A lambda that names .dot files
      option :debug_naming, Proc, lambda{|x| Time.now.strftime("%Y%m%d-%H%M%S-%6N") }

      # Where migrations are located
      option :migrations_folder, Path, nil

    end # class Options
  end # class Database
end # module Alf