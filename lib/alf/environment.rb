module Alf
  #
  # An environment encapsulates the interface with the outside world, providing 
  # base iterators for named datasets.
  #
  # An environment is typically obtained through the factory defined by this
  # class:
  #
  #   # Returns the default environment (examples, for now)
  #   Alf::Environment.default
  #
  #   # Returns an environment on Alf's examples
  #   Alf::Environment.examples
  #
  #   # Returns an environment on a specific folder, automatically
  #   # resolving datasources via recognized file extensions (see Reader)
  #   Alf::Environment.folder('path/to/a/folder')
  #
  # You can implement your own environment by subclassing this class and 
  # implementing the {#dataset} method. As additional support is implemented 
  # in the base class, Environment should never be mimiced.
  #
  # This class provides an extension point allowing to participate to auto 
  # detection and resolving of the --env=... option when alf is used in shell.
  # See Environment.register, Environment.autodetect and Environment.recognizes?
  # for details. 
  # 
  class Environment
    require 'alf/environment/class_methods'
    require 'alf/environment/instance_methods'
    require 'alf/environment/folder'

  end # class Environment
end # module Alf
