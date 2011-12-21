module Alf
  #
  # Marker module and namespace for Alf main commands, those that are **not** 
  # operators at all.
  #
  module Command
    require 'alf/command/class_methods'
    require 'alf/command/doc_manager'

    # This is the main documentation extractor
    DOC_EXTRACTOR = DocManager.new

    #
    # Delegator command factory
    #
    def Alf.Delegator() 
      Quickl::Delegator(){|builder|
        builder.doc_extractor = DOC_EXTRACTOR
        yield(builder) if block_given?
      }
    end

    #
    # Command factory
    #
    def Alf.Command() 
      Quickl::Command(){|builder|
        builder.command_parent = Alf::Command::Main
        builder.doc_extractor  = DOC_EXTRACTOR
        yield(builder) if block_given?
      }
    end

    require 'alf/command/main'
    require 'alf/command/exec'
    require 'alf/command/help'
    require 'alf/command/show'
  end # module Command
end # module Alf
